import { window } from '@kit.ArkUI'

@Entry
@Component
struct easterEgg{
  myScroll: Scroller =  new Scroller()
  @State yOffset: number = 0
  onPageShow(): void {
    window.getLastWindow(AppStorage.get(''),(err,data) => {
      if (err.code) {
      }
      data.setFullScreen(true)
    })
  }
  build() {
    Column(){
      Image($r("app.media.easterEgg"))
        .width('100%')
    }
  }

}
