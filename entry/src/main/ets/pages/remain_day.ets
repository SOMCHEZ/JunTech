import router from '@ohos.router';
import http from '@ohos.net.http';

//永久存储token和租户id
AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);

interface SampleFormData {
  id?: string;
  formDataList: boolean;
  from: string;
  date?: string;
  sampleType?: string;
  mealType?: string;
  dishName?: string;
  sampleWeight?: string;
  destroyPerson?: string;
  destroyTime?: string;
  sampleImages?: string[];
  fridgeImages?: string[];
  remark?: string;
}

interface RouteParams {
  token?: string;
  relTenantIds?: number;
}

interface SampleListResult {
  records: SampleFormData[];
  total: number;
  size: number;
  current: number;
}


interface SampleListResponse {
  code: number;
  message: string;
  result: SampleListResult;
  timestamp: number;
}

interface GeneratedTypeLiteralInterface_1 {
  success: boolean;
  records?: SampleFormData[];
  message?: string;
}

@Entry
@Component
struct remain_day {
  private selectDate: Date = new Date()
  @State selectedMeal: string = '请选择餐别'
  @State selectedDate: string = '请选择筛选日期'
  private unitOptions = [
    '全部', '晨检', '午检', '晚检'
  ]
  @State formDataList: SampleFormData[] = []
  @State receivedToken: string = ''
  @State tenantId: number = 0

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

    const result = await this.fetchSampleList();
    if (result.success && result.records) {
      this.formDataList = result.records;
    }
  }

  build() {
    Column() {
      // 顶部选择栏
      Column() {
        Row() {
          Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
            .selected(0)
            .value(this.unitOptions[0])
            .onSelect((index: number) => {
              this.selectedMeal = this.unitOptions[index]
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
          Column() {
            ForEach(this.formDataList, (formData: SampleFormData) => {
              Scroll() {
                Column() {
                  // 信息区
                  Column() {
                    Text(`留样日期：${formData.date}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ top: 8, bottom: 4 })
                    Text(`留样类型：${formData.sampleType}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ bottom: 4 })
                    Text(`餐    别：${formData.mealType}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ bottom: 4 })
                    Text(`菜品名称：${formData.dishName}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ bottom: 4 })
                    Text(`留样重量：${formData.sampleWeight}克`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ bottom: 4 })
                    Text(`销毁人员：${formData.destroyPerson}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ bottom: 4 })
                    Text(`销毁时间：${formData.destroyTime}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ bottom: 8 })
                  }
                  .alignItems(HorizontalAlign.Start)

                  // 图片区
                  if (formData.sampleImages && formData.sampleImages.length > 0) {
                    Text('留样图片：')
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ top: 8, bottom: 4 })
                    Row() {
                      ForEach(formData.sampleImages, (image: string) => {
                        Image(image)
                          .width(120)
                          .height(90)
                          .margin({ right: 8 })
                          .borderRadius(8)
                      })
                    }
                  }

                  if (formData.fridgeImages && formData.fridgeImages.length > 0) {
                    Text('留样柜图片：')
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ top: 8, bottom: 4 })
                    Row() {
                      ForEach(formData.fridgeImages, (image: string) => {
                        Image(image)
                          .width(120)
                          .height(90)
                          .margin({ right: 8 })
                          .borderRadius(8)
                      })
                    }
                  }

                  // 按钮区
                  Row() {
                    Blank()
                    Button('重新编辑')
                      .width(120)
                      .height(36)
                      .fontColor('#07C160')
                      .fontSize(15)
                      .borderRadius(18)
                      .borderWidth(1)
                      .borderColor('#07C160')
                      .backgroundColor('#fff')
                      .onClick(() => {
                        router.pushUrl({
                          url: 'pages/remain',
                          params: {
                            token: this.receivedToken,
                            relTenantIds: this.tenantId,
                            formData: formData
                          }
                        })
                      })
                    Button('删除单据')
                      .width(120)
                      .height(36)
                      .fontColor('#07C160')
                      .fontSize(15)
                      .borderRadius(18)
                      .borderWidth(1)
                      .borderColor('#07C160')
                      .backgroundColor('#fff')
                      .margin({ left: 16 })
                      .onClick(() => {
                        this.deleteSample(formData)
                      })
                  }
                  .margin({ top: 16, bottom: 0 })
                  .justifyContent(FlexAlign.End)
                }
                .backgroundColor('#fff')
                .borderRadius(18)
                .borderWidth(2)
                .borderColor('#07C160')
                .shadow({ radius: 8, color: '#07C16022', offsetX: 0, offsetY: 4 })
                .margin({ top: 12, bottom: 12, left: 8, right: 8 })
                .padding(18)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
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

      // 新建留样按钮
      Button('新建留样', { type: ButtonType.Capsule })
        .width('90%')
        .height(50)
        .backgroundColor('#07C160')
        .fontColor('#FFFFFF')
        .fontSize(18)
        .borderRadius(12)
        .margin({ top: 10, bottom: 20 })
        .alignSelf(ItemAlign.Center)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/remain',
            params: {
              token: this.receivedToken,
              relTenantIds: this.tenantId
            }
          })
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
      onAccept: (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()

        this.selectDate = new Date(year, month - 1, day)
        this.selectedDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

  private async fetchSampleList(): Promise<GeneratedTypeLiteralInterface_1> {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/sample/list',
        {
          method: http.RequestMethod.GET,
          header: {
            'Tenant-Id': this.tenantId.toString(),
            'X-Access-Token': this.receivedToken
          }
        }
      );

      if (response.responseCode !== 200) {
        return {
          success: false,
          message: `HTTP Error: ${response.responseCode}`
        };
      }

      const jsonData = JSON.parse(response.result as string) as SampleListResponse;
      return {
        success: jsonData.code === 200,
        records: jsonData.result.records,
        message: jsonData.message
      };
    } catch (error) {
      console.error('Error:', error);
      return {
        success: false,
        message: '服务器繁忙'
      };
    }
  }

  private async deleteSample(sample: SampleFormData): Promise<void> {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/sample/delete',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Tenant-Id': this.tenantId.toString(),
            'X-Access-Token': this.receivedToken
          },
          extraData: JSON.stringify({
            id: sample.id
          })
        }
      );

      if (response.responseCode === 200) {
        this.formDataList = this.formDataList.filter(item => item !== sample);
      }
    } catch (error) {
      console.error('Delete Error:', error);
    }
  }
}
