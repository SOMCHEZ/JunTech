interface ImageCount{
  url:string
  count:number
  text:string
}
interface cuku{
  url1:string
  count1:number
  text1:string
}
@Entry
@Component
struct Index1 {
  @State image: ImageCount[] = [
    { url: 'app.media.education_3', count: 0, text: '每日工作' },
    { url: 'app.media.home_1', count: 0, text: '上报计划' },
    { url: 'app.media.home_2', count: 0, text: '需求审批' },
    { url: 'app.media.home_4', count: 0, text: '新品审批' },
    { url: 'app.media.home_recipe_reporting', count: 0, text: '今日菜品' },
    { url: 'app.media.education_6', count: 0, text: '后厨人员' },
    { url: 'app.media.education_4', count: 0, text: '每日留样' },
    { url: 'app.media.home_9', count: 0, text: '晨检记录' },
    { url: 'app.media.home_3', count: 0, text: '陪餐记录' },
    { url: 'app.media.home_13', count: 0, text: '陪餐评价' },
  ];
  @State image1:cuku[]=[
    {url1:'app.media.home_6',count1:0,text1:'供应出库'},
    {url1:'app.media.home_12',count1:0,text1:'实时库存'},
  ]
  build() {
    Tabs() {
      TabContent() {
        Scroll() {
          Column() {
            Swiper() {
              Image($r('app.media.banner1'))
              Image($r('app.media.banner2'))
              Image($r('app.media.banner3'))
            }
            .aspectRatio(2.1)
            .borderRadius(10)
            .margin({
              left: 10,
              right: 10,
            })
            Row(){
              Image($r('app.media.notice'))
                .height(25)
                .layoutWeight(1)
              Text()
                .height(50)
                .layoutWeight(4.5)
                .animation({duration: 3000})
            }
            .width('100%')
            .height(60)
            .padding({
              left: 10,
            })

            Text('需求计划')
              .fontSize(20)
              .width('100%')
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .margin({ top: 10, left: 10 })

            Grid() {
              ForEach(this.image, (item: ImageCount, index: number) => {
                GridItem() {
                  Column() {
                    Badge({
                      count: item.count,
                      position: BadgePosition.RightTop,
                      style: {
                        fontSize: 14,
                        badgeSize: 20,
                        badgeColor: '#fa2a2d'
                      }
                    }) {
                      Image($r(item.url))
                        .width(50)
                        .height(50)
                        .onClick(() => {
                          console.info(`Clicked on icon: ${item.url}`)
                        })
                    }
                    Text(item.text)
                      .fontSize(14)
                      .margin({ top: 5 })
                  }
                  .width(90)
                  .height(100)
                }
              })
            }
            .columnsTemplate('1fr 1fr 1fr 1fr')
            .margin({ top: 10 })
            .width('100%')
            .height(300)

            Text('出入库')
              .fontSize(20)
              .width('100%')
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .margin({ top: 10, left: 10 })
            Grid() {
              ForEach(this.image1, (item1: cuku, index: number) => {
                GridItem() {
                  Column() {
                    Badge({
                      count: item1.count1,
                      position: BadgePosition.RightTop,
                      style: {
                        fontSize: 14,
                        badgeSize: 20,
                        badgeColor: '#fa2a2d'
                      }
                    }) {
                      Image($r(item1.url1))
                        .width(50)
                        .height(50)
                        .onClick(() => {
                          console.info(`Clicked on icon: ${item1.url1}`)
                        })
                    }
                    Text(item1.text1)
                      .fontSize(14)
                      .margin({ top: 5 })
                  }
                  .width(90)
                  .height(100)
                }
              })
            }
            .columnsTemplate('1fr 1fr 1fr 1fr')
            .margin({ top: 10 })
            .width('100%')
            .height(200)

          }
          .width('100%')
          .padding({ bottom: 20 })
        }
        .width('100%')
        .height('100%')
        .scrollable(ScrollDirection.Vertical)
        .edgeEffect(EdgeEffect.Fade)
      }
      .tabBar('首页')
      TabContent() {
        // 可以在这里添加其他 TabContent
      }
      .tabBar('我的')
    }
    .barPosition(BarPosition.End)
  }
}