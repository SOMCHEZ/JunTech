//这里是接口参数传递以及，路由界面
import router from '@ohos.router';
import http from '@ohos.net.http';
import { promptAction, Router } from '@kit.ArkUI';
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
interface pingfen{
   pinfen:number
   baifenbi:number
   fenxian:string
}

interface TabData  {
  pinfen: number,
  baifenbi: number,
  fenxian: string
}

@Entry
@Component
struct Index1 {
  @State image: ImageCount[] = [
    { url: 'app.media.education_3', count: 0, text: '每日工作' ,route:'pages/kitchenStaff_test'},
    { url: 'app.media.home_1', count: 0, text: '上报计划' ,route:'pages/addPlan'},
    { url: 'app.media.home_2', count: 0, text: '需求审批' ,route:'pages/ApprovalPage'},
    { url: 'app.media.home_4', count: 0, text: '新品审批' ,route:'pages/addStaff_test'},
    { url: 'app.media.home_recipe_reporting', count: 0, text: '今日菜品' ,route:'pages/food_day'},
    { url: 'app.media.education_6', count: 0, text: '后厨人员',route:'pages/kitchenStaff_test' },
    { url: 'app.media.education_4', count: 0, text: '每日留样' ,route:'pages/remain_day'},
    { url: 'app.media.home_9', count: 0, text: '晨检记录' ,route:'pages/chenjianjilu'},
    { url: 'app.media.home_3', count: 0, text: '陪餐记录' ,route:'pages/peicanRecords'},
    { url: 'app.media.home_13', count: 0, text: '陪餐评价' ,route:'pages/addStaff_test'},
  ];
  @State image1:cuku[]=[
    {url1:'app.media.home_6',count1:0,text1:'供应出库',route1:'pages/kucun' },
    {url1:'app.media.home_12',count1:0,text1:'实时库存',route1:'pages/shishikucun'},
  ]


  @State selectedTab: number = 0
  private tabs: Array<string> = ['今日', '本周', '本月', '本年']

