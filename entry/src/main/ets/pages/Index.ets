/*
interface ImageCount {
  url: string
  count: number
}

@Entry
@Component
struct Index {
  @State image: ImageCount[] = [
    { url: 'app.media.education_3', count: 0 },
    { url: 'app.media.home_1', count: 1 },
    { url: 'app.media.home_2', count: 2 },
    { url: 'app.media.home_4', count: 3 },
    { url: 'app.media.home_recipe_reporting', count: 4 },
    { url: 'app.media.education_6', count: 5 }
  ]

  build() {
    Tabs() {
      // 首页 Tab
      TabContent() {
        Column() {
          // 轮播图 Swiper
          Swiper() {
            Image($r('app.media.banner1'))
            Image($r('app.media.banner2'))
            Image($r('app.media.banner3'))
          }
          .width('100%')
          .height(180)
          .padding({ bottom: 20, left: 10, right: 10 })
          .borderRadius(20)

          // 公告背景条
          Text()
            .width('100%')
            .height(40)
            .backgroundColor('#ebf6f3f3')
            .padding({ left: 10, right: 10 })

          // 公告文字
         Image($r('app.media.notice'))
            .width(60)
            .height(30)
            .borderRadius({ bottomRight: 40 })
            .backgroundColor('#a3ee9510')
            .position({ x: 20, y: -40 }) // 相对定位在背景条内

          // 需求计划标题
          Text('需求计划')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20, left: 20 })

          // 图标网格
          Grid() {
            ForEach(this.image, (item: ImageCount, index: number) => {
              GridItem() {
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
                    .width(80)
                    .onClick(() => {
                      console.info(`Clicked on icon: ${item.url}`)
                      // 可在此处添加跳转逻辑
                    })
                }
              }
            })
          }
          .columnsTemplate('1fr 1fr 1fr 1fr')
          .width('100%')
          .height(300)
          .margin({ top: 10 })
        }
        .width('100%')
      }
      .tabBar('首页')

      // 我的 Tab
      TabContent() {
        Column() {
          Text('个人中心')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })

          Divider()
            .strokeWidth(1)
            .color('#e0e0e0')

          List() {
            ListItem() {
              Row() {
               */
/* Image($r('app.media.user_icon'))
                  .width(40)
                  .height(40)
                Text('个人信息')
                  .fontSize(18)
                  .marginLeft(10)*//*

              }
            }

            ListItem() {
              Row() {
               */
/* Image($r('app.media.setting'))
                  .width(40)
                  .height(40)
                Text('设置')
                  .fontSize(18)
                  .marginLeft(10)*//*

              }
            }
          }
          .width('100%')
          .layoutWeight(1)
        }
        .width('100%')
      }
      .tabBar('我的')
    }
    .barPosition(BarPosition.End) // 设置 tab bar 在底部
  }
}
*/
