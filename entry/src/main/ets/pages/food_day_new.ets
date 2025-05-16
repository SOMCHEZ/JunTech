import prompt from '@ohos.prompt';
import router from '@ohos.router';
import { Router } from '@kit.ArkUI';
import picker from '@ohos.file.picker';
import http from '@ohos.net.http';
import { AppKeys } from '../common/Constants';


interface GeneratedObjectLiteralInterface_1 {
  id?:string;

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



@Entry
@Component
struct food_day_new {

  private photoCount: number = 0
  private unitOptions = [
    '早餐', '午餐', '晚餐','早点','午点','晚点','其他','营养改善计划'
  ]
  private classify=['不区分', '教师餐', '学生餐']
  private place =['实训第二学校餐厅']
  private photoPicker = new picker.PhotoViewPicker();

  @StorageLink(AppKeys.TOKEN) storageToken: string = '';
  @StorageLink(AppKeys.TENANT_ID) storageTenantId: number = 0;


  private selectDate: Date = new Date()
  private Id?:string;
  @State selectedDate?: string = '请选择日期';
  @State recipeName?: string = '';
  @State mealType?: string = '请选择餐别';
  @State diningType?: string = '请选择用餐类型';
  @State Place?:string = this.place[0];
  @State photoUri?: string = '';
  @State private PageType : string = '新建食谱'



  build() {
    Column() {
      // 表单容器
      Text(this.PageType)
        .fontSize(16)
        .margin({ bottom: 5 })
      Column() {
        Column() {
          // 食谱日期
          Row({ space: 10 }) {
            Text('食谱日期 *')
              .fontSize(16)
              .width('30%')
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
              .width('70%')
            FormItem('食谱日期', true)
          }
          .margin({top: 5, bottom: 5 })
          // 食谱名称
          Row({ space: 10 }) {
            Text('食谱名称 *')
              .fontSize(16)
              .width('30%')
            TextInput({text: this.recipeName, placeholder: '请输入食谱名称' })
              .width('60%')
              .height(40)
              .textAlign(TextAlign.Start)
              .borderRadius(4)
              .borderWidth(1)
              .borderColor('#CCCCCC')
              .onChange(value => this.recipeName = value)
              .width('70%')
            FormItem('食谱名称', true)
          }
          .margin({top: 5, bottom: 5 })
          // 餐别
          Row({ space: 10 }) {
            Text('餐 别 *')
              .fontSize(16)
              .width('30%')
            Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
              .value(this.mealType)
              .onSelect((index: number) => {
                this.mealType = this.unitOptions[index]
              })
              .width('70%')
            FormItem('餐别', true)
          }
          .margin({top: 5, bottom: 5 })
          // 用餐类型
          Row({ space: 10 }) {
            Text('用餐类型 *')
              .fontSize(16)
              .width('30%')
            Select(this.classify.map<SelectOption>((item: string) => ({ value: item })))
              .selected(0)
              .value(this.diningType)
              .onSelect((index: number) => {
                this.diningType = this.classify[index]
              })
              .width('70%')
            FormItem('用餐类型', true)
          }
          .margin({top: 5, bottom: 5 })
          // 提交单位
          Row({ space: 10 }) {
            Text('提交单位 *')
              .fontSize(16)
              .width('30%')
            Select(this.place.map<SelectOption>((item: string) => ({ value: item })))
              .selected(0)
              .value(this.Place)
              .onSelect((index: number) => {
                this.Place = this.place[index]
              })
              .width('70%')
            FormItem('提交单位',true)
          }
          .margin({top: 5, bottom: 5 })

          Row({ space: 10 }) {
              Text('上传食谱照片 *')
                .fontSize(16)
                .width('40%')
                .margin({right:110})
              Text(`${this.photoCount}/20`)
                .width('60%')
                .height(40)
          }
          .margin({top: 5, bottom: 5 })

          Image($r('app.media.evidence_add'))
            .width(100)
            .height(100)
            .objectFit(ImageFit.Contain)
            .margin({right:222})
            .onClick(() => {
              this.selectPhoto();
            })
        }
        .layoutWeight(1)
        // 保存按钮
        Button('保存')
          .type(ButtonType.Capsule)
          .width('90%')
          .margin(20)
          .onClick(() => {
            this.submitForm();
          })
      }
      .width('100%')
    }
    .padding(20)
    .width('100%')
  }
  // 日期选择对话框
  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        // 使用可选链和默认值保证安全性
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()

