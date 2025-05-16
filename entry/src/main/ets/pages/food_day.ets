import router from '@ohos.router';
import { AppKeys } from '../common/Constants';
import http from '@ohos.net.http';


// 定义接收的参数类型
interface RecipeFormData {
  // 食品id
  id?: string;

  // 食谱日期
  recipeDate?: string;

  // 食谱名称
  dishName?: string;

  // 餐别
  mealCategory_dictText?: string;

  // 用餐类型
  sampleType_dictText?: string;

  // 餐厅
  demandUnitName?: string;

  // 图片地址
  recipeImg?: string;
}

interface Data {
  records: RecipeFormData[];
  total: number;
}

interface ResponseData {
  success:  boolean;
  message: string;
  code:number
  result:Data|null
}

async function SearchFood(TenantId:string, Token:string): Promise<ResponseData>{
  try {
    const httpRequest = http.createHttp()
    const response = await httpRequest.request(
      `https://api.suoeryun.com/ifood/jeecg-school/school/xxRecipeReported/list`,
      {
        method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json',
          'Tenant-Id':TenantId,
          'X-Access-Token':Token
        }
      }
    )
    if (response.responseCode !== 200) {
      console.log('HTTP Error12:', response.responseCode)
      return {
        success: false,
        message: `HTTP Error: ${response.responseCode}`,
        code:response.responseCode,
        result:null
      }
    }
    const Data = JSON.parse(response.result as string) as ResponseData;
    return Data;

  }catch (e){
    return {
      success: false,
      message: `HTTP Error1: ${e}`,
      code:0,
      result:null
    }
  }
}

async function DeleteById(TenantId:string, Token:string, Id?:string): Promise<void> {
  try {
    const httpRequest = http.createHttp()
    const response = await httpRequest.request(
      'https://api.suoeryun.com/ifood/jeecg-school/school/xxRecipeReported/delete',
      {
        method: http.RequestMethod.DELETE,
        header: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Tenant-Id': TenantId,
          'X-Access-Token': Token
        },
        extraData: `id=${Id}`
      }
    )

    if (response.responseCode !== 200) {
      console.log('HTTP Error:', response.responseCode)
    }
  } catch (e) {
    console.log('HTTP Error:', e)
  }
}

@Entry
@Component
struct food_day {
  private selectDate: Date = new Date()
  @State selectedMeal: string = '请选择餐别'
  @State selectedDate: string = '请选择筛选日期'
  private unitOptions = ['其他', '早餐', '午餐', '晚餐']
  private mealCategory :string = '0'
  @State formDataList: RecipeFormData[] = [] // 改为数组存储多条数据
  @State TempFormDataList: RecipeFormData[] = [] // 改为数组存储多条数据

  @StorageLink(AppKeys.TOKEN) storageToken: string = '';
  @StorageLink(AppKeys.TENANT_ID) storageTenantId: number = 0;

  async onPageShow() {

    const data = await SearchFood(this.storageTenantId.toString(), this.storageToken)
    if(data.result){
      this.formDataList = data.result.records
      this.TempFormDataList = this.formDataList

      if(this.selectedMeal != '请选择餐别' && this.selectedDate != '请选择筛选日期')//两个条件都选了
        this.formDataList = this.formDataList.filter((item:RecipeFormData) => item.mealCategory_dictText == this.selectedMeal && item.recipeDate == this.selectedDate)
      else if(this.selectedMeal != '请选择餐别' && this.selectedDate == '请选择筛选日期')//餐别条件选了
        this.formDataList = this.formDataList.filter((item:RecipeFormData) => item.mealCategory_dictText == this.selectedMeal)
      else if(this.selectedMeal == '请选择餐别' && this.selectedDate != '请选择筛选日期')//日期条件选了
        this.formDataList = this.formDataList.filter((item:RecipeFormData) => item.recipeDate == this.selectedDate)

    }

  }

