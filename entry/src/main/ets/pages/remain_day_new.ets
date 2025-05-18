import router from '@ohos.router';
import http from '@ohos.net.http';
import { dataSharePredicates } from '@kit.ArkData';
import picker from '@ohos.file.picker';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { prompt } from '@kit.ArkUI';

//永久存储token和租户id
AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);

interface  records{//定义接口返回类型
  id?: number;
  schoolId: string;
  schoolName:  string;
  unitId: string;
  unitName: string;
  userName: string;// 后端返回的姓名
  //realname: string;
  idCard?: string;
  portraitPhoto?:string;
  position:  string;//  后端返回的职位
  tel: string;// 后端返回的电话
  type: string;//  后端返回的职位类型
  type_dictText:string;// 后端返回的职位类型
  licenceIssuing: string;//  后端返回的营业执照有效期
  healthNumber: string;//  后端返回的健康证号
  healthUrl?: string;  // 后端返回的健康证图片
  healthStartTime: string;// 后端返回的营业执照有效期
  healthEndTime:  string;// 后端返回的营业执照有效期
  photoQualification: string;//  后端返回的营业执照图片
  remark: string;//  后端返回的备注
  inspectionType?:number//  后端返回的职位类型
  version: number;//  后端返回的版本
  canteenId:  string;// 后端返回的食堂id
  wxopenId: string;// 后端返回的微信openid
  tenantId:  number;//  后端返回的租户id
  demandUnitIds:string;// 后端返回的食堂id
  code?: number;// 后端返回的code

  // 其他字段根据实际API响应补充...
}

interface RouteParams {
  token?: string;
  relTenantIds?: number;
  formData?: SampleFormData;
}

interface SampleFormData {
  id?: string;
  unitName?: string;
  createTime?: string;
  reservedSampleDate?:string;// 留样日期
  sampleType?: string;
  sampleType_dictText?: string;
  mealType?: string;
  mealCategory_dictText?: string;
  cabinetTemperature?: string;
  dishName?: string;
  putWeight?: string;
  destroyPerson?: string;
  destroyTime?: string;
  sampleImages?: string; // 留样图片
  fridgeImages?: string; // 展柜图片
  remark?: string;
}

interface SampleResponse {
  code: number;
  message: string;
  result: string; // 根据实际使用场景替换为具体类型
  success: boolean;
  timestamp: number;
}

interface GeneratedTypeLiteralInterface_1 {
  mealCategory: string;
  mealCategory_dictText: string;
}
interface GeneratedTypeLiteralInterface_2 {
  sampleType: string;
  sampleType_dictText: string;
}

// interface GeneratedObjectLiteralInterface_13{
//   id: string,
//   createByName: string,
//   tenantId: number,
//   schoolId: string,
//   demandUnit: string,
//   demandUnitName: string,
//   mealCategory: string,
//   mealCategory_dictText: string,
//   reservedSampleDate:string,
//   sampleType:string,
//   remark: string,
//   reservedSampleImages: string,
//   cabinetPhoto: string,
//   dishName: string,
//   cabinetTemperature:string,
//   destroyPerson:string,
//   destroyTime:string,
// }
interface GeneratedObjectLiteralInterface_14 {
  id: string;
  createByName: string;
  tenantId:number;
  schoolId:string;
  demandUnit: string;
  demandUnitName: string;
  mealCategory: string;
  mealCategory_dictText: string;
  reservedSampleDate: string;
  remark: string;
  reservedSampleImages: string;
  dishName: string;
  cabinetPhoto: string;
  cabinetTemperature: number;
  destroyPerson: string;
  destroyTime: string;
  sampleType: string;
}

interface GeneratedObjectLiteralInterface_15 {
  demandUnit: string;
  demandUnitName: string;
  reservedSampleDate: string;
  dishName: string;
  remark: string;
  cabinetTemperature: number;
  destroyPerson: string;
  destroyTime: string;
  sampleType: string;
  mealCategory: string;
  putWeight: string;
  reservedSampleImages: string;
  cabinetPhoto: string;
}

interface GeneratedObjectLiteralInterface_16 {
  contentType: string;
  tenantId: string;
  xAccessToken: string;
}

interface GeneratedObjectLiteralInterface_17 {
  'Content-Type': string;
  'Tenant-Id': string;
  'X-Access-Token': string;
  'Accept': string;
}

