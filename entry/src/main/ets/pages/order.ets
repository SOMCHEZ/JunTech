import router from '@ohos.router';
import http from '@ohos.net.http';
import { ComposeListItem } from '@ohos.arkui.advanced.ComposeListItem';

//这里是接口数据类型的声明


@Entry
@Component
struct d {
  @State isSelected: boolean = false
  @State isBothClicked: boolean = false
  @State showToast: boolean = false
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
        Text('实训第二学校')
          .fontSize(25)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })
          .padding({ left: -150 })
        Row(){
          Text('单据号:')
            .width('20%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
          Text('XQ20250509005')
            .width('50%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
        }
        Row() {
          Text('供应时间：')
            .width('20%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
          Text('2025-05-19 上午')
            .width('50%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
        }
        Row() {
          Text('需求单位：')
            .width('20%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
          Text('实训第二学校餐厅')
            .width('50%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
        }
        Text('下单人')
          .width('20%')
          .fontSize(12)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
        Text('下单电话:')
          .width('20%')
          .fontSize(12)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
        Row() {
          Text('摘       要：')
            .width('20%')
            .fontSize(12)
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
          Text('123')
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
      if (this.adddal) {
        Column() {
          Stack() {
            // 主内容区域
            Column() {
              Row({ space: 10 }) {
                Image($r('app.media.food'))
                  .width(70)
                  .borderRadius(0)
                  .margin({ left: 5, top: -115 })
                Text('鸡腿')
                  .fontSize(25)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.Black)
                  .margin({ left: 10, top: -70 }) // 右侧固定位置
              }
              .width('100%')
              .height(80)
              .padding({ left: 20 })
            }
            // 渐变分割线
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
                Text('单位：')
                  .fontWeight(600)
                Text('Kg')
                  .fontWeight(600)
                  .fontColor(Color.Black)
                  .margin({ right: 30 })
                Text('品牌：')
                  .fontWeight(600)
                Text('博大')
                  .fontWeight(600)
                  .fontColor(Color.Black)
              }
              .margin({ top: 10 })
              .zIndex(2)
              Row() {
                Text('当时供应价：')
                  .fontWeight(600)
                Text('14.56')
                  .fontSize(19)
                  .fontWeight(800)
                  .fontColor(Color.Red)
                Text('元/Kg')
                  .fontWeight(600)
                  .fontColor(Color.Red)
              }
              .margin({ top: 10 })
              Row() {
                Text('计划数量：')
                  .fontWeight(600)
                Text('100')
                  .fontSize(18)
                  .fontWeight(800)
                Text('kg')
                  .fontWeight(600)
                  .margin({ right: 40 })
                Text('合计：')
                  .fontWeight(600)
                Text('1456元')
                  .fontWeight(600)
                  .fontColor(Color.Red)
                  .fontWeight(800)
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
            .margin({ top: 100})
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
          }
          .width('100%')
          .height(220)
        }
        .borderWidth(2)
        .borderColor(Color.Orange)
        .width('96%')
        .height(260)
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
        Column() {
          Row(){
            Text('总计:')
              .fontColor(Color.Black)
              .fontSize(19)
              .fontWeight(800)
              .margin({ right: 10 })
            Text('1456元')
              .fontColor(Color.Red)
              .fontSize(22)
              .fontWeight(800)
          }.margin({ right:210,top:-15})
          Text('共1种')
            .fontSize(19)
            .fontWeight(800)

        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
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