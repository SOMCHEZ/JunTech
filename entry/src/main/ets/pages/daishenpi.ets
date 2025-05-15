// Index.ets
@Entry
@Component
struct HelloPage {
  build() {
    Column() {
      Text('你好，鸿蒙！')
        .fontSize(40)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .fontColor(Color.Black)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(Color.White)
  }
}