import router from '@ohos.router';
import http from '@ohos.net.http';
interface RecipeFormData extends records{
  photoUri: string;//卡片名对应地点
  id?: string;
  date: string;// 供应时间
  recipeName: string;//制单时间
  mealType: string;//需求类型
  human: string;
  diningType: string;//用餐类型
  summary:  string;
  place: string;//餐别
  planningStatus:string;

}
interface records{//定义接口返回类型
  id?: string;
  createBy: string;
  createTime:  string;
  updateBy: string;
  updateTime: string;// 后端返回的姓名
  schoolId?: string;
  unitId: string;
  schoolName?:string;
  unitName:  string;
  unitType:  string;
  documentNo:string;// 后端返回的code
  supplyDate: string;
  supplyTime: string
  reportUserPhone: string
  auditTime: string
  supplyTime_dictText: string
  planningStatus: string
  rejectOpinion: string
  summary: string
  preparedBy: string
  reportUserName: string
  reportUserId: string
  reportDate: string
  tenantId: string
  requirementType: string
  requirementType_dictText: string
  planningFoodList: string
  izReplenishment: string
  stockId: string
  distributionId: string
  supplierRemark: string
  totalPrice: string
  izPastDue: string
  mealType: string
  mealType_dictText: string
  mealCategory: string
  mealCategory_dictText: string
  planningStatus_dictText: string
  // 其他字段根据实际API响应补充...
}
@Entry
@Component
struct ReportPlanPage {
  @State editLogText: string = ''
  @State isEditMode: boolean = false
  @State showToast: boolean = false
  @State toastMessage: string = ''

  @State selectedUnit: string = '请选择需求单位'
  @State selectedDate: string = '请选择供应日期'
  @State selectDate: Date = new Date() // 默认显示当前日期
  @State upload:number  = 0;//审核栏的状态量
  @State showPopup: boolean = false//判断单据日志打印不是我写的
  @State selectedFoodslenth :  number = 0//根据读到数据加载卡片，现在没接仅测试使用
  private unitOptions = [
    '选择需求单位',
    '实验第二学校（库房）',
    '实验第二学校餐厅'
  ]

  private showAlert(message: string) {
    this.toastMessage = message
    this.showToast = true
  }

  aboutToAppear() {
    if (this.unitOptions.length > 0) {
      this.selectedUnit = this.unitOptions[0]
    }
  }

