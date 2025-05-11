//这里是接口参数传递以及，路由界面
import router from '@ohos.router';
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';
import { PrintExtensionAbility } from '@kit.BasicServicesKit';

interface RouteParams {
  token?: string;
  relTenantIds?: number;
}


interface ImageCount{
  url:string
  count:number
  text:string
  route:string
}
interface cuku{
  url1:string
  count1:number
  text1:string
  route1:string
}
@Entry
@Component
struct Index1 {
  @State image: ImageCount[] = [
    { url: 'app.media.education_3', count: 0, text: '每日工作' ,route:'pages/kitchenStaff_test'},
    { url: 'app.media.home_1', count: 0, text: '上报计划' ,route:'pages/addStaff_test'},
    { url: 'app.media.home_2', count: 0, text: '需求审批' ,route:'pages/addStaff_test'},
    { url: 'app.media.home_4', count: 0, text: '新品审批' ,route:'pages/addStaff_test'},
    { url: 'app.media.home_recipe_reporting', count: 0, text: '今日菜品' ,route:'pages/addStaff_test'},
    { url: 'app.media.education_6', count: 0, text: '后厨人员',route:'pages/kitchenStaff_test' },
    { url: 'app.media.education_4', count: 0, text: '每日留样' ,route:'pages/addStaff_test'},
    { url: 'app.media.home_9', count: 0, text: '晨检记录' ,route:'pages/addStaff_test'},
    { url: 'app.media.home_3', count: 0, text: '陪餐记录' ,route:'pages/sad'},
    { url: 'app.media.home_13', count: 0, text: '陪餐评价' ,route:'pages/addStaff_test'},
  ];
  @State image1:cuku[]=[
    {url1:'app.media.home_6',count1:0,text1:'供应出库',route1:'pages/kucun' },
    {url1:'app.media.home_12',count1:0,text1:'实时库存',route1:'pages/addStaff_test'},
  ]




  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上

  onPageShow() {//这是一个接收传递参数的方法
    // 使用接口类型断言
    const params = router.getParams() as RouteParams;
    console.log('shouye', params?.token);// 打印接收到的参数
    console.log('shouye', params?.relTenantIds);//  打印接收到的参数

    // 安全取值
    if (params?.token) {
      this.receivedToken = params.token;
    }

    if (params?.relTenantIds) {
      this.tenantId = params.relTenantIds;
    }
  }


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
                          router.pushUrl({          // 使用push入栈一个新页面
                            url: item.route // 通过url指定新打开的页面
                          ,
                            params:{
                              token:this.receivedToken,
                              relTenantIds:this.tenantId

                            }
                          })
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
                          router.pushUrl({          // 使用push入栈一个新页面
                            url: item1.route1 // 通过url指定新打开的页面
                          ,
                            params:{
                              token:this.receivedToken,
                              relTenantIds:this.tenantId

                            }
                          })
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
        Column() {
          Row(){
            Image($r('app.media.avatar'))
              .width(100)
              .height(100)
              .layoutWeight(1)
              .borderRadius(50)
            Column(){
              Text('实训第二学校')
                .fontSize(20)

              Text('人15502933673')
            }
            .layoutWeight(2.4)
          }
        }
        .width('100%')
        .height('100%')
        .padding({
          left: 20,
        })
        .justifyContent(FlexAlign.Start)
      }
      .tabBar('我的')
    }
    .barPosition(BarPosition.End)
  }
}