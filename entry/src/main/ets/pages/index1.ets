// DatePickerExample.ets
@Entry
@Component
struct DatePickerExample {
  private selectedText =['请选择','请选择','请选择','请选择','请选择','请选择',]
  private unitOptions = [
    '选择需求单位',
    '实验第二学校（库房）',
    '实验第二学校餐厅'
  ]
  build() {
    Column() {
      Column({ space: 10 }){
        Row() {
          Image($r("app.media.unitName"))
            .width(30)
            .height(30)
            .objectFit(ImageFit.Contain)

          Text("需求单位")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })

          Text("*")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
            .fontColor(Color.Red)
          Row()
            .layoutWeight(1)//占据中间空白
          Row() {
            Text(this.selectedText[0])
              .fontSize(14)
              .fontColor('#ff757272')

            Image($r("app.media.right_icon"))//箭头
              .width(12)
              .height(12)
              .margin({ left: 5 })
              .colorFilter('#ff0000')
              .backgroundColor(Color.Red)
          }
          .justifyContent(FlexAlign.End) // 右对齐
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)


        Row(){
          Image($r("app.media.supplyDate"))
            .width(30)
            .height(30)
            .objectFit(ImageFit.Contain)
          Text("供应日期")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
          Text("*")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
            .fontColor(Color.Red)
          Row()
            .layoutWeight(1)//占据中间空白
          Row() {
            Text(this.selectedText[1])
              .fontSize(14)
              .fontColor('#ff757272')

            Image($r("app.media.right_icon"))//箭头
              .width(12)
              .height(12)
              .margin({ left: 5 })
              .colorFilter('#ff0000')
              .backgroundColor(Color.Red)
          }
          .justifyContent(FlexAlign.End) // 右对齐
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row(){
          Image($r("app.media.supplyTime"))
            .width(30)
            .height(30)
            .objectFit(ImageFit.Contain)
          Text("供应时间")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
          Row()
            .layoutWeight(1)//占据中间空白
          Row() {
            Text(this.selectedText[2])
              .fontSize(14)
              .fontColor('#ff757272')

            Image($r("app.media.right_icon"))//箭头
              .width(12)
              .height(12)
              .margin({ left: 5 })
              .colorFilter('#ff0000')
              .backgroundColor(Color.Red)
          }
          .justifyContent(FlexAlign.End) // 右对齐
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row(){
          Image($r("app.media.demand"))
            .width(30)
            .height(30)
            .objectFit(ImageFit.Contain)
          Text("需求类型")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
          Text("*")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
            .fontColor(Color.Red)
          Row()
            .layoutWeight(1)//占据中间空白
          Row() {
            Text(this.selectedText[3])
              .fontSize(14)
              .fontColor('#ff757272')

            Image($r("app.media.right_icon"))//箭头
              .width(12)
              .height(12)
              .margin({ left: 5 })
              .colorFilter('#ff0000')
              .backgroundColor(Color.Red)
          }
          .justifyContent(FlexAlign.End) // 右对齐
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row(){
          Image($r("app.media.mealCategory"))
            .width(30)
            .height(30)
            .objectFit(ImageFit.Contain)
          Text("餐别")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
          Text("*")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
            .fontColor(Color.Red)
          Row()
            .layoutWeight(1)//占据中间空白
          Row() {
            Text(this.selectedText[4])
              .fontSize(14)
              .fontColor('#ff757272')

            Image($r("app.media.right_icon"))//箭头
              .width(12)
              .height(12)
              .margin({ left: 5 })
              .colorFilter('#ff0000')
              .backgroundColor(Color.Red)
          }
          .justifyContent(FlexAlign.End) // 右对齐
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row(){
          Image($r("app.media.remarks"))
            .width(30)
            .height(30)
            .objectFit(ImageFit.Contain)
          Text("摘要")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
          Row()
            .layoutWeight(1)//占据中间空白
          Row() {
            Text(this.selectedText[5])
              .fontSize(14)
              .fontColor('#ff757272')

            Image($r("app.media.right_icon"))//箭头
              .width(12)
              .height(12)
              .margin({ left: 5 })
              .colorFilter('#ff0000')
              .backgroundColor(Color.Red)
          }
          .justifyContent(FlexAlign.End) // 右对齐
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
    }
    .width('100%')
  }
}