import { window } from '@kit.ArkUI'

@Entry
@Component
struct easterEgg {
  @State yOffset: number = 800
  @State opacityValue: number = 0
  private animTimer?: number = undefined

  onPageShow(): void {
    this.startAnimation()
    window.getLastWindow(AppStorage.get(''), (err, data) => {
      if (!err.code) {
        data.setFullScreen(true)
      }
    })
  }

  aboutToDisappear() {
    if (this.animTimer) {
      clearTimeout(this.animTimer)
    }
  }

  startAnimation() {
    this.opacityValue = 1
    animateTo({
      duration: 50000,  // 缩短动画时长
      curve: Curve.EaseOut,  // 使用缓出曲线
      iterations: -1,
      delay: 0,  // 明确无延迟
      onFinish: () => {
        this.yOffset = -1000
      }
    }, () => {
      this.yOffset = -2500
    })
  }

  build() {
    Stack() {
      Image($r("app.media.stars"))
        .width('100%')
        .height('100%')
        .zIndex(0)

      Column()
        .width('100%')
        .height('5%')
        .linearGradient({
          angle: 180,
          colors: [
            [0x00000000, 0.0],
            [0xFF000000, 0.5]
          ]
        })
        .position({ y: 0 })
        .zIndex(2)

      Column() {
        Text(`制作人名单\n 技术总监：牢俊\n 项目经理：魏辉\n 产品经理：陈凯\n 成员：周鑫津\n 成员：肖烨钒\n 成员：李贵烨\n 成员：拓喜喜\n 成员：卢岚驰\n 成员：牛东升\n`)
          .fontSize(36)
          .fontColor('#ffffab00')
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .lineHeight(65)
      }
      .width('100%')
      .height('100%')
      .margin({ top: '10%' })
      .position({ y: this.yOffset })
      .rotate({ x: 1, y: 0, z: 0, angle: 45 })
      .scale({ x: 0.78, y: 0.78 })
      .opacity(this.opacityValue)
      .zIndex(1)
      .clip(true)
    }
    .width('100%')
    .height('100%')
  }
}
