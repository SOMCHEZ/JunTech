import router from '@ohos.router';
import http from '@ohos.net.http';
//这里是接口数据类型的声明

interface SelectFoodList {
  foodName: string;
  procurementPricing: string;
  unit: string;
  stock: string;
  supplyName:string;
  images: Resource ;
  groupName:string;
}
interface RouteParams {//接口传递参数定义
  token?: string;
  relTenantIds?: number;
  SelectFoodList?: SelectFoodList[];
  //unitId?: string;
}
@Entry
@Component
struct d {
  @State isSelected: boolean = false
  @State isBothClicked: boolean = false
  @State showToast: boolean = false
  @State SelectFoodList: SelectFoodList []= []
  @State selectedFoodslenth :  number = 0
  @State toastMessage: string = ''
  @State adddal: boolean = true

  build() {
    Column() {
      //中间内容区域
      Image($r("app.media.info_bord"))
        .width('100%')
        .height('1%')
        .objectFit(ImageFit.Cover)

      Column({space: 10}){
        Text('实训第二学校餐厅')
          .fontSize(25)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })
          .padding({ left: -150 })
        Row() {
          Text('供应时间：')
            .width('20%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
          Text('2025-05-07 上午')
            .width('50%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
          Image($r('app.media.approved'))
            .width('25%')
            .position({ top: -50, right: -100})
        }
        Row() {
          Text('摘       要：')
            .width('20%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
          Text('1')
            .width('50%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
        }
        Image($r("app.media.info_bord"))
          .width('100%')
          .height('1%')
          .objectFit(ImageFit.Cover)
        Column()//渐变框
          .linearGradient({
            angle: 180,
            colors: [['#93D0B1', 0.1],['#FDFDFD',1]],
          })
          .margin({top: -10})
          .width('100%')
          .height(20)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({ top: 10, bottom: 10, left: 10, right: 10 })
      //卢蓝鹊不知名使用框出错不找我
      if (this.adddal) {
        // 显示条件用餐类型行
        Column() {
          Stack() {
            // 主内容区域
            Column() {
              // 第一行：图片、名称和收藏按钮
              Row({ space: 10 }) {
                Image($r('app.media.food'))
                  .width(70)
                  .borderRadius(0)
                  .margin({ left: 5, top: -115 }) // 原position x:-150 → 计算实际左边距
                Text('绿豆')
                  .fontSize(25)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.Black)
                    //.margin({ left: 10, top: -65}) // 与图片保持相对位置
                  .margin({ left: 10, top: -70 }) // 右侧固定位置
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
            Column() {
              Row() {
                Text('库存量：')
                  .fontWeight(600)
                Text('2.6')
                  .fontSize(21)
                  .fontWeight(FontWeight.Bolder)
                  .fontColor(Color.Black)
                Text('Kg')
                  .fontWeight(600)
                  .fontColor(Color.Black)
                  .margin({ right: 30 })
                Text('品       牌：')
                  .fontWeight(600)
                Text('农家')
                  .fontWeight(600)
                  .fontColor(Color.Black)
              }
              .margin({ top: 10 })
              .zIndex(2)
              Row() {
                Text('采购价：')
                  .fontWeight(600)
                Text('1')
                  .fontSize(21)
                  .fontWeight(FontWeight.Bolder)
                  .fontColor(Color.Red)
                Text('Kg')
                  .fontWeight(600)
                  .fontColor(Color.Red)
              }
              .margin({ top: 10 })
              Row() {
                Text('供应商：')
                  .fontWeight(600)
                Text('俊俊子集团')
                  .fontWeight(600)
              }
              .margin({ top: 10 })
              Row() {
                Text('规       格：')
                  .fontWeight(600)
                Text('')
                  .fontWeight(600)
              }
              .margin({ top: 10 })
              // 需求量
              Row() {
                Text('需 求  量：')
                  .fontWeight(600)
                Text('1')
                  .fontSize(21)
                  .fontWeight(FontWeight.Bolder)
                  .fontColor(Color.Red)
                Text('kg')
                  .fontWeight(600)
                  .margin({ right: 40 })
                Text('合       计：')
                  .fontWeight(600)
                Text('元')
                  .fontWeight(600)
                  .fontColor(Color.Red)
              }
              // 合计
              .margin({ top: 10 })
              // 备注
              Row() {
                Text('备       注：')
                  .fontWeight(600)
              }
              .margin({ top: 10 })
            }
            .alignItems(HorizontalAlign.Start) // 关键：统一左对齐
            .margin({ top: 100,  left: -70 })
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
        .height(330)
        .padding(5)
        .shadow({
          radius: 10,
          color: '#fffabc85',
          offsetX: 20,
          offsetY: 20
        })
        .margin({ left: '2%', right: '2%' })
      }
      Blank()//占据整个空白区域
      //下半按钮部分
      Column() {
        Divider()
          .strokeWidth(1)
          .color('#ffb1afaf')
          .margin({ top: 0, bottom: 7 })
        Row() {

          Text('总计：*元')
            .fontColor('#8A96A2')
            .fontSize(16)
            .margin({ right: 10 })

          Button({type: ButtonType.Normal}){
            Text('重新上报 ')
              .fontSize(16)
              .fontColor(Color.White)
          }
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
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}