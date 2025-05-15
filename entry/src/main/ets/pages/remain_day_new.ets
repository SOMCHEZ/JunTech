import router from '@ohos.router';
import http from '@ohos.net.http';
import { dataSharePredicates } from '@kit.ArkData';
import picker from '@ohos.file.picker';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { prompt } from '@kit.ArkUI';

//永久存储token和租户id
AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);

interface RouteParams {
  token?: string;
  relTenantIds?: number;
  formData?: SampleFormData;
}

interface SampleFormData {
  id?: string;
  unitName?: string;
  date?: string;
  sampleType?: string;
  mealType?: string;
  fridgeTemp?: string;
  dishName?: string;
  sampleWeight?: string;
  destroyPerson?: string;
  destroyTime?: string;
  sampleImages?: string[];
  fridgeImages?: string[];
  remark?: string;
}

interface SampleResponse {
  code: number;
  message: string;
  result: SampleFormData;
  timestamp: number;
}

@Entry
@Component
struct SampleFormPage {
  @State samples: SampleFormData[] = [];
  @State submitUnit: string = '实训第二学校餐厅'
  @State sampleDate: string = '请选择日期'
  @State sampleType: string = '不区分'
  @State mealType: string = '午餐'
  @State fridgeTemp: string = '5'
  @State dishName: string = ''
  @State sampleWeight: string = ''
  @State destroyPerson: string = ''
  @State destroyTime: string = '请选择销毁时间'
  @State sampleImages: string[] = []
  @State fridgeImages: string[] = []
  @State remark: string = ''
  @State receivedToken: string = ''
  @State tenantId: number = 0

  @State photoUri: string = '';
  @State formDataList: SampleFormData[] = [];
  private photoPicker = new picker.PhotoViewPicker();
  @State photoAssetUrl:string = ''
  private photoCount: number = 0

  private unitOptions: string[] = ['实训第二学校餐厅', '其他']
  private typeOptions: string[] = ['不区分', '教师餐', '学生餐']
  private mealOptions: string[] = ['早餐', '午餐', '晚餐','早点','午点','晚点','其他','营养改善计划']
  private destroyTimeOptions: string[] = ['上午', '下午', '晚上']

  build() {
    Column() {
      Scroll() {
        Column() {
          // 顶部提示
          Text('根据政策要求，样本重量不少于125克，且该留样时间必须在48小时以上。预计该样本在2025年05月11日后可以销毁。')
            .fontColor('#FF7F50')
            .fontSize(15)
            .margin({ bottom: 16, top: 8 })

          // 提交单位
          Row() {
            this.formRow('提交单位', true)
            Select(this.unitOptions.map<SelectOption>(item => ({ value: item })))
              .value(this.submitUnit)
              .onSelect(index => this.submitUnit = this.unitOptions[index])
              .width('65%')
          }
          .margin({top: 5, bottom: 5 })

          // 留样日期
          Row(){
            this.formRow('留样日期', true)
            Text(this.sampleDate)
              .onClick(() => this.showDatePicker())
              .fontColor(this.sampleDate === '请选择日期' ? '#bbb' : '#222')
              .width('65%')
              .margin({left:'5%'})
          }
          .margin({top: 5, bottom: 5 })

          // 留样类型
          Row() {
            this.formRow('留样类型', true)
            Select(this.typeOptions.map<SelectOption>(item => ({ value: item })))
              .value(this.sampleType)
              .onSelect(index => this.sampleType = this.typeOptions[index])
              .width('65%')
          }
          .margin({top: 5, bottom: 5 })

          // 餐别
          Row() {
            this.formRow('餐    别', true)
            Select(this.mealOptions.map<SelectOption>(item => ({ value: item })))
              .value(this.mealType)
              .onSelect(index => this.mealType = this.mealOptions[index])
              .width('65%')
          }
          .margin({top: 5, bottom: 5 })

          // 留样柜温度
          Row(){
            this.formRow('留样柜温度℃', true)
            TextInput({ placeholder: '5' })
              .type(InputType.Number)
              .onChange(val => this.fridgeTemp = val)
              .width('100%')
          }
          .margin({top: 5, bottom: 5 })

          // 菜品名称
          Row(){
            this.formRow('菜品名称', true)
            TextInput({ placeholder: '请输入菜品名称' })
              .onChange(val => this.dishName = val)
              .width('100%')
          }
          .margin({top: 5, bottom: 5 })

          // 留样重量
          Row(){
            this.formRow('留样重量(克)', true)
            TextInput({ placeholder: '请输入留样重量' })
              .type(InputType.Number)
              .onChange(val => this.sampleWeight = val)
              .width('100%')
          }
          .margin({top: 5, bottom: 5 })

          // 销毁人员
          Row(){
            this.formRow('销毁人员', true)
            TextInput({ placeholder: '请输入销毁人员' })
              .onChange(val => this.destroyPerson = val)
              .width('100%')
          }
          .margin({top: 5, bottom: 5 })

          // 销毁时间
          Row(){

            this.formRow('销毁时间', false)
            Text(this.destroyTime)
              .onClick(()=>this.destroyTimePicker())
              .fontColor(this.destroyTime === '请选择销毁时间' ? '#bbb' : '#222')
              .width('65%')
              .margin({left:'5%'})
          }
          .margin({top: 5, bottom: 5 })

          // 上传留样图片
          this.formImageRow('上传留样图片', true, this.sampleImages, 10, (imgs: string[]) => this.sampleImages = imgs)
          // 放入留样柜拍照
          this.formImageRow('放入留样柜拍照', true, this.fridgeImages, 2, (imgs: string[]) => this.fridgeImages = imgs)

          // 备注
          Column() {
            Text('备注').fontWeight(FontWeight.Bold).margin({ top: 16, bottom: 4 })
            TextInput({ placeholder: '请输入备注信息' })
              .onChange(val => this.remark = val)
              .width('100%')
          }
        }
        .padding(16)
        .width('110%')
      }
      .layoutWeight(1)

      // 提交按钮
      Button('提交')
        .width('100%')
        .height(48)
        .backgroundColor('#07C160')
        .fontColor('#fff')
        .fontSize(20)
        .margin({ top: 24, bottom: 24 })
        .onClick(() => this.submit())

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }

  async onPageShow() {
    const params = router.getParams() as RouteParams;

    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
    }
    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
    }

