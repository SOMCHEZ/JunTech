import { promptAction } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import prompt from '@ohos.prompt';
import router from '@ohos.router';
import http from '@ohos.net.http';

AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);
AppStorage.setOrCreate('unitId', '');
AppStorage.setOrCreate('id', '');
AppStorage.setOrCreate('accountingDate', '');
AppStorage.setOrCreate('mealType', '');
AppStorage.setOrCreate('requirementType', '');
AppStorage.setOrCreate('mealCategory', '');
AppStorage.setOrCreate('digest', '');
AppStorage.setOrCreate('outboundId', '');
AppStorage.setOrCreate('documentNo', '');
AppStorage.setOrCreate('demandUnit', '');
AppStorage.setOrCreate('demandUnitName', '');

interface FoodItem {
  schoolId: string;
  demandUnit: string;
  foodId: string;
  foodName: string;
  encoding: string;
  groupId: string;
  groupName: string;
  unit: string;
  specification: string;
  modifyPrice: number;
  supplyPricing: number;
  totalNum: number;
  totalWeight: number;
  supplyWay: string;
  supplierId: string;
  supplierName: string;
  batch: string;
  images: string;
  requirementType: string;
  mealType: string;
  mealCategory: string;
  accountingDate: string;
  requirementType_dictText: string;
  mealType_dictText: string;
  mealCategory_dictText: string;
  num: string;
  selectId: string;
  marketWeight: number;
}

interface addHandlerResult {
  success: boolean;
  code?: number;
  userInfo?: UserInfo;
  token?: string;
  message?: string;
  relTenantIds?: number;
}

interface addResult {
  userInfo: UserInfo;
  token: string;
}

interface addResponse {
  code: number;
  message: string;
  result: addResult;
  timestamp: number;
}

interface RouteParams {
  accountingDate: string;
  mealType: string;
  requirementType: string;
  mealCategory: string;
  digest: string;
  id?: string;
  documentNo?: string;
  demandUnit?: string;
  demandUnitName?: string;
  token?: string;
  relTenantIds?: number;
  unitId?: string;
}

interface UserInfo {
  id: string;
  username: string;
  clientType: string;
  realname: string;
  avatar: string | null;
  relTenantIds: number;
}

interface SelectOption {
  value: string;
  label: string;
}

interface GeneratedObjectLiteralInterface_1 {
  success: boolean;
  code: number;
  message: string;
}

interface GeneratedObjectLiteralInterface_3 {
  success: boolean;
  message: string;
}

interface GeneratedObjectLiteralInterface_2 {
  success: boolean;
  message: string;
}

@Entry
@Component
struct DatePickerExample {
  @State selectedDate: string = ''
  @State selectDate: Date = new Date()
  @State showDialog: boolean = false
  @State adddal: boolean = true
  @State opacityValue: number = 0
  @State scaleValue: number = 0.8
  @State receivedToken: string = ''
  @State tenantId: number = 0
  @State unitId: string = ""
  @State summary: string = ''
  @State selectedText: string[] = ['请选择', '请选择', '请选择', '其他', '其他', '请输入摘要']
  @State showMealType: boolean = false
  @State accountingDate: string = ''
  @State mealType: string = ''
  @State requirementType: string = ''
  @State mealCategory: string = ''
  @State digest: string = ''
  @State outboundId: string = ''
  @State Id: string = ''
  @State demandUnit: string = ''

  private unitOptions = ['实验第二学校餐厅']
  private selectedTime = ['上午', '下午']
  private demandOptions = ['学生餐', '教师餐']
  private mealTypeOptions = ['其他', '营养餐']
  private mealOptions = ['其他', '早餐', '午餐', '晚餐']

  private mapping: Record<string, string> = {
    '上午': 'forenoon',
    '下午': 'afternoon',
    '学生餐': '1',
    '教师餐': '2',
    '非营养餐': '2',
    '营养餐': '1',
    '其他': '0',
    '早餐': '1',
    '午餐': '2',
    '晚餐': '3'
  }

