import { router } from '@kit.ArkUI'

@Entry
@Component
struct GongGao {
  build() {
    Column() {
      Row() {
        Text('✕')
          .fontSize(24)
          .margin({ left: 16 })
          .fontColor('#45706e6e')
          .onClick(() => {
            router.back()
          })
        Column() {
          Text('公告')
            .fontSize(30)
            .margin({ right: 100 })
        }
        .margin({ left: 16 })
        .width('100%')

        Blank()
      }
      .width('100%')
      .height(48)
      .alignItems(VerticalAlign.Center)
      .margin({
        top: 8,
        bottom: 8,
        left: 8,
        right: 8
      })
      Scroll(){
        Column() {
          Text('- 暂无相关数据 -')
            .fontColor('#45706e6e')
        }
        .height('100%')
      }
    }
  }
}