@Entry
@Component
struct remain_day_new {
  @State samples: SampleFormData[] = [];
  @State ids:string  = ''
  @State submitUnit: string = '实训第二学校餐厅'
  @State sampleDate: string = '请选择日期'
  @State sampleType: string = '0'
  @State sampleType_dictText: string = '不区分'
  @State mealCategory_dictText: string='其他'
  @State mealType: string = '0'
  @State fridgeTemp: string = '5'
  @State dishName: string = ''
  @State putWeight: string = ''
  @State destroyPerson: string = ''
  @State destroyTime: string = '请选择销毁时间'
  @State sampleImages: string = '' // 改为单个图片
  @State fridgeImages: string = '' // 改为单个图片
  @State remark: string = ''
  @State receivedToken: string = ''
  @State tenantId: number = 0
  @State private PageType : string = '新建留样'
  private unitOptions: string[] = ['实训第二学校餐厅', '其他']
  private typeOptions: string[] = ['不区分', '教师餐', '学生餐']
  private mealOptions: string[] = ['早餐', '午餐', '晚餐', '早点', '午点', '晚点', '其他', '营养改善计划']
  private photoPicker = new picker.PhotoViewPicker();
  @State photoAssetUrl:string = ''
  @State photoUri: string = '';
  private photoCount: number = 0

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
          .margin({ top: 5, bottom: 5 })

          // 留样日期
          Row() {
            this.formRow('留样日期', true)
            Text(this.sampleDate)
              .onClick(() => this.showDatePicker())
              .fontColor(this.sampleDate === '请选择日期' ? '#bbb' : '#222')
              .width('65%')
              .margin({ left: '5%' })
          }
          .margin({ top: 5, bottom: 5 })

          // 留样类型
          Row() {
            this.formRow('留样类型', true)
            Select(this.typeOptions.map<SelectOption>(item => ({ value: item })))
              .value(this.sampleType_dictText)
              .onSelect((index: number) => {
                const sampleType_dictText = this.typeOptions[index];
                const typeValues = this.getSampleTypeValue(sampleType_dictText);
                this.sampleType = typeValues.sampleType;
                this.sampleType_dictText = typeValues.sampleType_dictText;
              })
              .width('65%')
          }
          .margin({ top: 5, bottom: 5 })

          // 餐别
          Row() {
            this.formRow('餐    别', true)
            Select(this.mealOptions.map<SelectOption>(item => ({ value: item })))
              .value(this.mealCategory_dictText)
              .onSelect(index => this.mealCategory_dictText = this.mealOptions[index])
              .width('65%')
          }
          .margin({ top: 5, bottom: 5 })

          // 留样柜温度
          Row() {
            this.formRow('留样柜温度℃', true)
            TextInput({ placeholder: this.fridgeTemp })
              .type(InputType.Number)
              .onChange(val => this.fridgeTemp = val)
              .width('100%')
          }
          .margin({ top: 5, bottom: 5 })

          // 菜品名称
          Row() {
            this.formRow('菜品名称', true)
            TextInput({ placeholder: this.dishName })
              .onChange(val => this.dishName = val)
              .width('100%')
          }
          .margin({ top: 5, bottom: 5 })

          // 留样重量
          Row() {
            this.formRow('留样重量(克)', true)
            TextInput({placeholder: `${this.putWeight}`})
              .onChange(val=> {this.putWeight = val; })
              .width('100%')
          }
          .margin({ top: 5, bottom: 5 })

          // 销毁人员
          Row() {
            this.formRow('销毁人员', true)
            TextInput({ placeholder: this.destroyPerson })
              .onChange(val => this.destroyPerson = val)
              .width('100%')
          }
          .margin({ top: 5, bottom: 5 })

          // 销毁时间
          Row() {
            this.formRow('销毁时间', false)
            Text(this.destroyTime)
              .onClick(() => this.destroyTimePicker())
              .fontColor(this.destroyTime === '请选择销毁时间' ? '#bbb' : '#222')
              .width('65%')
              .margin({ left: '5%' })
          }
          .margin({ top: 5, bottom: 5 })

          // 上传留样图片
          this.formImageRow('上传留样图片', true, this.sampleImages,(url: string) => this.photoUri = url)

          // 放入留样柜拍照
          this.formImageRow('放入留样柜拍照', true, this.fridgeImages,(url: string) => this.photoUri = url)

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
        .onClick(() =>{
          if  (this.PageType === '新建留样') {
            this.submit()
          } else {
            this.updateData()
          }

        })
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