  build() {
    Column() {
      // 顶部选择栏
      Column() {
        Row() {
          Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
            .value(this.selectedMeal)
            .onSelect(async (index: number) => {
              this.formDataList = this.TempFormDataList

              this.selectedMeal = this.unitOptions[index]

              if(this.selectedDate!= '请选择筛选日期'){
                console.log(this.selectedDate)
                this.formDataList = this.formDataList.filter((item:RecipeFormData) => item.mealCategory_dictText == this.selectedMeal && item.recipeDate == this.selectedDate)
              }
              else{
                this.formDataList = this.formDataList.filter((item:RecipeFormData) => item.mealCategory_dictText == this.selectedMeal)
              }

            })
            .margin(10)
            .width('40%')
            .height(40)
            .font({ size: 15 })

          Text(this.selectedDate)
            .width('60%')
            .height(40)
            .textAlign(TextAlign.Center)
            .borderRadius(4)
            .borderWidth(1)
            .borderColor('#CCCCCC')
            .onClick(() => {
              this.showDateDialog()
            })
        }
        .width('100%')
        .margin({ bottom: 15 })

        // 数据展示区
        if (this.formDataList.length > 0) {
          List() {
            ForEach(this.formDataList, (formData: RecipeFormData) => {
              ListItem() {
                Column() {
                  Text(`食谱日期：${formData.recipeDate}`)
                    .width('100%')
                    .fontSize(20)
                    .margin({ top: 10, bottom: 10 })
                  Text(`食谱名称：${formData.dishName}`)
                    .fontSize(20)
                    .width('100%')
                    .margin({ bottom: 10 })
                  Text(`餐    别：${formData.mealCategory_dictText}`)
                    .fontSize(20)
                    .width('100%')
                    .margin({ bottom: 10 })
                  Text(`用餐类型：${formData.sampleType_dictText}`)
                    .fontSize(20)
                    .width('100%')
                    .margin({ bottom: 10 })
                  Text(`餐    厅：${formData.demandUnitName}`)
                    .fontSize(20)
                    .width('100%')
                    .margin({ bottom: 10 })
                  if (formData.recipeImg) {
                    Image(formData.recipeImg)
                      .width('80%')
                      .height(120)
                      .margin({ top: 10, bottom: 10,right:'20%' })
                  }
                  Row({ space: 20 }) {
                    Button('重新编辑')
                      .margin({left:'35%'})
                      .backgroundColor(Color.White)
                      .fontColor('#00C853')
                      .border({ color: '#00C853', width: 2 })
                      .width('30%')
                      .onClick(() => {
                        router.pushUrl({
                          url: 'pages/food_day_new',
                          params: formData
                        })
                      })
                    Button('删除单据')
                      .backgroundColor(Color.White)
                      .fontColor('#00C853')
                      .border({ color: '#00C853', width: 2 })
                      .width('30%')
                      .onClick(async () => {
                        DeleteById(this.storageTenantId.toString(), this.storageToken, formData.id)
                        const newData = await SearchFood(this.storageTenantId.toString(), this.storageToken)
                        if(newData.result){
                          this.formDataList = newData.result.records
                        }
                      })
                  }
                  .width('100%')
                  .margin({ top: 30 })
                }
                .backgroundColor('#fff')
                .borderRadius(20)
                .borderWidth(2)
                .borderColor('#07C160')
                .margin({ top: 10, bottom: 10, left: 10, right: 10 })
                .padding(20)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          // 下拉回弹效果
        } else {
          Column() {
            Text('- 暂无相关数据 -')
              .position({
                x: 110,
                y: 180
              })
          }
        }
      }

      .layoutWeight(1)


      // 新建食谱按钮
      Button('新建食谱', { type: ButtonType.Capsule })
        .width('100%')
        .height(50)
        .backgroundColor('#07C160')
        .fontColor('#FFFFFF')
        .margin({ top: 20 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/food_day_new'
          });
        })
    }
    .width('100%')
    .padding({ left: 10, right: 10 })
  }

  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: async (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()

        this.selectDate = new Date(year, month - 1, day)
        this.selectedDate = `${year}-${(month+1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`

        this.formDataList = this.TempFormDataList

        if(this.selectedMeal != '请选择餐别'){
          console.log(this.selectedMeal)
          this.formDataList = this.formDataList.filter((item:RecipeFormData) => item.mealCategory_dictText == this.selectedMeal && item.recipeDate == this.selectedDate)
        }
        else{
          this.formDataList = this.formDataList.filter((item:RecipeFormData) => item.recipeDate == this.selectedDate)
        }
      }

    })
  }
}


