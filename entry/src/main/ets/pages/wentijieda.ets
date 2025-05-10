import { router } from '@kit.ArkUI'

interface ewnti12{
  count:number
  text:string
  imag:string
}

@Entry
@Component
struct wenti {
  @State ewnti:ewnti12[]=[
    {count:1,text:'需求上报',imag:'app.media.home_1'},
    {count:2,text:'确认收货',imag:'app.media.home_1'}
  ]
  build() {
    Column() {
      List() {
        ForEach(this.ewnti, (item: ewnti12, index: number) => {
          ListItem() {
            Row() {
              Text(item.count+'.')
                .fontColor('#60000000')
                .padding({right:10,left:10})
              Text(item.text)
                .fontColor('#60000000')
                .layoutWeight(5)
                .onClick(() => {
                    // 点击跳转到详情页
                    router.pushUrl({ url: 'pages.QuestionDetailPage' })
                  });
              Image($r('app.media.right_icon'))
                .height(17)
                .layoutWeight(1);
            }
            .width('100%')
            .height(50)
            .padding({ top: 20 });
          }
        })
      }
    }
  }
}