    if (params?.formData) {
      this.PageType = '修改留样';
      const formData = params.formData;
      this.submitUnit = formData.unitName ?? '实训第二学校餐厅';
      this.sampleDate = formData.reservedSampleDate ?? '请选择日期'; // ✅ 使用 reservedSampleDate
      this.destroyTime = formData.destroyTime ?? '请选择销毁时间';
      this.fridgeTemp =formData.cabinetTemperature ?? '';
      this.dishName = formData.dishName ?? '';
      this.destroyPerson = formData.destroyPerson ?? '';
      this.putWeight = formData.putWeight ?? '';

      this.sampleImages = formData.sampleImages ?? '';
      this.fridgeImages = formData.fridgeImages ?? '';
      this.remark = formData.remark ?? '';
      this.mealType = formData.mealType ?? '0';
      this.mealCategory_dictText = formData.mealCategory_dictText ?? '其他';
      this.sampleType = formData.sampleType ?? '0';
      this.sampleType_dictText = formData.sampleType_dictText ?? '不区分';
      this.ids = formData.id ?? '';

    }
    console.log('id',this.ids)

  }

  // 表单行封装
  @Builder
  private formRow(label: string, required: boolean) {
    Row() {
      Text(label)
        .fontWeight(FontWeight.Bold)
      if (required) {
        Text('*')
          .fontColor('#ff0000')
          .margin({ left: 4 });
      }
    }
    .margin({ top: 8, bottom: 8 })
    .width('35%')
    .alignItems(VerticalAlign.Center)
  }

  // 图片上传行封装 - 修改为单图片
  @Builder
  private formImageRow(label: string, required: boolean, imageUrl: string, onChange: (url: string) => void) {
    Column() {
      Row() {
        Text(label)
          .fontWeight(FontWeight.Bold)
          .width('45%')
          .margin({ right: 4 });
        if (required) {
          Text('*')
            .fontColor('#ff0000')

          Text(imageUrl ? '1/1' : '0/1')
            .fontSize(14)
            .fontColor('#666')
            .margin({ left: 8 })
            .width('35%')
            .textAlign(TextAlign.End)
        }
      }
      .width('100%')
      .margin({ top: 5, bottom: 5 })

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
      .margin({ bottom: 20 })
      .width('100%')
    }
    .margin({ top: 8, bottom: 8 })
    .width('100%')
  }

  // 获取当前日期并格式化为 YYYY-MM-DD 格式
  private getCurrentDate(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = (now.getMonth() + 1).toString().padStart(2, '0'); // 月份从0开始，需要+1
    const day = now.getDate().toString().padStart(2, '0');
    return `${year}-${month}-${day}`;
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
        this.sampleDate = `${year}-${(month+1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

  // 销毁时间选择
  private destroyTimePicker() {
    DatePickerDialog.show({
      start: new Date('2020-01-01'),
      end: new Date('2030-12-31'),
      selected: new Date(),
      onAccept: (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()
        this.destroyTime = `${year}-${(month+1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

  // 获取餐别值
  private getMealCategoryValue(mealName: string): GeneratedTypeLiteralInterface_1 {
    switch (mealName) {
      case '早餐':
        return { mealCategory: '1', mealCategory_dictText: '早餐' };
      case '午餐':
        return { mealCategory: '2', mealCategory_dictText: '午餐' };
      case '晚餐':
        return { mealCategory: '3', mealCategory_dictText: '晚餐' };
      case '早点':
        return { mealCategory: '4', mealCategory_dictText: '早点' };
      case '午点':
        return { mealCategory: '5', mealCategory_dictText: '午点' };
      case '晚点':
        return { mealCategory: '6', mealCategory_dictText: '晚点' };
      case '营养改善计划':
        return { mealCategory: '7', mealCategory_dictText: '营养改善计划' };
      default:
        return { mealCategory: '0', mealCategory_dictText: '其他' };
    }
  }
  // 获取留样类型值
  private getSampleTypeValue(sampleTypeName: string): GeneratedTypeLiteralInterface_2 {
    switch (sampleTypeName) {
      case '不区分':
        return { sampleType: '0', sampleType_dictText: '不区分' };
      case '教师餐':
        return { sampleType: '1', sampleType_dictText: '教师餐' };
      case '学生餐':
        return { sampleType: '2', sampleType_dictText: '学生餐' };
      default:
        return { sampleType: '0', sampleType_dictText: '不区分' };
    }
  }

  // 修改数据
  private async updateData(): Promise<void> {
    try {
      // 验证必填字段
      if (!this.submitUnit || this.sampleDate === '请选择日期' || !this.dishName || !this.putWeight) {
        AlertDialog.show({ message: '请填写必填项' });
        return;
      }

      console.log('10086',this.getMealCategoryValue(this.mealType))
      const httpRequest = http.createHttp();

      // 准备请求数据
      const mealValues = this.getMealCategoryValue(this.mealCategory_dictText);
      const typeValues = this.getSampleTypeValue(this.sampleType_dictText);

      const requestData: GeneratedObjectLiteralInterface_14 = {
        id: this.ids,
        createByName: "实训第二学校餐厅",
        tenantId:this.tenantId,
        schoolId: "1917168448022519809",
        demandUnit: "1917168448035102722",
        demandUnitName: this.submitUnit.trim(),
        mealCategory: mealValues.mealCategory,
        mealCategory_dictText: mealValues.mealCategory_dictText,
        reservedSampleDate: this.sampleDate,
        remark: this.remark ? this.remark.trim() : "",
        reservedSampleImages: this.sampleImages ||
          "https://admin.suoeryun.com/pcUpload/1917474932601933825_1745996623568.png",
        cabinetPhoto: this.fridgeImages || "https://admin.suoeryun.com/pcUpload/1917474946438942721_1745996626850.png",
        dishName: this.dishName.trim(),
        cabinetTemperature: Number(this.fridgeTemp) || 5,
        destroyPerson: this.destroyPerson ? this.destroyPerson.trim() : "",
        destroyTime: this.destroyTime !== '请选择销毁时间' ? `${this.destroyTime} ` : "",
        sampleType: typeValues.sampleType,

        // createTime: formattedCreateTime,
        // sampleType_dictText: typeValues.sampleType_dictText,
        // putWeight: Number(this.putWeight) || 0,
      };

      // 数据验证
      if (!requestData.demandUnitName || !requestData.reservedSampleDate || !requestData.dishName ) {
        AlertDialog.show({ message: '请填写必填项（提交单位、留样日期、菜品名称）' });
        return;
      }

      // 确保日期格式正确
      if (requestData.reservedSampleDate && !requestData.reservedSampleDate.includes(' ')) {
        const dateParts = requestData.reservedSampleDate.split('-');
        if (dateParts.length === 3) {
          requestData.reservedSampleDate =
            `${dateParts[0]}-${dateParts[1].padStart(2, '0')}-${dateParts[2].padStart(2, '0')}`;
        }
      }

      // 准备请求头
      const headers: GeneratedObjectLiteralInterface_16 = {
        contentType: 'application/json',
        tenantId: this.tenantId ? this.tenantId.toString() : '100001',
        xAccessToken: this.receivedToken || ''
      };

      // 转换为API需要的格式
      const apiHeaders: GeneratedObjectLiteralInterface_17 = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Tenant-Id': headers.tenantId,
        'X-Access-Token': headers.xAccessToken,
        'Accept': 'application/json, text/plain, */*'
      };

      try {
        const response = await httpRequest.request(
          'https://api.suoeryun.com/ifood/jeecg-school/school/xxReservedSample/edit',
          {
            method: http.RequestMethod.POST,
            header: apiHeaders,
            extraData: JSON.stringify(requestData),
            connectTimeout: 60000,
            readTimeout: 60000
          }
        );
        console.log('result:',response.result)
        console.info('Response Status:', response.responseCode);
        console.info('Response Headers:', JSON.stringify(response.header, null, 2));

        // 处理响应数据
        let jsonData: SampleResponse;
        if (typeof response.result === 'string') {
          // console.info('Raw Response (string):', response.result);
          jsonData = JSON.parse(response.result);
        } else if (typeof response.result === 'object') {
          // console.info('Raw Response (object):', JSON.stringify(response.result, null, 2));
          jsonData = response.result as SampleResponse;
        } else {
          throw new Error('Unexpected response format');
        }

        if (jsonData && jsonData.success) {
          prompt.showToast({
            message: jsonData.message || '提交成功',
            duration: 2000
          });

          // 保存成功后，清空或重置表单
          this.resetForm();

          const formData: SampleFormData = {
            unitName: this.submitUnit,
            reservedSampleDate: this.sampleDate,
            sampleType: this.sampleType,
            mealType: this.mealType,
            mealCategory_dictText: mealValues.mealCategory_dictText,
            cabinetTemperature: this.fridgeTemp,
            dishName: this.dishName,
            putWeight: this.putWeight,
            destroyPerson: this.destroyPerson,
            destroyTime: this.destroyTime,
            sampleImages: this.sampleImages,
            fridgeImages: this.fridgeImages,
            remark: this.remark
          };
          console.log('传输的 formData:', JSON.stringify(formData))
          await AppStorage.set('newSampleData', JSON.stringify(formData));
          router.back({
            url: 'pages/remain_day',
            params: {
              token: this.receivedToken,
              relTenantIds: this.tenantId
            }
          });
        } else {
          throw new Error(jsonData?.message || '提交失败');
        }
      } catch (error) {
        console.error('Submit Error:', JSON.stringify(error, null, 2));
        let errorMessage = '网络请求异常';
        if (error instanceof Error) {
          errorMessage = `提交失败: ${error.message}`;
        } else if (typeof error === 'object' && error !== null) {
          errorMessage = `提交失败: ${JSON.stringify(error)}`;
        }
        AlertDialog.show({
          message: errorMessage,
          confirm: {
            value: '确定',
            action: () => {
              console.info('Error dialog confirmed');
            }
          }
        });
      }
    } catch (error) {
      console.error('Submit Error:', JSON.stringify(error));
      let errorMessage = '网络请求异常';
      if (error instanceof Error) {
        errorMessage = `网络请求异常: ${error.message}`;
      } else if (typeof error === 'object' && error !== null) {
        errorMessage = `网络请求异常: ${JSON.stringify(error)}`;
      }
      AlertDialog.show({
        message: errorMessage,
        confirm: {
          value: '确定',
          action: () => {
            console.info('Dialog confirmed');
          }
        }
      });
    }

  }
  // 添加数据
  private async submit(): Promise<void> {
    try {
      // 验证必填字段
      if (!this.submitUnit || this.sampleDate === '请选择日期' || !this.dishName || !this.putWeight) {
        AlertDialog.show({ message: '请填写必填项' });
        return;
      }

      console.log('1',this.getMealCategoryValue(this.mealType))
      const httpRequest = http.createHttp();

      // 准备请求数据
      const mealValues = this.getMealCategoryValue(this.mealCategory_dictText);
      const typeValues = this.getSampleTypeValue(this.sampleType_dictText);

      const requestData: GeneratedObjectLiteralInterface_15 = {
        demandUnit: "1923315011606380545",
        demandUnitName: this.submitUnit.trim(),
        reservedSampleDate: this.sampleDate,
        mealCategory:mealValues.mealCategory,
        dishName: this.dishName.trim(),
        remark: this.remark ? this.remark.trim() : "",
        cabinetTemperature: Number(this.fridgeTemp) || 5,
        destroyPerson: this.destroyPerson ? this.destroyPerson.trim() : "",
        // createTime: formattedCreateTime,
        destroyTime: this.destroyTime !== '请选择销毁时间' ? `${this.destroyTime} ` : "",
        sampleType: typeValues.sampleType,
        putWeight: this.putWeight,
        reservedSampleImages: this.sampleImages ||
          "https://admin.suoeryun.com/pcUpload/1917474932601933825_1745996623568.png",
        cabinetPhoto: this.fridgeImages || "https://admin.suoeryun.com/pcUpload/1917474946438942721_1745996626850.png",

        // mealCategory_dictText: mealValues.mealCategory_dictText,
        // sampleType_dictText: typeValues.sampleType_dictText,
      };

      // 数据验证
      if (!requestData.demandUnitName || !requestData.reservedSampleDate || !requestData.dishName ||
        !requestData.putWeight) {
        AlertDialog.show({ message: '请填写必填项（提交单位、留样日期、菜品名称、留样重量）' });
        return;
      }

      // 确保日期格式正确
      if (requestData.reservedSampleDate && !requestData.reservedSampleDate.includes(' ')) {
        const dateParts = requestData.reservedSampleDate.split('-');
        if (dateParts.length === 3) {
          requestData.reservedSampleDate =
            `${dateParts[0]}-${dateParts[1].padStart(2, '0')}-${dateParts[2].padStart(2, '0')}`;
        }
      }

      // 确保重量是正数且为整数,留样重量必须大于等于 125
      const putWeightNum = Math.floor(Number(requestData.putWeight));
      if (isNaN(putWeightNum) || putWeightNum < 125) {
        AlertDialog.show({ message: '留样重量不能少于125g' });
        return;
      }


      // 准备请求头
      const headers: GeneratedObjectLiteralInterface_16 = {
        contentType: 'application/json',
        tenantId: this.tenantId ? this.tenantId.toString() : '100001',
        xAccessToken: this.receivedToken || ''
      };

      // 转换为API需要的格式
      const apiHeaders: GeneratedObjectLiteralInterface_17 = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Tenant-Id': headers.tenantId,
        'X-Access-Token': headers.xAccessToken,
        'Accept': 'application/json, text/plain, */*'
      };

      // 打印请求信息
      // console.info('Request URL:', 'https://api.suoeryun.com/ifood/jeecg-school/school/xxReservedSample/add');
      // console.info('Request Headers:', JSON.stringify(apiHeaders, null, 2));
      // console.info('Request Data:', JSON.stringify(requestData, null, 2));
      // console.info('TenantId: ' + headers.tenantId);
      // console.info('Token: ' + headers.xAccessToken);

      try {
        const response = await httpRequest.request(
          'https://api.suoeryun.com/ifood/jeecg-school/school/xxReservedSample/add',
          {
            method: http.RequestMethod.POST,
            header: apiHeaders,
            extraData: JSON.stringify(requestData),
            connectTimeout: 60000,
            readTimeout: 60000
          }
        );

        console.info('Response Status:', response.responseCode);
        console.info('Response Headers:', JSON.stringify(response.header, null, 2));

        // 处理响应数据
        let jsonData: SampleResponse;
        if (typeof response.result === 'string') {
          // console.info('Raw Response (string):', response.result);
          jsonData = JSON.parse(response.result);
        } else if (typeof response.result === 'object') {
          // console.info('Raw Response (object):', JSON.stringify(response.result, null, 2));
          jsonData = response.result as SampleResponse;
        } else {
          throw new Error('Unexpected response format');
        }

        // console.info('Processed Response:', JSON.stringify(jsonData, null, 2));

        if (jsonData && jsonData.success) {
          prompt.showToast({
            message: jsonData.message || '提交成功',
            duration: 2000
          });

          // 保存成功后，清空或重置表单
          this.resetForm();

          const formData: SampleFormData = {
            unitName: this.submitUnit,
            reservedSampleDate: this.sampleDate,
            sampleType: this.sampleType,
            mealType: this.mealType,
            mealCategory_dictText: mealValues.mealCategory_dictText,
            cabinetTemperature: this.fridgeTemp,
            dishName: this.dishName,
            putWeight: this.putWeight,
            destroyPerson: this.destroyPerson,
            destroyTime: this.destroyTime,
            sampleImages: this.sampleImages,
            fridgeImages: this.fridgeImages,
            remark: this.remark
          };
          console.log('接收到的 formData:', JSON.stringify(formData));


          await AppStorage.set('newSampleData', JSON.stringify(formData));
          router.back({
            url: 'pages/remain_day',
            params: {
              // formData: formData,
              token: this.receivedToken,
              relTenantIds: this.tenantId
            }
          });
        } else {
          throw new Error(jsonData?.message || '提交失败');
        }
      } catch (error) {
        console.error('Submit Error:', JSON.stringify(error, null, 2));
        let errorMessage = '网络请求异常';
        if (error instanceof Error) {
          errorMessage = `提交失败: ${error.message}`;
        } else if (typeof error === 'object' && error !== null) {
          errorMessage = `提交失败: ${JSON.stringify(error)}`;
        }
        AlertDialog.show({
          message: errorMessage,
          confirm: {
            value: '确定',
            action: () => {
              console.info('Error dialog confirmed');
            }
          }
        });
      }
    } catch (error) {
      console.error('Submit Error:', JSON.stringify(error));
      let errorMessage = '网络请求异常';
      if (error instanceof Error) {
        errorMessage = `网络请求异常: ${error.message}`;
      } else if (typeof error === 'object' && error !== null) {
        errorMessage = `网络请求异常: ${JSON.stringify(error)}`;
      }
      AlertDialog.show({
        message: errorMessage,
        confirm: {
          value: '确定',
          action: () => {
            console.info('Dialog confirmed');
          }
        }
      });
    }



  }

  // 添加重置表单的方法
  private resetForm() {
    this.dishName = '';
    this.putWeight = '';
    this.destroyPerson = '';
    this.destroyTime = '请选择销毁时间';
    this.sampleImages = '';
    this.fridgeImages = '';
    this.remark = '';
  }

  // 图片选择
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
}