    this.receivedToken = AppStorage.get('token') ?? '';
    this.tenantId = AppStorage.get('tenantId') ?? 0;

    console.log('Received form data:', params.formData)
    if (params?.formData) {
      // 编辑模式，填充表单数据
      const formData = params.formData;
      this.sampleDate = formData.date ?? '请选择日期';
      this.sampleType = formData.sampleType ?? '不区分';
      this.mealType = formData.mealType ?? '午餐';
      this.dishName = formData.dishName ?? '';
      this.sampleWeight = formData.sampleWeight ?? '';
      this.destroyPerson = formData.destroyPerson ?? '';
      this.destroyTime = formData.destroyTime ?? '请选择销毁时间';
      this.sampleImages = formData.sampleImages ?? [];
      this.fridgeImages = formData.fridgeImages ?? [];
      this.remark = formData.remark ?? '';
    }
  }
  // 添加图片
  private async openGallery() {
    try {
      const photoSelectResult = await this.photoPicker.select();
      if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
        const selectedPhotoUri = photoSelectResult.photoUris[0];
        // 直接替换现有图片
        this.photoUri = selectedPhotoUri;
        this.photoCount = 1; // 重置为1，因为只允许一张图片
      } else {
        prompt.showToast({ message: '未选择任何图片', duration: 2000 });
      }
    } catch (error) {
      prompt.showToast({ message: '图片选择失败', duration: 2000 });
      console.error('图片选择异常:', error);
    }
  }
  // 添加的接口
  private async loadSamplesFromServer() {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        `https://api.suoeryun.com/ifood/jeecg-school/school/xxReservedSample/list`, // 示例接口地址
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'X-Access-Token': this.receivedToken,
            'Tenant-Id': this.tenantId.toString()
          }
        }
      );
      if (response.responseCode === 200) {
        const jsonData = JSON.parse(response.result as string) as SampleResponse;
        if (jsonData.code === 200 && jsonData.result) {
          // this.samples = jsonData.result || [];
          this.samples =  [jsonData.result]
          console.log('this.samples:', this.samples)
        } else {
          console.error('获取数据失败:', jsonData.message);
        }
      } else {
        console.error('HTTP 请求失败:', response.responseCode);
      }
    } catch (error) {
      console.error('请求异常:', error);
    }
  }
  // 表单行封装
  @Builder
  private formRow(label: string, required: boolean) {
    Row(){
      Text(label)
        .fontWeight(FontWeight.Bold)
      if ((required?'*':'')) {
        Text('*')
          .fontColor('#ff0000')
          .margin({ left: 4 });
      }
    }
    .margin({ top: 8, bottom: 8 })
    .width('35%')
    .alignItems(VerticalAlign.Center)
  }

  // 图片上传行封装
  @Builder
  private formImageRow(label: string, required: boolean, images: string[], max: number, onChange: (imgs: string[]) => void) {
    Column(){
      Row() {
        Text(label)
          .fontWeight(FontWeight.Bold)
          .width('45%')
        if ((required?'*':'')) {
          Text('*')
            .fontColor('#ff0000')
            .margin({ left: 4 });
        }
        Text(`${images.length}/${max}`)
          .fontColor('#888')
          .width('40%')
          .textAlign(TextAlign.End)
      }
      .margin({top: 5, bottom: 5 })
      Row() {
        if (this.photoUri) {
          Stack() {
            Image(this.photoUri)
              .width(100)
              .height(100)
              .borderRadius(8)
              .objectFit(ImageFit.Cover)

            // 删除按钮
            Button({ type: ButtonType.Circle }) {
              Image($r('app.media.error'))
                .width(20)
                .height(20)
            }
            .width(24)
            .height(24)
            .position({ x: 80, y: 0 })
            .backgroundColor('#FF0000')
            .onClick(() => {
              this.photoUri = '';
              this.photoCount = 0;
            })
          }
          .margin({ right: 10 })
        }

        // 上传图片按钮
        Image($r('app.media.evidence_add'))
          .width(100)
          .height(100)
          .onClick(async () => {
            this.openGallery();
            const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext())
            const predicates = new dataSharePredicates.DataSharePredicates
            const fatcResult = await phAccessHelper.getAssets({
              fetchColumns: [],
              predicates: predicates
            })
            this.photoCount = fatcResult.getCount()
          })
      }
      .margin({top: 5, bottom: 5 })
    }
    .margin({ top: 8, bottom: 8 })
    .width('100%')
  }

  // 日期选择
  private showDatePicker() {
    DatePickerDialog.show({
      start: new Date('2020-01-01'),
      end: new Date('2030-12-31'),
      selected: new Date(),
      onAccept: (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()
        this.sampleDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`

      }
    })
  }
  private destroyTimePicker() {
    DatePickerDialog.show({
      start: new Date('2020-01-01'),
      end: new Date('2030-12-31'),
      selected: new Date(),
      onAccept: (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()
        this.destroyTime = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`

      }
    })
  }

  // 数据返回
  private async submit(): Promise<void> {
    console.log('11',this.submitUnit)
    console.log('2',this.sampleDate)
    console.log('3',this.sampleType)
    console.log('4',this.mealType)
    console.log('5',this.fridgeTemp)
    console.log('6',this.dishName)
    console.log('7',this.sampleWeight)
    console.log('8',this.destroyPerson)
    console.log('9',this.destroyTime)
    console.log('10',this.sampleImages[0])
    console.log('111',this.fridgeImages[0])


    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxReservedSample/add',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Tenant-Id': this.tenantId.toString(),
            'X-Access-Token': this.receivedToken
          },
          extraData: JSON.stringify({
            // unitName: this.submitUnit,
            // date: this.sampleDate,
            // sampleType: this.sampleType,
            // mealType: this.mealType,
            // fridgeTemp: this.fridgeTemp,
            // dishName: this.dishName,
            // sampleWeight: this.sampleWeight,
            // destroyPerson: this.destroyPerson,
            // destroyTime: this.destroyTime,
            // sampleImages: this.sampleImages,
            // fridgeImages: this.fridgeImages,
            // remark: this.remark

            unitName: this.submitUnit,
            date: this.sampleDate,
            sampleType: this.sampleType,
            mealType: this.mealType,
            fridgeTemp: this.fridgeTemp,
            dishName: this.dishName,
            sampleWeight: parseFloat(this.sampleWeight) || 0,
            destroyPerson: this.destroyPerson,
            destroyTime: this.destroyTime !== '请选择销毁时间' ? this.destroyTime : '',
            sampleImages: ["https://admin.suoeryun.com/pcUpload/1917474932601933825_1745996623568.png"],
            fridgeImages: ["https://admin.suoeryun.com/pcUpload/1917474946438942721_1745996626850.png"]

          })
        }
      );
      console.log('ResponseResult:', response.result)

      const responseString = response.result as string;
      const jsonData: SampleResponse = JSON.parse(responseString);
      console.log('ResponseCode:', jsonData.message);
      if (jsonData.code === 200) {
        const formData: SampleFormData = {
          id: jsonData.result?.id || '',
          unitName: this.submitUnit,
          date: this.sampleDate,
          sampleType: this.sampleType,
          mealType: this.mealType,
          fridgeTemp: this.fridgeTemp,
          dishName: this.dishName,
          sampleWeight: this.sampleWeight,
          destroyPerson: this.destroyPerson,
          destroyTime: this.destroyTime,
          sampleImages: ["https://admin.suoeryun.com/pcUpload/1917474932601933825_1745996623568.png"],
          fridgeImages: ["https://admin.suoeryun.com/pcUpload/1917474946438942721_1745996626850.png"],
          remark: this.remark
        };
        router.pushUrl({
          url: 'pages/remain_day',
          params: {
            formData: formData,
            token: this.receivedToken,
            relTenantIds: this.tenantId
          }
        });
        // 🔥 使用 AppStorage 存储数据
        await AppStorage.set('newSampleData', JSON.stringify(formData));

      }else {
        AlertDialog.show({ message: '提交失败：' + jsonData.message });
      }
    } catch (error) {
      console.error('Submit Error:', error);
      AlertDialog.show({ message: '网络请求异常' });
    }

  }

}