  // 每个tab对应的数据
  @State tabData:TabData[]= [
    { pinfen: 0, baifenbi: 0, fenxian: '安全' },    // 今日
    { pinfen: 2, baifenbi: 30, fenxian: '低风险' },  // 本周
    { pinfen: 8, baifenbi: 70, fenxian: '中风' },  // 本月
    { pinfen: 9, baifenbi: 95, fenxian: '高风险' }     // 本年
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
            .autoPlay(true)     // 开启自动轮播
            .interval(3000)     // 轮播间隔时间为3秒
            .loop(true)
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
              Text('')
                .height(40)
                .layoutWeight(4.5)
                .animation({duration: 3000})
                .textAlign(TextAlign.Center)
            }
            .onClick(() => {
              router.push({          // 使用push入栈一个新页面
                url: 'pages/gonggao' // 通过url指定新打开的页面
              ,
                params:{
                  token:this.receivedToken,
                  relTenantIds:this.tenantId

                }
              })
            })
            .padding({top:10})
            .width('100%')
            .height(60)
            .padding({
              left: 10,
            })
            Column() {
              // 顶部Tab
              Row() {
                ForEach(this.tabs, (tab: string, idx: number) => {
                  Text(tab)
                    .fontColor(this.selectedTab === idx ? 0x00B050 : 0x222222)
                    .fontWeight(FontWeight.Bold)
                    .backgroundColor(this.selectedTab === idx ? 0xF0FFF0 : 0xFFFFFF)
                    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                    .onClick(() => {
                      this.selectedTab = idx
                    })
                })
              }
              .width('100%')
              .margin({ bottom: 16 })

              // 评分与描述
              Row() {
                Column() {
                  Row() {
                    Text(this.tabs[this.selectedTab] +'本校当前综合评分')
                      .fontSize(16)
                      .fontColor(0x222222)
                      .margin({ bottom: 8 })
                    Text(this.tabData[this.selectedTab].fenxian)
                      .fontSize(16)
                      .fontColor(0xFF0000)
                      .margin({ left: 100, bottom: 8 })
                  }
                  .width('100%')

                  Row() {
                    Text(this.tabData[this.selectedTab].pinfen.toString())
                      .fontSize(48)
                      .fontColor(0xFF0000)
                      .fontWeight(FontWeight.Bold)
                    Text('分')
                      .fontSize(18)
                      .fontColor(0x222222)
                      .margin({ left: 4, top: 24 })
                    Text('超过本地区')
                      .fontSize(16)
                      .margin({ left: 100, top: 24 })
                      .fontColor(0x222222)
                    Text(this.tabData[this.selectedTab].baifenbi + '%')
                      .fontSize(18)
                      .fontColor(0xFF9900)
                      .fontWeight(FontWeight.Bold)
                      .margin({ left: 2, right: 2, top: 24 })
                    Text('的学校')
                      .fontSize(16)
                      .margin({ top: 24 })
                      .fontColor(0x222222)
                  }
                  .width('100%')
                }
                .align(Alignment.Start)
              }
              .align(Alignment.End)
              .margin({ left: 15 })
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .padding(10)
            .backgroundColor(0xFFFFFF)
            .borderRadius(12)

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
          // 头部信息
          Row() {
            Image($r('app.media.avatar'))
              .width(100)
              .height(100)
              .layoutWeight(1)
              .borderRadius(50);
            Column() {
              Text('实训第二学校')
                .fontSize(20);
              Text('人15502933673')
                .fontSize(16);
            }
            .layoutWeight(2);
          }
          .padding({ top: 20, left: 20, right: 20 });

          // 功能列表
          List() {
            // 修改个人信息
            ListItem() {
              Row() {
                Text('修改个人信息')
                  .fontColor('#60000000')
                  .layoutWeight(5);
                Image($r('app.media.right_icon'))
                  .height(17)
                  .layoutWeight(1);
              }
              .width('100%')
              .height(50)
              .padding({ top: 20 });
            }
            .onClick(() => {
              router.pushUrl({          // 使用push入栈一个新页面
                url: 'pages/gerenxinxi' // 通过url指定新打开的页面
              ,
                params:{
                  token:this.receivedToken,
                  relTenantIds:this.tenantId

                }
              })
            })

            // 修改密码
            ListItem() {
              Row() {
                Text('修改密码')
                  .fontColor('#60000000')
                  .layoutWeight(5);
                Image($r('app.media.right_icon'))
                  .height(17)
                  .layoutWeight(1);
              }
              .width('100%')
              .height(50)
              .padding({ top: 20 });
            }
            .onClick(() => {
              router.pushUrl({          // 使用push入栈一个新页面
                url: 'pages/mima' // 通过url指定新打开的页面
              ,
                params:{
                  token:this.receivedToken,
                  relTenantIds:this.tenantId

                }
              })
            })

            // 常见问题解答
            ListItem() {
              Row() {
                Text('常见问题解答')
                  .fontColor('#60000000')
                  .layoutWeight(5);
                Image($r('app.media.right_icon'))
                  .height(17)
                  .layoutWeight(1);
              }
              .width('100%')
              .height(50)
              .padding({ top: 20 });
            }
            .onClick(() => {
              router.pushUrl({          // 使用push入栈一个新页面
                url: 'pages/wentijieda' // 通过url指定新打开的页面
              ,
                params:{
                  token:this.receivedToken,
                  relTenantIds:this.tenantId

                }
              })
            })

            // 退出登录
            ListItem() {
              Row() {
                Text('退出登录')
                  .fontColor('#60000000')
                  .layoutWeight(5);
                Image($r('app.media.right_icon'))
                  .height(17)
                  .layoutWeight(1);
              }
              .width('100%')
              .height(50)
              .padding({ top: 20 });
            }
            .onClick(() => {
              console.info('Clicked on 退出登录');
            });
          }
          .margin({ top: 20 })
          .width('100%')
          .backgroundColor('#fff')
          .borderRadius(10);
        }
        .width('100%')
        .height('100%')
        .padding({
          left: 20,
          right: 20,
          bottom: 20
        })
        .justifyContent(FlexAlign.Start);
      }
      .tabBar('我的')
    }
    .barPosition(BarPosition.End)
  }
}