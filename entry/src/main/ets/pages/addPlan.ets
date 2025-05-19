import { promptAction } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import prompt from '@ohos.prompt';
import router from '@ohos.router';
import http from '@ohos.net.http';


//永久存储token和租户id
AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);
AppStorage.setOrCreate('unitId', '');
//AppStorage.setOrCreate('selectedFoods', []);

interface PlanningFoodItem {
  id: string;
  storehouseId: number | null;
  foodAndSupplierId: string;
  foodId: string;
  supplyWay: string;
  superiorLimit: number | null;
  lowerLimit: number | null;
  storageLocation: number | null;
  stock: number | null;
  storehouseStatus: number | null;
  izCollect: string;
  encoding: string;
  groupId: string;
  groupName: string;
  foodName: string;
  forShort: string;
  internationalCode: number | null;
  pinyinCode: string;
  specification: string;
  expirationDay: number | null;
  brandLevel: string;
  minDeclare: number | null;
  unit: string;
  packageQuantity: number | null;
  procurementPricing: number | null;
  supplyPricing: number | null;
  marketPrice: number | null;
  modifyPrice: number | null;
  supplyNames: string;
  supplyName: string;
  supplierId: string;
  aggregatePurchasePrice: number | null;
  images: string;
  izConvert: number | null;
  realSpecification: string;
  placeOrigin: string;
  remarks: number | null;
  remark: number | null;
  testReport: number | null;
  supplyWay_dictText: string;
  quantitySupplied: string;
  marketWeight: number | null;
}
interface addHandlerResult {
  success: boolean;
  code?: number;
  userInfo?: UserInfo;
  token?: string;
  message?: string;
  relTenantIds?:number;
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
interface RouteParams {//接口传递参数定义
  token?: string;
  relTenantIds?: number;
  unitId?: string;
  SelectFoodList?: SelectFoodList[];
  AA: string;
  adddal:boolean;
}
interface SelectFoodList {
  foodName: string;
  procurementPricing: string;
  unit: string;
  stock: string;
  supplyName:string;
  images: Resource ;
  groupName:string;
  kg:string;
  jin:string
}
interface UserInfo {
  id: string;
  username: string;
  clientType: string;
  realname: string;
  avatar: string | null;
  relTenantIds:number;
  // 其他字段根据实际API响应补充...
}
interface SelectOption{
  value: string;
  label: string;
}
interface GeneratedObjectLiteralInterface_1 {
  date: string;
  recipeName: string;
  mealType: string;
  diningType: string;
  place: string;
  photoUri: string;
}


@Entry
@Component
struct DatePickerExample {
  @State selectedDate: string = ''
  @State selectDate: Date = new Date()
  @State showDialog: boolean = false
  @State opacityValue: number = 0
  @State scaleValue: number = 0.8
  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上
  @State displayTime: string = ''
  @State unitId: string  ='';
  @State summary: string = ''// 摘要内容
  @State selectedText: string[] = ['请选择','请选择','请选择','请选择','请选择','请选择','请输入摘要']
  @State private showMealType: boolean = false // 控制是否显示用餐类型
  @State kgValue: string = ''//千克值
  @State jinValue: string = ''//斤值
  @State SelectFoodList: SelectFoodList []= []
  @State AA :  string = ''
  @State selectedFoodslenth :  number = 0
  @State lastChanged: 'jin' | 'kg' | null = null;
  private unitOptions = ['实验第二学校（库房）', '实验第二学校餐厅']
  private selectedTime = ['上午', '下午']
  private demandOptions = ['学生餐', '教师餐']
  private mealTypeOptions = ['非营养餐','营养餐']
  private mealOptions = ['其他', '早餐', '午餐', '晚餐']

  // 修改 getMappedValues 函数：显式声明返回类型
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
  };

  private getMappedValues(index?: number): string | string[] {
    if (index !== undefined) {
      const text = this.selectedText[index];
      console.log('')
      return this.mapping[text] || text;
    }
    return this.selectedText.map(text => this.mapping[text] || '');
  }

  private handleLogMapping(): void {
    const mappedValues = this.getMappedValues();
    console.log('Mapped Values:', mappedValues);
    // 可以在此添加更多逻辑
  }