  private reverseMapping: Record<string, string> = {
    '1': '学生餐',
    '2': '教师餐',
    '0': '其他',
    'forenoon': '上午',
    'afternoon': '下午'
  }

  private convertValueToText(value: string, type: string): string {
    switch (type) {
      case 'mealType':
        return value === '1' ? '学生餐' : value === '2' ? '教师餐' : '其他';
      case 'requirementType':
        return value === '1' ? '营养餐' : value === '2' ? '非营养餐' : '其他';
      case 'mealCategory':
        switch (value) {
          case '0': return '其他';
          case '1': return '早餐';
          case '2': return '午餐';
          case '3': return '晚餐';
          default: return '其他';
        }
      default:
        return value;
    }
  }

  async onPageShow() {
    const params = router.getParams() as RouteParams;

    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
    }
    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
    }
    if (!AppStorage.get('unitId') && params?.unitId) {
      AppStorage.set('unitId', params.unitId);
    }
    if (!AppStorage.get('demandUnit') && params?.demandUnit) {
      AppStorage.set('demandUnit', params.demandUnit);
    }

    this.receivedToken = AppStorage.get('token') ?? '';
    this.tenantId = AppStorage.get('tenantId') ?? 0;
    this.demandUnit = AppStorage.get('demandUnit') ?? '';

    if (params?.mealType) {
      this.selectedText[2] = this.convertValueToText(params.mealType, 'mealType');
    }
    if (params?.requirementType) {
      this.selectedText[3] = this.convertValueToText(params.requirementType, 'requirementType');
    }
    if (params?.mealCategory) {
      this.selectedText[4] = this.convertValueToText(params.mealCategory, 'mealCategory');
    }

    if (params?.demandUnitName) {
      this.selectedText[0] = params.demandUnitName;
    }
    if (params?.accountingDate) {
      this.selectedText[1] = params.accountingDate;
    }
    if (params?.digest) {
      this.selectedText[5] = params.digest || '请输入摘要';
    }
    if (params?.id) {
      this.outboundId = params.id;
    }

    if (this.selectedText[2] === '学生餐') {
      this.showMealType = true;
    }

    console.log('页面数据初始化完成：', this.selectedText);
  }

  private getMappedValues(index?: number): string | string[] {
    if (index !== undefined) {
      const text = this.selectedText[index];
      if (/^\d+$/.test(text)) {
        return text;
      }
      return this.mapping[text] || text;
    }
    return this.selectedText.map(text => this.mapping[text] || text);
  }

  private async addStaff() {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/school/xxSupplyOutManagement/add',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Tenant-Id': this.tenantId.toString(),
            'X-Access-Token': this.receivedToken
          },
          extraData: JSON.stringify({
            "id": this.outboundId,
            "demandUnit": this.demandUnit,
            "demandUnitName": this.selectedText[0],
            "accountingDate": this.selectedText[1],
            "digest": this.selectedText[5],
            "mealType": this.getMappedValues(2),
            "requirementType": this.getMappedValues(3),
            "mealCategory": this.getMappedValues(4),
            "stockStatus": "0",
            "foods": [
              {
                "schoolId": "1917168448022519809",
                "demandUnit": "1917168448072851458",
                "foodId": "1917167634004582414",
                "foodName": "绿豆",
                "encoding": "126",
                "groupId": "1917166561189695489",
                "groupName": "其他",
                "unit": "Kg",
                "specification": "称重",
                "modifyPrice": 20,
                "supplyPricing": 20,
                "totalNum": 0.01,
                "totalWeight": 0,
                "supplyWay": "1",
                "supplierId": "1917168448022519809",
                "supplierName": "实训第二学校",
                "batch": "20240816004",
                "images": "",
                "requirementType": "2",
                "mealType": "1",
                "mealCategory": "0",
                "accountingDate": "2024-08-21",
                "requirementType_dictText": "其他",
                "mealType_dictText": "学生餐",
                "mealCategory_dictText": "其他",
                "num": "0.25",
                "selectId": "1922500586301390849",
                "marketWeight": 0.01
              }
            ] as Array<FoodItem>
          })
        }
      );

      interface ApiResponse {
        code: number;
        message: string;
      }

      if (response.responseCode === 200) {
        const jsonData: ApiResponse = JSON.parse(response.result as string);
        return ({
          success: jsonData.code === 200,
          code: jsonData.code,
          message: jsonData.message
        } as GeneratedObjectLiteralInterface_1);
      }

      return ({
        success: false,
        message: `HTTP Error: ${response.responseCode}`
      } as GeneratedObjectLiteralInterface_2);

    } catch (error) {
      return ({
        success: false,
        message: '请求失败'
      } as GeneratedObjectLiteralInterface_3);
    }
  }

  build() {
    Stack() {
      Column() {
        Scroll() {
          Column() {
            Column({ space: 10 }) {
              this.buildLabelRow($r("app.media.unitName"), "领用单位", true, 0)
              this.buildLabelRow($r("app.media.supplyDate"), "出库日期", true, 1)
              this.buildLabelRow($r("app.media.demand"), "出库类型", true, 2)

              if (this.showMealType) {
                this.buildLabelRow($r("app.media.requirementType"), "用餐类型", false, 3)
              }

              this.buildLabelRow($r("app.media.mealCategory"), "餐别", false, 4)
              this.buildLabelRow($r("app.media.remarks"), "摘要", false, 5)
            }
            .width('100%')
            .padding(10)

            Row() {
              Button({ type: ButtonType.Normal }) {
                Text('+添加食材')
                  .fontSize(16)
                  .fontColor(Color.White)
                  .padding({
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 8
                  })
                  .borderRadius(8)
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/renew'
                    });
                  });
              }
              .width('80%')
              .height(35)
              .backgroundColor('#02BC65')
              .fontColor(Color.White)
              .borderRadius(8)
              .width('auto')
              .padding({ left: 15, right: 15 })

              Text('已选中*种食材')
                .fontColor('#8A96A2')
                .position({ x: 137, y: 15 })
            }

            Column()
              .linearGradient({
                angle: 180,
                colors: [['#93D0B1', 0.1], ['#FDFDFD', 1]],
              })
              .margin({ top: 10 })
              .width('100%')
              .height(20)

            if (this.adddal) {
              Column() {
                Stack() {
                  Column() {
                    Row({ space: 10 }) {
                      Image($r('app.media.food'))
                        .width(70)
                        .borderRadius(0)
                        .margin({ left: 5, top: -115 })
                      Text('绿豆')
                        .fontSize(25)
                        .fontWeight(FontWeight.Bold)
                        .fontColor(Color.Black)
                        .margin({ left: 10, top: -70 })
                      Image($r('app.media.del'))
                        .width(30)
                        .fillColor(Color.Red)
                        .position({ x: 270, y: -25 })
                        .onClick(() => {
                          this.adddal = false
                        })
                    }
                    .width('100%')
                    .height(80)
                    .padding({ left: 20 })
                  }

                  Row()
                    .width('86%')
                    .height(1)
                    .margin({ top: -10, left: 8 })
                    .linearGradient({
                      angle: 90,
                      colors: [
                        ['#FCE4CF', 0],
                        ['#F5A35F', 0.5],
                        ['#FCE4CF', 1]
                      ]
                    })
                    .zIndex(1)

                  Column() {
                    Row() {
                      Text('采  购  价：')
                        .fontWeight(600)
                      Text('12.96')
                        .fontSize(21)
                        .fontWeight(FontWeight.Bold)
                        .fontColor(Color.Red)
                      Text('元/Kg')
                        .fontWeight(600)
                        .fontColor(Color.Red)
                    }
                    .margin({ top: 10 })
                    .zIndex(2)

                    Row() {
                      Text('供  应  商：')
                        .fontWeight(600)
                      Text('彦红粮油有限公司')
                        .fontWeight(600)
                    }
                    .margin({ top: 10 })

                    Row() {
                      Text('学校库存：')
                        .fontWeight(600)
                      Text('1')
                        .fontSize(21)
                        .fontWeight(FontWeight.Bold)
                      Text('Kg')
                        .fontWeight(600)
                    }
                    .margin({ top: 10 })

                    Row({ space: 10 }) {
                      Text('需 求  量：')
                        .fontWeight(600)
                      TextInput({ placeholder: '请输入需求量' })
                        .fontColor('#000')
                        .fontSize(16)
                        .width('40%')
                        .border({
                          width: { bottom: 1 },
                          color: '#ccc'
                        })
                        .onChange((value: string) => {
                          console.log('输入的需求量为:', value)
                        })
                      Text('斤')
                        .fontWeight(600)
                    }

                    Row({ space: 10 }) {
                      Text('需 求  量：')
                        .fontWeight(600)
                      TextInput({ placeholder: '请输入需求量' })
                        .fontColor('#000')
                        .fontSize(16)
                        .width('40%')
                        .border({
                          width: { bottom: 1 },
                          color: '#ccc'
                        })
                        .onChange((value: string) => {
                          console.log('输入的需求量为:', value)
                        })
                      Text('kg')
                        .fontWeight(600)
                    }

                    Row() {
                      Text('合       计：')
                        .fontWeight(600)
                      Text('元')
                        .fontWeight(600)
                        .fontColor(Color.Red)
                    }
                    .margin({ top: 10 })

                    Row() {
                      Text('备       注：')
                        .fontWeight(600)
                      TextInput({ placeholder: '请输入备注' })
                        .fontColor('#000')
                        .fontSize(16)
                        .width('70%')
                        .border({
                          width: { bottom: 1 },
                          color: '#ccc'
                        })
                        .onChange((value: string) => {
                          console.log('输入的备注为:', value)
                        })
                    }
                    .margin({ top: 10 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ top: 100 })

                  Path()
                    .width(40)
                    .height(40)
                    .commands('M0 0 L180 0 L0 180 Z')
                    .fill('#FFA500')
                    .margin({ left: -301, top: -190 })
                    .stroke('#FFA500')
                    .shadow({ radius: 0 })

                  Text('称重')
                    .fontSize(15)
                    .fontColor(Color.White)
                    .rotate({ angle: -45 })
                    .margin({ left: -300, top: -190 })
                }
                .width('100%')
                .height(220)
              }
              .borderWidth(2)
              .borderColor(Color.Orange)
              .width('96%')
              .height(390)
              .padding(5)
              .shadow({
                radius: 10,
                color: '#fffabc85',
                offsetX: 20,
                offsetY: 20
              })
              .margin({ left: '2%', right: '2%' })
            }
          }
          .layoutWeight(1)
        }
        .width('100%')
        .layoutWeight(1)

        if (this.showDialog) {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#80000000')
            .position({ x: 0, y: 0 })
            .opacity(this.opacityValue)
            .onClick(() => {
              animateTo({
                duration: 300,
                curve: Curve.EaseOut
              }, () => {
                this.opacityValue = 0
                this.scaleValue = 0.8
              })
              setTimeout(() => {
                this.showDialog = false
              }, 300)
            })
            .zIndex(6)

          Column() {
            Text('摘要')
              .fontSize(18)
              .margin({ bottom: 16 })

            TextArea({ text: this.summary, placeholder: '输入摘要' })
              .onChange((value: string) => {
                this.selectedText[5] = value
              })
              .height(150)
              .width('100%')
              .border({
                width: 2,
                color: '#4CAF50',
                radius: 8,
              })

            Row({ space: 100 }) {
              Button('取消', { type: ButtonType.Normal })
                .onClick(() => { this.showDialog = false })
                .backgroundColor('#ffffffff')
                .fontColor('#ff706f6f')
              Button('确定', { type: ButtonType.Normal })
                .backgroundColor('#ffffffff')
                .fontColor('#5BC043')
                .onClick(() => { this.showDialog = false })
            }
          }
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .width('80%')
          .position({ x: '11%', y: '30%' })
          .opacity(this.opacityValue)
          .scale({ x: this.scaleValue, y: this.scaleValue })
          .animation({
            duration: 300,
            curve: Curve.EaseOut
          })
          .zIndex(7)
        }

        Column() {
          Divider()
            .strokeWidth(1)
            .color('#ffb1afaf')
            .margin({ top: 0, bottom: 7 })
          Text('总计：*元')
            .fontColor('#8A96A2')
            .fontSize(16)
            .margin({ right: -250 })
          Row({ space: 10 }) {
            Button({ type: ButtonType.Normal }) {
              Text('保存')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .height(35)
            .backgroundColor('#3282FF')
            .fontColor(Color.White)
            .borderRadius(8)
            .width('30%')
            .padding({ left: 15, right: 15 })

            Button({ type: ButtonType.Normal }) {
              Text('保存并审核')
                .fontSize(14)
                .fontColor(Color.White)
            }
            .onClick(async () => {
              const result = await this.addStaff()
              if (result.success) {
                promptAction.showToast({
                  message: '保存成功',
                  duration: 2000
                });
                router.pushUrl({
                  url: 'pages/kucun',
                  params: {
                    token: this.receivedToken,
                    tenantId: this.tenantId,
                  }
                });
              } else {
                promptAction.showToast({
                  message: result.message || '保存失败',
                  duration: 2000
                });
              }
            })
            .height(35)
            .backgroundColor('#02BC65')
            .fontColor(Color.White)
            .borderRadius(8)
            .width('30%')
            .padding({ left: 15, right: 15 })
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .margin({ top: 20 })
        }
        .height(55)
        .padding(10)
        .zIndex(4)
      }
    }
  }

  @Builder
  buildLabelRow(iconResource: Resource, label: string, showAsterisk: boolean, index: number) {
    Column() {
      Row() {
        Row() {
          Image(iconResource)
            .width(30)
            .height(30)
            .objectFit(ImageFit.Contain)
            .margin({ right: 10 })

          Text(label)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)

          if (showAsterisk) {
            Text("*")
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Red)
              .margin({ left: 4 })
          }
        }
        .layoutWeight(1)

        Row() {
          if (label === "摘要") {
            Column() {
              Text(this.selectedText[index] === '请输入摘要' ? '请输入摘要' :
                `${this.selectedText[index].substring(0, 10)}${this.selectedText[index].length > 10 ? '...' : ''}`)
                .fontSize(14)
                .fontColor(this.selectedText[index] === '请输入摘要' ? '#000000' : '#000000')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('250px')
            }
            .alignItems(HorizontalAlign.End)
          } else {
            Text(this.selectedText[index])
              .fontSize(14)
              .fontColor('#000000')
          }

          Image($r("app.media.ic_arrow_right"))
            .width(20)
            .height(20)
            .margin({ left: 5 })
            .fillColor('#8A96A2')
        }
        .justifyContent(FlexAlign.End)
        .onClick(() => {
          switch (label) {
            case "领用单位":
              this.showTextDialog(this.unitOptions, 0)
              break;
            case "出库日期":
              this.showDateDialog()
              break;
            case "出库类型":
              this.showTextDialog(this.demandOptions, 2)
              break;
            case "用餐类型":
              this.showTextDialog(this.mealTypeOptions, 3)
              break;
            case "餐别":
              this.showTextDialog(this.mealOptions, 4)
              break;
            case "摘要":
              this.summary = this.selectedText[5] === '请输入摘要' ? '' : this.selectedText[5]
              this.showDialog = true
              this.opacityValue = 1
              this.scaleValue = 1
              break;
          }
        })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .height(40)
      .padding({ right: 10 })

      Divider()
        .strokeWidth(1)
        .color('#ffb1afaf')
        .margin({ top: 0, bottom: 7 })
    }
    .width('100%')
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
        this.selectedText[1] = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

  private showTextDialog(array: string[], index: number) {
    TextPickerDialog.show({
      range: array,
      selected: array.findIndex(item => item === this.selectedText[index]),
      onAccept: (value: TextPickerResult) => {
        if (typeof value.index === 'number' && value.index < array.length) {
          this.selectedText[index] = array[value.index]
          if (index === 2) {
            this.showMealType = this.selectedText[index] === '学生餐'
            if (!this.showMealType) {
              this.selectedText[3] = '其他'
            }
          }
        }
      }
    })
  }
}