  build() {

    Column() {

      Row() {
        Button('待审核')
          .width('35%')
          .height(40)
            // .backgroundColor(this.x === 0 ? '#E8F5E9' : '#F5F5F5')
          .backgroundColor(Color.White)
          .fontColor(this.upload === 0 ? '#07C160' : '#666666')
          .fontWeight(this.upload ===0?FontWeight.Bold : FontWeight.Normal)
          .borderRadius(0)// 去除圆角
          .borderWidth(0)// 去除边框
          .onClick(() => {
            this.upload = 0
            this.selectedFoodslenth=0//测试数据待审核一般没有不使用,后期接口赋0
          })
        Button('已审批')
          .width('35%')
          .height(40)
          .backgroundColor(Color.White)
            // .backgroundColor(this.x === 1 ? '#E8F5E9' : '#F5F5F5')
          .fontColor(this.upload === 1 ? '#07C160' : '#666666')
          .fontWeight(this.upload ===1?FontWeight.Bold : FontWeight.Normal)
          .borderRadius(0)// 去除圆角
          .borderWidth(0)// 去除边框
          .onClick(() => {
            this.upload = 1
          })

        Button('已驳回')
          .width('35%')
          .height(40)
            // .backgroundColor(this.x === 2 ? '#E8F5E9' : '#F5F5F5')
          .backgroundColor(Color.White)
          .fontColor(this.upload === 2 ? '#07C160' : '#666666')
          .fontWeight(this.upload ===2?FontWeight.Bold : FontWeight.Normal)
          .borderRadius(0)
          .borderWidth(0)
          .onClick(() => {
            this.upload = 2
          })
      }
      .width('100%')
      .margin({ bottom: 20 })


      Row() {
        Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
          .value(this.unitOptions[0])
          .onSelect((index: number) => {
            this.selectedUnit = this.unitOptions[index]
          })

          .margin(10)
          .width('40%')
          .height(40)
          .font({ size: 12 })

        Text(this.selectedDate)
          .font({ size: 12 })
          .width('60%')
          .height(40)
          .textAlign(TextAlign.Center)
          .borderRadius(4)
          .borderWidth(1)
          .borderColor('#CCCCCC')
          .onClick(() => {
            this.showDateDialog()
          })
          .borderWidth(0) // 去除边框
      }
      .width('100%')
      .margin({ bottom: 15 })
      Scroll(){
        Column() {
          if (this.selectedFoodslenth == 0) {
            List(){

              ListItem()
              {
                //中间卡片部分神中神
                Column() {
                  // Text(formData.photoUri?? 'N/A')
                  Text('实训第二学校餐厅')
                    .width('100%')
                    .height(30)
                    .padding({ left: 10 })
                    .backgroundColor('#E8F5E9') // 背景色区分标题
                    .fontColor('#2E7D32') // 深绿色字体
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)

                  Column({ space: 10 }) {
                    Row() {
                      Text('供应时间：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      // Text(formData.date ?? 'N/A')
                      Text('2025-05-14 上午')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                      if (this.upload==1) {
                        Image($r('app.media.approved'))
                          .width('30%')
                          .position({ top: -20, right: 1})
                      }else if(this.upload==0)  {
                        Image($r('app.media.pendingapproval'))
                          .width('30%')
                          .position({ top: -20, right: 1})
                        //.visible(formData.status === '已上报')
                      }
                      else if(this.upload==2)  {
                        Image($r('app.media.rejected'))
                          .width('30%')
                          .position({ top: -20, right: 1})
                      }
                    }

                    .justifyContent(FlexAlign.Start)

                    Row() {
                      Text('需求单号：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      Text('XQ20250510006')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')

                    }
                    .justifyContent(FlexAlign.Start)
                    if (this.upload==1){
                      Row() {
                        Text('需求类型：')
                          .width('30%')
                          .fontSize(12)
                          .fontColor('#333333')
                        // Text(formData.mealType ?? 'N/A')
                        Text('学生餐')
                          .width('70%')
                          .fontSize(12)
                          .fontColor('#666666')

                      }
                      .justifyContent(FlexAlign.Start)
                    }

                    Row() {
                      Text('用餐类型：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      // Text(formData.diningType ?? 'N/A')
                      Text('营养餐')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    .justifyContent(FlexAlign.Start)
                    if (this.upload==1) {
                      Row() {
                        Text('餐别：')
                          .width('30%')
                          .fontSize(12)
                          .fontColor('#333333')
                        // Text(formData.place ?? 'N/A')
                        Text('早餐')
                          .width('70%')
                          .fontSize(12)
                          .fontColor('#666666')
                      }
                      .justifyContent(FlexAlign.Start)
                    }
                    Row() {
                      Text('制单人：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      // Text(formData.human??'人')
                      Text('人')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    Row() {
                      Text('制单时间：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      // Text(formData.recipeName ?? 'N/A')
                      Text('2025-05-18 123456')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    Row() {
                      Text('审批人：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      // Text(formData.recipeName ?? 'N/A')
                      Text('人')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    Row() {
                      Text('审批时间：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      // Text(formData.recipeName ?? 'N/A')
                      Text('2025-05-18 654321')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    if (this.upload==1) {
                      Row() {
                        Text('摘要：')
                          .width('30%')
                          .fontSize(12)
                          .fontColor('#333333')
                        // Text(formData.summary??'无')
                        Text('11')
                          .width('70%')
                          .fontSize(12)
                          .fontColor('#666666')
                      }
                    }
                    //以上报按钮
                    if (this.upload){
                      Row({space:5}){
                        Button('复制订单')
                          .backgroundColor('#ffffffff')
                          .fontColor('#4CAF50')
                          .fontSize(10)
                          .borderRadius(12)
                          .border({
                            color: '#4CAF50',
                            width: 1
                          })
                          .onClick(() => {
                            AlertDialog.show({
                              title: '复制订单',
                              message: '确定要复制该订单吗？',


                              cancel:()=> {
                              }

                            });
                          })
                        Button('单据日志')
                          .backgroundColor('#ffffffff')
                          .fontColor('#4CAF50')
                          .fontSize(10)
                          .borderRadius(12)
                          .border({
                            color: '#4CAF50',
                            width: 1
                          })
                          .onClick(() => {
                          })
                      }
                      .margin({left: 130})
                    }
                    else {
                      // 操作按钮
                      Row({ space: 5 }) {
                        Button('复制订单')
                          .backgroundColor('#ffffffff')
                          .fontColor('#4CAF50')
                          .fontSize(10)
                          .borderRadius(12)
                          .border({
                            color: '#4CAF50',
                            width: 1
                          })
                          .onClick(() => {


                          })
                        Button('单据日志')
                          .backgroundColor('#ffffffff')
                          .fontColor('#4CAF50')
                          .fontSize(10)
                          .borderRadius(12)
                          .border({
                            color: '#4CAF50',
                            width: 1
                          })
                          .onClick(() => {
                            this.showPopup = true
                          })

                      }
                      .margin({left:130})
                    }
                  }
                  .padding({ left: 10, right: 10, top: 5, bottom: 10 })
                  .backgroundColor(Color.White)
                  .width('100%')
                  .justifyContent(FlexAlign.Start)



                }
                //.padding({ left: 1, right: 10, top: 5, bottom: 10 })
                .backgroundColor('#4CAF50')
                .width('90%')
                .height('auto')
                .alignItems(HorizontalAlign.Center)
                .border({
                  width: 2,
                  color: '#4CAF50',
                  radius: 8
                })
                .shadow({
                  radius: 5,
                  color: '#4CAF50',
                  offsetX: 10,
                  offsetY: 10
                })
                .onClick(() => {
                })
              }
              .width('100%')
              .margin({left:2,right: 10, bottom:10 })

            }
            .width('100%')
            .borderRadius(8)
          }
          else {
            Column() {
              Text('- 暂无相关数据 -')
                .position({
                  x: 110,
                  y: 180
                })
            }
          }

        }
        .width('100%')
        //.backgroundColor('#f2dbdada')
        .layoutWeight(1)
      }
      if (this.showPopup) {

        Stack({ alignContent: Alignment.Bottom }) {
          // 半透明遮罩层
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor(Color.White)
            .onClick(() => {
              this.showPopup = false
            })
          // 弹窗内容
          Column() {
            // 顶部拖拽指示条
            Divider()
              .width(40)
              .color('#CCCCCC')
              .margin({ top: 8, bottom: 12 })
            Text('单据日志')
              .fontSize(17)
              .fontWeight(500)
            Column(){
              Text('新建计划')
                .fontSize(15)
                .fontWeight(240)
                .fontColor(Color.Gray)
                .margin({top:10,right:230,bottom:10})
              Column(){
                Row({space:12}){
                  Text('操作时间:')
                    .fontSize(14)
                  Text('2025-05-18 08:52:52')
                    .width('70%')
                    .fontSize(14)
                }.padding(12)
                Text('人')
                  .fontSize(14)
                  .padding({ left: 10, right: 10, bottom: 10})
              }
              .borderStyle(BorderStyle.Solid)
              .borderColor('#16B76A')
              .borderWidth(2)
              .borderRadius(7)
              .shadow({
                radius: 10,
                color: '#16B76A',
                offsetX: 0,
                offsetY: 4
              })
              .alignItems(HorizontalAlign.Start)
              Text('审批')
                .fontSize(15)
                .fontWeight(240)
                .fontColor('#16B76A')

                .margin({top:10,right:230,bottom:10})
              Column(){
                Row({space:12}){
                  Text('操作时间:')
                    .fontSize(14)
                  Text('2025-05-18 08:52:52')
                    .width('70%')
                    .fontSize(14)
                }.padding(12)
                Text('人')
                  .fontSize(14)
                  .padding({ left: 10, right: 10, bottom: 10})
              }
              .borderStyle(BorderStyle.Solid)
              .borderColor('#16B76A')
              .borderWidth(2)
              .borderRadius(7)
              .shadow({
                radius: 10,
                color: '#16B76A',
                offsetX: 0,
                offsetY: 4
              })
              .alignItems(HorizontalAlign.Start)



            }
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .height('100%')
          .backgroundColor(Color.White)
          .borderRadius(16)
          .shadow({ radius: 24, color: '#33000000' })
          .position({ y: 50 })

        }
        .width('100%')
        .height('60%')
        .zIndex(999)


      }
    }
    .width('100%')
    .height('100%')
    .padding({top:20})
    // .backgroundColor('#F5F5F5')

  }

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
        this.selectedDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

}