  async onPageShow() {
    const params = router.getParams() as RouteParams;
    console.log('AAAAA',params.AA);
    console.log('1234',params.adddal);
    //console.log('houchu', params?.token);// 打印接收到的参数
    //console.log('houchu', params?.relTenantIds);//  打印接收到的参数

    // 安全取值如果返回值空，则使用appsetcreat中所预保存的token和id
    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
      //this.receivedToken = params.token;
    }

    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
      //this.tenantId = params.relTenantIds;
    }

    if (!AppStorage.get('unitId') && params?.unitId) {
      AppStorage.set('unitId', params.unitId);
      //this.UnitId = params.unitId;
    }

    // 同步到组件状态
    this.SelectFoodList = params.SelectFoodList??[];
    this.receivedToken = AppStorage.get('token')??'';
    this.tenantId = AppStorage.get('tenantId')??0;
    this.unitId = AppStorage.get('unitId') ?? '';

    console.log("recToken_add",this.receivedToken);
    console.log("tenantId_add",this.tenantId);
    console.log("unitId_add",this.unitId);

    if (this.SelectFoodList) {
      this.selectedFoodslenth =this.SelectFoodList.length;
      console.log("selectedFoodss",this.selectedFoodslenth);
      console.log("selectedFoods",this.SelectFoodList[0].foodName);
    }else {
      this.selectedFoodslenth == 0;
    }
    this.AA=params.AA;
    console.log("Plan2",this.AA);
  }

  private async addStaff(): Promise<addHandlerResult> {
    try {
      const httpRequest = http.createHttp();
      // let a:string = '1'
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxDemandPlanning/addOrUpdate',
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json',
            'Tenant-Id':this.tenantId.toString(),
            'X-Access-Token':this.receivedToken
          },
          extraData: JSON.stringify({
            "unitId": this.unitId,
            "supplyDate": this.selectedText[1],
            "supplyTime": this.getMappedValues(2),
            "requirementType": this.getMappedValues(4),
            "planningFoodList": [
              {
                "id": "",
                "storehouseId": null,
                "foodAndSupplierId": "",
                "foodId": "",
                "supplyWay": "",
                "superiorLimit": null,
                "lowerLimit": null,
                "storageLocation": null,
                "stock": null,
                "storehouseStatus": null,
                "izCollect": "",
                "encoding": "",
                "groupId": "",
                "groupName": "",
                "foodName": "",
                "forShort": "",
                "internationalCode": null,
                "pinyinCode": "",
                "specification": "",
                "expirationDay": null,
                "brandLevel": "",
                "minDeclare": null,
                "unit": "",
                "packageQuantity": null,
                "procurementPricing": null,
                "supplyPricing": null,
                "marketPrice": null,
                "modifyPrice": null,
                "supplyNames": "",
                "supplyName": "",
                "supplierId": "",
                "aggregatePurchasePrice": null,
                "images": "",
                "izConvert": null,
                "realSpecification": "",
                "placeOrigin": "",
                "remarks": null,
                "remark": null,
                "testReport": null,
                "supplyWay_dictText": "",
                "quantitySupplied": "",
                "marketWeight": null
              }
            ] as  Array<PlanningFoodItem>,
            "summary": this.selectedText[6],
            "mealType": this.getMappedValues(3),
            "mealCategory": this.getMappedValues(5),
            "unitName": this.getMappedValues(0),
            "unitType": "1",
            "planningStatus": "1"
          })
        }
      );

      if (response.responseCode !== 200) {
        return {
          success: false,
          message: `HTTP Error: ${response.responseCode}`
          // 添加其他错误处理逻辑
        };
      }
      const jsonData = JSON.parse(response.result as string) as addResponse;
      //console.log('', response.responseCode);
      //console.log('',jsonData.code);
      console.log('UnitId:',this.unitId);
      return {
        success: jsonData.code === 200,
        code: jsonData.code,
        //userInfo: jsonData.result.userInfo,
        // token: jsonData.result.token,
        message: jsonData.message,
        relTenantIds:jsonData.result.userInfo.relTenantIds
      };
    } catch (error) {
      //console.error('Login Error:', JSON.stringify(error));
      return {
        success: false,
        message: 'fuck u!'
      };
    }
  }
  build() {
    Stack(){
      Column() {
        Scroll(){
          Column(){
            Column({ space: 10 }) {
              this.buildLabelRow($r("app.media.unitName"), "需求单位", true, 0)
              this.buildLabelRow($r("app.media.supplyDate"), "供应日期", true, 1)
              this.buildLabelRow($r("app.media.supplyTime"), "供应时间", false, 2)
              this.buildLabelRow($r("app.media.demand"), "需求类型", true, 3)

              // 条件用餐类型行
              if (this.showMealType) {
                this.buildLabelRow($r("app.media.requirementType"), "用餐类型", true, 4)
              }

              this.buildLabelRow($r("app.media.mealCategory"), "餐别", true, 5)
              this.buildLabelRow($r("app.media.remarks"), "摘要", false, 6)

            }
            .width('100%')
            .padding(10)
            // 添加食材按钮
            Row() {
              Button({type: ButtonType.Normal}) {
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
                    // 跳转到 chuku 页面
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

              Text(`已选中${this.selectedFoodslenth}种食材`)
                .fontColor('#8A96A2')
                .position({ x: 137, y: 15 })

            }

            Column()//渐变框
              .linearGradient({
                angle: 180,
                colors: [['#93D0B1', 0.1],['#FDFDFD',1]],
              })
              .margin({top: 10})
              .width('100%')
              .height(20)
            if (this.selectedFoodslenth) {
              // 显示条件用餐类型行
              Column({space:  10}){
                ForEach(this.SelectFoodList,(item: SelectFoodList, index: number)=>{
                  Column() {
                    Stack() {
                      // 主内容区域
                      Column() {
                        // 第一行：图片、名称和收藏按钮
                        Row({ space: 10 }) {
                          Image(item.images)
                            .width(70)
                            .borderRadius(0)
                            .margin({ left: 5, top: -115 }) // 原position x:-150 → 计算实际左边距
                          Text(item.foodName)
                            .fontSize(25)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(Color.Black)
                            .margin({ left: 10, top: -70 }) // 右侧固定位置
                          Image($r('app.media.del'))
                            .width(30)
                            .fillColor(Color.Red)
                            .position({ x: 270, y: -25 })
                            .onClick(() => {
                              this.SelectFoodList.splice(index, 1); // 删除当前项
                              this.selectedFoodslenth = this.SelectFoodList.length;
                            })
                        }
                        .width('100%')
                        .height(80)
                        .padding({ left: 20 })
                      }
                      // 渐变分割线 (精确匹配原位置)
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
                      // 采购价信息
                      Column() {
                        // 采购价信息
                        Row() {
                          Text('采  购  价：')
                            .fontWeight(600)
                          Text(item.procurementPricing ?? '0')
                            .fontSize(21)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(Color.Red)
                          Text('元/Kg')
                            .fontWeight(600)
                            .fontColor(Color.Red)
                        }
                        .margin({ top: 10 })
                        .zIndex(2)
                        // 供应商信息
                        Row() {
                          Text('供  应  商：')
                            .fontWeight(600)
                          Text(item.supplyName)
                            .fontWeight(600)
                        }
                        .margin({ top: 10 })
                        // 学校库存
                        Row() {
                          Text('学校库存：')
                            .fontWeight(600)
                          Text(item.stock ?? '0')
                            .fontSize(21)
                            .fontWeight(FontWeight.Bold)
                          Text('Kg')
                            .fontWeight(600)
                        }
                        .margin({ top: 10 })
                        // 斤输入框
                        // 斤输入框
                        Row({ space: 10 }) {
                          Text('需 求  量：')
                            .fontWeight(600)
                          TextInput({ placeholder: '请输入斤数', text: item.jin })
                            .width('40%')
                            .onChange((value: string) => {
                              const jinNum = parseFloat(value);
                              this.SelectFoodList[index].jin = value;
                              if (!isNaN(jinNum)) {
                                this.SelectFoodList[index].kg = (jinNum / 2).toString();

                              } else {
                                this.SelectFoodList[index].kg = '';
                              }
                            })
                          Text('斤')
                        }


                        //kg 输入框
                        Row({ space: 10 }) {
                          Text('需 求  量：')
                            .fontWeight(600)
                          TextInput({ placeholder: '请输入kg数', text: item.kg })
                            .width('40%')
                            .onChange((value: string) => {
                              const kgNum = parseFloat(value);
                              this.SelectFoodList[index].kg = value;
                              if (!isNaN(kgNum)) {
                                this.SelectFoodList[index].jin = (kgNum * 2).toString();
                              } else {
                                this.SelectFoodList[index].jin = '';
                              }
                            })
                          Text('kg')
                        }

                        // 合计
                        Row() {
                          Text('合       计：')
                            .fontWeight(600)
                          Text(this.calculateTotal())
                            .fontSize(21)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(Color.Red)
                          Text('元')
                            .fontWeight(600)
                            .fontColor(Color.Red)
                        }
                        .margin({ top: 10 })
                        // 备注
                        Row() {
                          Text('备       注：')
                            .fontWeight(600)
                          TextInput({ placeholder: '请输入备注' })
                            .fontColor('#000') // 输入文字颜色
                            .fontSize(16)
                            .width('70%') // 设置输入框宽度
                            .border({
                              width: { bottom: 1 }, // 只设置底部边框
                              color: '#ccc'
                            })
                            .onChange((value: string) => {
                              // 可以在这里处理输入变化
                              console.log(`第${index}个食材备注:`, value);
                            })
                        }
                        .margin({ top: 10 })
                      }
                      .alignItems(HorizontalAlign.Start) // 关键：统一左对齐
                      .margin({ top: 100 })
                      // 左上角三角形标签 (精确匹配)
                      Path()
                        .width(40)
                        .height(40)
                        .commands('M0 0 L180 0 L0 180 Z')
                        .fill('#FFA500')
                        .margin({ left: -301, top: -190 })
                        .stroke('#FFA500') // 无边框
                        .shadow({ radius: 0 }) // 确保无阴影
                      Text('称重')
                        .fontSize(15)
                        .fontColor(Color.White)
                        .rotate({ angle: -45 })
                        .margin({ left: -300, top: -190 })
                      // 右下角三角形 (精确匹配)
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
                }, (item: SelectFoodList) => item.foodName)

              }
              .width('100%')

            }
            //中间卡片部分
          }
          .width('100%')
          .layoutWeight(1)

        }
        .align(Alignment.Top)
        .scrollBarWidth(0)
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        if (this.showDialog) {
          // 半透明背景层
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
          // 对话框内容
          Column() {
            Text('摘要')
              .fontSize(18)
              .margin({ bottom: 16 })

            TextArea({ text:this.summary,placeholder: '输入摘要'})

              .onChange((value: string) => {
                // this.summary = value
                this.selectedText[6] = value
              })
              .height(150)
              .width('100%')
              .border({
                width: 2,                     // 边框宽度
                color: '#4CAF50',             // 边框颜色
                radius: 8,                    // 圆角半径

              })

            Row({space:100}) {
              Button('取消', {type: ButtonType.Normal})
                .onClick(() => { this.showDialog = false })
                .backgroundColor('#ffffffff')
                .fontColor('#ff706f6f')
              Button('确定', {type: ButtonType.Normal})
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
        // 底部按钮部分
        Column() {
          Divider()
            .strokeWidth(1)
            .color('#ffb1afaf')
            .margin({ top: 0, bottom: 7 })
          Row() {

            Text('总计：')
              .fontColor('#8A96A2')
              .fontSize(16)
              .margin({ right: 10 })
            Text(this.calculateTotal())
              .fontColor('#8A96A2')
              .fontSize(16)
              .margin({ right: -10 })
            Text('元')
              .fontColor('#8A96A2')
              .fontSize(16)
              .margin({ right: 25 })
            Button({type: ButtonType.Normal}){
              Text('保存')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .height(35)
            .backgroundColor('#02BC65')
            .fontColor(Color.White)
            .borderRadius(8)
            .width('auto')
            .padding({ left: 15, right: 15 })

            Button({type: ButtonType.Normal}){
              Text('保存上报')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .onClick(async() => {
              const result = await this.addStaff()
              // 获取 selectedText[1] 对应的映射值
              const singleValue = this.handleLogMapping()
              console.log('singleValue:', singleValue)
              //this.submitForm();
              // if(this.selectedText[2]==='请选择')
              //   this.selectedText[2] = ''
              this.submitForm()
            })
            .height(35)
            .backgroundColor('#02BC65')
            .fontColor(Color.White)
            .borderRadius(8)
            .width('auto')
            .padding({ left: 15, right: 15 })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
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
        // 左侧图标和标签
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

        // 右侧选择区域
        Row() {
          // 使用固定宽度容器包裹 Text 组件

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
        .justifyContent(FlexAlign.End) // 确保文本和箭头靠右对齐

        .onClick(() => {
          switch (label){
            case "需求单位":
              this.showTextDialog(this.unitOptions,0)
              break;
            case "供应日期":
              this.showDateDialog()
              break;
            case "供应时间":
              this.showTextDialog(this.selectedTime,2)
              break;
            case "需求类型":
              this.showTextDialog(this.demandOptions,3)
              break;
            case "用餐类型":
              this.showTextDialog(this.mealTypeOptions,4)
              break;
            case "餐别":
              this.showTextDialog(this.mealOptions,5)
              break;
            case "摘要":
              this.summary = this.selectedText[6] === '请输入摘要' ? '' : this.selectedText[6]
              this.showDialog = true
              this.opacityValue = 1
              this.scaleValue = 1
              break;

          }
        })      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .height(40)
      .padding({ right: 10 })

      // 添加横线
      Divider()
        .strokeWidth(1)
        .color('#ffb1afaf')
        .margin({ top: 0, bottom: 7 })
    }
    .width('100%')
  }
  //日历函数

  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth()+1
        const day = value.day ?? new Date().getDate()
        this.selectDate = new Date(year, month-1 , day)
        this.selectedText[1] = `${year}-${(month+1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

  private showTextDialog(array:string[],index:number) {
    TextPickerDialog.show({
      range: array,
      selected: array.findIndex(item => item === this.selectedText[index]),
      canLoop:false,
      onAccept: (value: TextPickerResult) => {
        if (typeof value.index === 'number' && value.index < array.length) {
          this.selectedText[index] = array[value.index]
          this.displayTime = this.selectedText[index] === 'forenoon' ? '上午' : this.selectedText[index]
        }
        switch (index){
          case 3:
            if(this.selectedText[index] === '学生餐')
              this.showMealType = true
            else{
              this.showMealType = false
              this.selectedText[4] = '请选择'
            }
            break;
          case 4:
            this.showMealType = true
            break;
          default :
            if(!this.showMealType){
              this.showMealType = false
              this.selectedText[4] = '请选择'
            }
            break;
        }
      }
    })
  }
  //合计乘积函数
  private calculateTotal(): string {
    const price = parseFloat(this.SelectFoodList[0]?.procurementPricing ?? '0');
    const kg = parseFloat(this.kgValue ?? '0');

    if (isNaN(price) || isNaN(kg)) {
      return '0.00';
    }

    const total = price * kg;
    return total.toFixed(2); // 保留两位小数
  }
  private submitForm() {
    // 验证必填项
    const isStudentMeal = this.selectedText[3] === '学生餐';
    //
    if (this.selectedText[0] === '请选择' ||  // 需求单位
      this.selectedText[1] === '请选择' ||  // 供应日期
      this.selectedText[3] === '请选择' ||  // 需求类型
      this.selectedText[5] === '请选择'     // 餐别
    ) {
      prompt.showToast({
        message: '请填写所有必填项',
        duration: 2000
      });
      return;
    }
    // 如果是学生餐，则必须填写用餐类型
    if (isStudentMeal && this.selectedText[4] === '请选择') {
      prompt.showToast({
        message: '请选择用餐类型',
        duration: 2000
      });
      return;
    }
    prompt.showToast({
      message: '保存成功',
      duration: 2000
    });
    router.pushUrl({
      url: 'pages/uploadPlan',
      params: {
        token: this.receivedToken,
        tenantId: this.tenantId,
      } })

    // 创建表单数据对象
    let formData: GeneratedObjectLiteralInterface_1 = {
      date: this.selectedText[2] === '请选择'
        ? this.selectedText[1]
        : `${this.selectedText[1]} ${this.selectedText[2]}`,
      recipeName: this.selectedText[1], // 使用已选择的日期
      mealType: this.selectedText[3],   // 使用已选择的餐别
      diningType: isStudentMeal ? this.selectedText[4] : '', // 非学生餐时为空 用餐类型
      place: this.selectedText[5],      // 需求单位
      photoUri: this.selectedText[0]    // 餐别（如果需要）
    };

    // 跳转到 'uploadPlan' 页面并传递 formData
    router.back ({
      url: 'pages/uploadPlan',  // 页面路径
      params: formData          // 传递的参数
    });
  }
}