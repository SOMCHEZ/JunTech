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
  sampleImage?: string; // 改为单个图片
  fridgeImage?: string; // 改为单个图片
  remark?: string;
}

interface SampleResponse {
  code: number;
  message: string;
  result: string; // 根据实际使用场景替换为具体类型
  success: boolean;
  timestamp: number;
}


interface GeneratedObjectLiteralInterface_1 {
  '早餐': string;
  '午餐': string;
  '晚餐': string;
  '早点': string;
  '午点': string;
  '晚点': string;
  '其他': string;
  '营养改善计划': string;
}

interface GeneratedObjectLiteralInterface_2 {
  demandUnit: string;
  demandUnitName: string;
  reservedSampleDate: string;
  mealCategory: string;
  dishName: string;
  remark: string;
  cabinetTemperature: string;
  destroyPerson: string;
  destroyTime: string;
  sampleType: string;
  putWeight: string;
  reservedSampleImages: string;
  cabinetPhoto: string;
}

interface GeneratedObjectLiteralInterface_3 {
  demandUnit: string;
  demandUnitName: string;
  reservedSampleDate: string;
  mealCategory: string;
  dishName: string;
  remark: string;
  cabinetTemperature: string;
  destroyPerson: string;
  destroyTime: string;
  sampleType: string;
  putWeight: string;
  reservedSampleImages: string;
  cabinetPhoto: string;
}

interface GeneratedObjectLiteralInterface_4 {
  'Content-Type': string;
  'Tenant-Id': string;
  'X-Access-Token': string;
}

interface GeneratedObjectLiteralInterface_5 {
  demandUnit: string;
  demandUnitName: string;
  reservedSampleDate: string;
  mealCategory: string;
  dishName: string;
  remark: string;
  cabinetTemperature: number;
  destroyPerson: string;
  destroyTime: string;
  sampleType: string;
  putWeight: number;
  reservedSampleImages: string;
  cabinetPhoto: string;
}

interface GeneratedObjectLiteralInterface_8 {
  'Content-Type': string;
  'Tenant-Id': string;
  'X-Access-Token': string;
}

interface GeneratedObjectLiteralInterface_6 {
  demandUnit: string;
  demandUnitName: string;
  reservedSampleDate: string;
  mealCategory: string;
  dishName: string;
  remark: string;
  cabinetTemperature: number;
  destroyPerson: string;
  destroyTime: string;
  sampleType: string;
  putWeight: number;
  reservedSampleImages: string;
  cabinetPhoto: string;
}

interface GeneratedObjectLiteralInterface_7 {
  contentType: string;
  tenantId: string;
  xAccessToken: string;
}

interface GeneratedObjectLiteralInterface_9 {
  demandUnit: string;
  demandUnitName: string;
  reservedSampleDate: string;
  mealCategory: string;
  dishName: string;
  remark: string;
  cabinetTemperature: number;
  destroyPerson: string;
  destroyTime: string;
  sampleType: string;
  putWeight: number;
  reservedSampleImages: string;
  cabinetPhoto: string;
}

interface GeneratedObjectLiteralInterface_11 {
  'Content-Type': string;
  'Tenant-Id': string;
  'X-Access-Token': string;
}

interface GeneratedObjectLiteralInterface_10 {
  contentType: string;
  tenantId: string;
  xAccessToken: string;
}

interface GeneratedObjectLiteralInterface_12 {
  demandUnit: string;
  demandUnitName: string;
  reservedSampleDate: string;
  mealCategory: string;
  dishName: string;
  remark: string;
  cabinetTemperature: number;
  destroyPerson: string;
  destroyTime: string;
  sampleType: string;
  putWeight: number;
  reservedSampleImages: string;
  cabinetPhoto: string;
}

interface GeneratedObjectLiteralInterface_14 {
  'Content-Type': string;
  'Tenant-Id': string;
  'X-Access-Token': string;
  'Accept': string;
}

interface GeneratedObjectLiteralInterface_13 {
  contentType: string;
  tenantId: string;
  xAccessToken: string;
}

