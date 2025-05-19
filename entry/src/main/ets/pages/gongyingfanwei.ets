import { router } from '@kit.ArkUI'

@Entry
@Component
struct TabBar {
  build() {
    Column() {
      Row() {
        Text('✕')
          .fontSize(15)
          .margin({ left: 16 })
          .fontColor('#45706e6e')
          .onClick(() => {
            router.back()
          })
        Column() {
          Text('供应范围')
            .fontSize(15)
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
        left: 8,
        right: 8
      })

      Column() {
        Row() {
          Text('1.实训第二学校')
            .fontSize(25)
        }
        .width('100%')
        Row() {
          Text('库       管：')
            .fontSize(20)
          Text('无')
            .fontSize(20)
        }
        .width('100%')
        Row() {
          Text('联系方式：')
            .fontSize(20)
          Text('无')
            .fontSize(20)
        }
        .width('100%')
      }
      .backgroundColor('#fff')
      .margin({ bottom:10})
      Column() {
        Row() {
          Text('1.实训第二学校')
            .fontSize(25)
        }
        .width('100%')
        Row() {
          Text('库       管：')
            .fontSize(20)
          Text('无')
            .fontSize(20)
        }
        .width('100%')
        Row() {
          Text('联系方式：')
            .fontSize(20)
          Text('无')
            .fontSize(20)
        }
        .width('100%')
      }
      .backgroundColor('#fff')
    }
    .backgroundColor('#fff3f2f2')
    .width('100%')
    .height('100%')
  }
}