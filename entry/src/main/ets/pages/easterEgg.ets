import { window } from '@kit.ArkUI'

@Entry
@Component
struct easterEgg {
  @State yOffset: number = 2000  // 初始位置更靠下
  @State opacityValue: number = 0
  private animTimer?: number = undefined

  onPageShow(): void {
    window.getLastWindow(AppStorage.get(''), (err, data) => {
      if (!err.code) {
        data.setFullScreen(true)
      }
    })
  }

  aboutToAppear() {
    this.startAnimation()
  }

  aboutToDisappear() {
    // 清理动画资源
    if (this.animTimer) {
      clearTimeout(this.animTimer)
    }
  }

  startAnimation() {
    this.animTimer = setTimeout(() => {
      this.opacityValue = 1
      // 使用显式动画控制循环
      animateTo({
        duration: 20000,  // 根据内容长度调整时长
        curve: Curve.Linear,
        iterations: -1,
        onFinish: () => {
          this.yOffset = 0  // 重置初始位置
        }
      }, () => {
        this.yOffset = -2500  // 终点值=容器高度+可视区域
      })
    }, 100)
  }

  build() {
    Stack() {
      // 星空背景
      Image($r("app.media.stars"))
        .width('100%')
        .height('100%')
        .zIndex(0)

      // 优化渐隐遮罩层
      Column()
        .width('100%')
        .height('5%')  // 增加遮罩区域高度
        .linearGradient({
          angle: 180,
          colors: [
            [0x00000000, 0.0],   // 完全透明
            [0xFF000000, 0.5]   // 不透明度95%
          ]
        })
        .position({ y: 0 })
        .zIndex(2)

      // 滚动字幕容器
      Column() {
        Text(`我是牢俊\n\n策划：我是牢俊\n开发：我是牢俊\n设计：我是牢俊\n测试：我是牢俊\n\n特别感谢\我是牢俊\n 我是牢俊\n\n策划：我是牢俊\n开发：我是牢俊\n设计：我是牢俊\n测试：我是牢俊\n\n特别感谢\我是牢俊\n 我是牢俊\n\n策划：我是牢俊\n开发：我是牢俊\n设计：我是牢俊\n测试：我是牢俊\n\n特别感谢\我是牢俊\n`)
          .fontSize(36)  // 微调字号
          .fontColor('#ffffab00')
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .lineHeight(65)  // 优化行高
      }
      .width('100%')
      .height(3200)  // 增加容器高度
      .margin({ top: '10%' })  // 从屏幕外开始滚动
      .position({ y: this.yOffset })
      .rotate({ x: 1, y: 0, z: 0, angle: 55 })  // 微调旋转角度
      .scale({ x: 0.78, y: 0.78 })  // 优化透视比例
      .opacity(this.opacityValue)
      .zIndex(1)
      .clip(true)
    }
    .width('100%')
    .height('100%')
  }
}