        this.selectDate = new Date(year, month - 1, day)
        this.selectedDate = `${year}-${(month+1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }
  // 图片选择
  private async selectPhoto() {
    try {
      let photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 20 - this.photoCount;
      
      let photoPickerResult = await this.photoPicker.select(photoSelectOptions);
      if (photoPickerResult && photoPickerResult.photoUris && photoPickerResult.photoUris.length > 0) {
        this.photoCount += photoPickerResult.photoUris.length;
        // Store the first photo URI for display
        this.photoUri = photoPickerResult.photoUris[0];
        prompt.showToast({
          message: `已选择 ${photoPickerResult.photoUris.length} 张图片`,
          duration: 2000
        });
      }
    } catch (err) {
      prompt.showToast({
        message: '选择图片失败',
        duration: 2000
      });
      console.error(`选择图片失败: ${err}`);
    }
  }

  // 表单提交逻辑
  private submitForm() {
    if (!this.selectedDate ||
      !this.recipeName ||
      !this.mealType ||
      !this.diningType
      // ||
      // !this.photoUri
    ) {
      prompt.showToast({
        message: '请填写所有必填项',
        duration: 2000
      });
      return;
    }

    prompt.showToast({
      message: '保存成功',
      duration: 2000
    });


    let formData: GeneratedObjectLiteralInterface_1 = {
      id:this.Id,
      recipeDate: this.selectedDate,
      dishName: this.recipeName,
      mealCategory_dictText: this.mealType,
      sampleType_dictText: this.diningType,
      demandUnitName: this.place[0],
      recipeImg: this.photoUri
    };

    if(this.PageType === '新建食谱')
      AddFood(this.storageTenantId.toString(), this.storageToken,formData)
    else
      ModifyFood(this.storageTenantId.toString(), this.storageToken,formData)
    router.back({url: 'pages/food_day'});
  }

  onPageShow(): void {
    const params = router.getParams() as GeneratedObjectLiteralInterface_1;
    if (params) {
      this.PageType = '修改食谱'

      this.Id = params.id

      this.selectedDate = params.recipeDate

      this.recipeName = params.dishName

      this.mealType = params.mealCategory_dictText

      this.diningType = params.sampleType_dictText

      this.Place = params.demandUnitName

      this.photoUri = params.recipeImg
    }
  }

}

@Component
struct FormItem {
  private label: string = '';
  private required: boolean = false;

  constructor(label: string, required?: boolean) {
    super();
    this.label = label;
    this.required = required ?? false;
  }

  build() {
    Row() {
      Text(this.label)
        .fontSize(16);
      if (this.required) {
        Text('*')
          .fontColor('#ff0000')
          .margin({ left: 4 });
      }
    }
    .margin({ top: 15, bottom: 8 })
    .width('100%')
    .justifyContent(FlexAlign.Start)
  }
}


interface ResponseResult {
  success: boolean;
  message: string;
  code: number;
  result: string;
}

async function AddFood(TenantId:string, Token:string,  formData: GeneratedObjectLiteralInterface_1): Promise<ResponseResult>{
  try {
    const httpRequest = http.createHttp()

    let  mealCategory:string = ''
    let sampleType:string = ''
    switch (formData.mealCategory_dictText){
      case '其他':
        mealCategory = '0'; break;
      case '早餐':
        mealCategory = '1' ;break;
      case '午餐':
        mealCategory = '2'; break;
      case '晚餐':
        mealCategory = '3'; break;
      case '早点':
        mealCategory = '4'; break;
      case '午点':
        mealCategory = '5'; break;
      case '晚点':
        mealCategory = '6'; break;
      case '营养改善计划':
        mealCategory = '7'; break;
    }
    switch (formData.sampleType_dictText){
      case '不区分':
        sampleType = '0';break;
      case '教师餐':
        sampleType = '1';break;
      case '学生餐':
        sampleType = '2';break;
    }


    const response = await httpRequest.request(
      'https://api.suoeryun.com/ifood/jeecg-school/school/xxRecipeReported/add',
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json',
          'Tenant-Id':TenantId,
          'X-Access-Token':Token
        },
        extraData:JSON.stringify({
          // 食谱日期
          "recipeDate": formData.recipeDate,

          // 餐别名称
          "dishName": formData.dishName,

          // 餐别
          // "mealCategory": formData.mealType.valueOf(),
          "mealCategory": mealCategory,

          // 用餐类型
          // "sampleType": formData.diningType,
          "sampleType": sampleType,

          // 餐厅 对应提交单位
          "demandUnitName": formData.demandUnitName,
          "recipeImg": "https://admin.suoeryun.com/pcUpload/1917469119841849345_1745995237687.png",

          // 状态
          "recipeStatus": "1"
        })
      }
    )
    const result = response.result as ResponseResult;

    if (response.responseCode !== 200) {
      console.log('HTTP Error:', response.responseCode)
      return result
    }
    return result;

  }catch (e){
    return {
      success: false,
      message: '网络错误',
      code: 500,
      result: ''
    }
  }
}

async function ModifyFood(TenantId:string, Token:string,  formData: GeneratedObjectLiteralInterface_1): Promise<ResponseResult>{
  try {
    const httpRequest = http.createHttp()

    let  mealCategory:string = ''
    let sampleType:string = ''
    switch (formData.mealCategory_dictText){
      case '其他':
        mealCategory = '0'; break;
      case '早餐':
        mealCategory = '1' ;break;
      case '午餐':
        mealCategory = '2'; break;
      case '晚餐':
        mealCategory = '3'; break;
      case '早点':
        mealCategory = '4'; break;
      case '午点':
        mealCategory = '5'; break;
      case '晚点':
        mealCategory = '6'; break;
      case '营养改善计划':
        mealCategory = '7'; break;
    }
    switch (formData.sampleType_dictText){
      case '不区分':
        sampleType = '0';break;
      case '教师餐':
        sampleType = '1';break;
      case '学生餐':
        sampleType = '2';break;
    }

    const response = await httpRequest.request(
      'https://api.suoeryun.com/ifood/jeecg-school/school/xxRecipeReported/edit',
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json',
          'Tenant-Id':TenantId,
          'X-Access-Token':Token
        },
        extraData:JSON.stringify({

          "id": formData.id,

          // 食谱日期
          "recipeDate": formData.recipeDate,

          // 餐别名称
          "dishName": formData.dishName,

          // 餐别
          // "mealCategory": formData.mealType.valueOf(),
          "mealCategory": mealCategory,

          // 用餐类型
          // "sampleType": formData.diningType,
          "sampleType": sampleType,

          // 餐厅 对应提交单位
          "demandUnitName": formData.demandUnitName,
          "recipeImg": "https://admin.suoeryun.com/pcUpload/1917469119841849345_1745995237687.png",

          // 状态
          "recipeStatus": "1"
        })
      }
    )
    console.log(formData.id)
    console.log(formData.recipeDate)
    console.log(formData.dishName)
    console.log(formData.mealCategory_dictText)
    console.log(formData.sampleType_dictText)
    console.log(formData.demandUnitName)
    console.log(formData.recipeImg)

    console.log(response.result.toString())
    const result = response.result as ResponseResult;

    if (response.responseCode !== 200) {
      console.log('HTTP Error:', response.responseCode)
      return result
    }
    return result;

  }catch (e){
    return {
      success: false,
      message: '网络错误',
      code: 500,
      result: ''
    }
  }
}