interface GeneratedObjectLiteralInterface_15 {
  demandUnit: string;
  demandUnitName: string;
  reservedSampleDate: string;
  mealCategory: string;
  dishName: string;
  remark: string;
  cabinetTemperature: number;
  destroyPerson: string;
  destroyTime: string;
  sampleType: string;
  putWeight: number;
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
  @State sampleImage: string = '' // 改为单个图片
  @State fridgeImage: string = '' // 改为单个图片
  @State remark: string = ''
  @State receivedToken: string = ''
  @State tenantId: number = 0
  private unitOptions: string[] = ['实训第二学校餐厅', '其他']
  private typeOptions: string[] = ['不区分', '教师餐', '学生餐']
  private mealOptions: string[] = ['早餐', '午餐', '晚餐', '早点', '午点', '晚点', '其他', '营养改善计划']
  private photoPicker = new picker.PhotoViewPicker();

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
              .value(this.sampleType)
              .onSelect(index => this.sampleType = this.typeOptions[index])
              .width('65%')
          }
          .margin({ top: 5, bottom: 5 })

          // 餐别
          Row() {
            this.formRow('餐    别', true)
            Select(this.mealOptions.map<SelectOption>(item => ({ value: item })))
              .value(this.mealType)
              .onSelect(index => this.mealType = this.mealOptions[index])
              .width('65%')
          }
          .margin({ top: 5, bottom: 5 })

          // 留样柜温度
          Row() {
            this.formRow('留样柜温度℃', true)
            TextInput({ placeholder: '5' })
              .type(InputType.Number)
              .onChange(val => this.fridgeTemp = val)
              .width('100%')
          }
          .margin({ top: 5, bottom: 5 })

          // 菜品名称
          Row() {
            this.formRow('菜品名称', true)
            TextInput({ placeholder: '请输入菜品名称' })
              .onChange(val => this.dishName = val)
              .width('100%')
          }
          .margin({ top: 5, bottom: 5 })

          // 留样重量
          Row() {
            this.formRow('留样重量(克)', true)
            TextInput({ placeholder: '请输入留样重量' })
              .type(InputType.Number)
              .onChange(val => this.sampleWeight = val)
              .width('100%')
          }
          .margin({ top: 5, bottom: 5 })

          // 销毁人员
          Row() {
            this.formRow('销毁人员', true)
            TextInput({ placeholder: '请输入销毁人员' })
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
          this.formImageRow('上传留样图片', true, this.sampleImage, (url: string) => this.sampleImage = url)

          // 放入留样柜拍照
          this.formImageRow('放入留样柜拍照', true, this.fridgeImage, (url: string) => this.fridgeImage = url)

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

    if (params?.formData) {
      const formData = params.formData;
      this.sampleDate = formData.date ?? '请选择日期';
      this.sampleType = formData.sampleType ?? '不区分';
      this.mealType = formData.mealType ?? '午餐';
      this.dishName = formData.dishName ?? '';
      this.sampleWeight = formData.sampleWeight ?? '';
      this.destroyPerson = formData.destroyPerson ?? '';
      this.destroyTime = formData.destroyTime ?? '请选择销毁时间';
      this.sampleImage = formData.sampleImage ?? '';
      this.fridgeImage = formData.fridgeImage ?? '';
      this.remark = formData.remark ?? '';
    }
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
        if (required) {
          Text('*')
            .fontColor('#ff0000')
            .margin({ left: 4 });
        }
      }
      .margin({ top: 5, bottom: 5 })

      Row() {
        if (imageUrl) {
          Stack() {
            Image(imageUrl)
              .width(100)
              .height(100)
              .borderRadius(8)
              .objectFit(ImageFit.Cover)

            Button({ type: ButtonType.Circle }) {
              Image($r('app.media.error'))
                .width(20)
                .height(20)
            }
            .width(24)
            .height(24)
            .position({ x: 80, y: 0 })
            .backgroundColor('#FF0000')
            .onClick(() => onChange(''))
          }
          .margin({ right: 10 })
        }

        // 上传图片按钮
        if (!imageUrl) {
          Image($r('app.media.evidence_add'))
            .width(100)
            .height(100)
            .onClick(async () => {
              try {
                const result = await this.photoPicker.select();
                if (result?.photoUris?.[0]) {
                  onChange(result.photoUris[0]);
                }
              } catch (error) {
                console.error('选择图片失败:', error);
                prompt.showToast({ message: '选择图片失败' });
              }
            })
        }
      }
      .margin({ top: 5, bottom: 5 })
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
        this.destroyTime = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

  // 获取餐别值
  private getMealCategoryValue(mealType: string): string {
    switch (mealType) {
      case '早餐':
        return '0';
      case '午餐':
        return '1';
      case '晚餐':
        return '2';
      case '早点':
        return '3';
      case '午点':
        return '4';
      case '晚点':
        return '5';
      case '其他':
        return '6';
      case '营养改善计划':
        return '7';
      default:
        return '1';
    }
  }

  // 获取留样类型值
  private getSampleTypeValue(sampleType: string): string {
    return sampleType === '不区分' ? '0' :
      sampleType === '教师餐' ? '1' :
        sampleType === '学生餐' ? '2' : '0';
  }

  // 提交数据
  // 提交数据
  // 提交数据
  private async submit(): Promise<void> {
    try {
      // 验证必填字段
      if (!this.submitUnit || this.sampleDate === '请选择日期' || !this.dishName || !this.sampleWeight) {
        AlertDialog.show({ message: '请填写必填项' });
        return;
      }

      const httpRequest = http.createHttp();

      // 准备请求数据
      const requestData: GeneratedObjectLiteralInterface_15 = {
        demandUnit: "1651892693627330561",
        demandUnitName: this.submitUnit.trim(),
        reservedSampleDate: this.sampleDate,
        mealCategory: this.getMealCategoryValue(this.mealType),
        dishName: this.dishName.trim(),
        remark: this.remark ? this.remark.trim() : "",
        cabinetTemperature: Number(this.fridgeTemp) || 5,
        destroyPerson: this.destroyPerson ? this.destroyPerson.trim() : "",
        destroyTime: this.destroyTime !== '请选择销毁时间' ? `${this.destroyTime} 15:03` : "",
        sampleType: this.getSampleTypeValue(this.sampleType),
        putWeight: Number(this.sampleWeight) || 0,
        reservedSampleImages: this.sampleImage ||
          "https://admin.suoeryun.com/pcUpload/1917474932601933825_1745996623568.png",
        cabinetPhoto: this.fridgeImage || "https://admin.suoeryun.com/pcUpload/1917474946438942721_1745996626850.png"
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

      // 确保重量是正数且为整数
      requestData.putWeight = Math.floor(Number(requestData.putWeight));
      if (requestData.putWeight <= 0) {
        AlertDialog.show({ message: '留样重量必须大于0' });
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
      console.info('Request URL:', 'https://api.suoeryun.com/ifood/jeecg-school/school/xxReservedSample/add');
      console.info('Request Headers:', JSON.stringify(apiHeaders, null, 2));
      console.info('Request Data:', JSON.stringify(requestData, null, 2));
      console.info('TenantId: ' + headers.tenantId);
      console.info('Token: ' + headers.xAccessToken);

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
          console.info('Raw Response (string):', response.result);
          jsonData = JSON.parse(response.result);
        } else if (typeof response.result === 'object') {
          console.info('Raw Response (object):', JSON.stringify(response.result, null, 2));
          jsonData = response.result as SampleResponse;
        } else {
          throw new Error('Unexpected response format');
        }

        console.info('Processed Response:', JSON.stringify(jsonData, null, 2));

        if (jsonData && jsonData.success) {
          prompt.showToast({
            message: jsonData.message || '提交成功',
            duration: 2000
          });

          // 保存成功后，清空或重置表单
          this.resetForm();

          const formData: SampleFormData = {
            unitName: this.submitUnit,
            date: this.sampleDate,
            sampleType: this.sampleType,
            mealType: this.mealType,
            fridgeTemp: this.fridgeTemp,
            dishName: this.dishName,
            sampleWeight: this.sampleWeight,
            destroyPerson: this.destroyPerson,
            destroyTime: this.destroyTime,
            sampleImage: this.sampleImage,
            fridgeImage: this.fridgeImage,
            remark: this.remark
          };

          await AppStorage.set('newSampleData', JSON.stringify(formData));
          router.pushUrl({
            url: 'pages/remain_day',
            params: {
              formData: formData,
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
    this.sampleWeight = '';
    this.destroyPerson = '';
    this.destroyTime = '请选择销毁时间';
    this.sampleImage = '';
    this.fridgeImage = '';
    this.remark = '';
  }
}