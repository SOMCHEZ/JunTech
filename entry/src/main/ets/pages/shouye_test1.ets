//这里是接口参数传递以及，路由界面
import router from '@ohos.router';
import http from '@ohos.net.http';
import { promptAction, Router } from '@kit.ArkUI';
import { PrintExtensionAbility } from '@kit.BasicServicesKit';
import { AppKeys } from '../common/Constants';

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
    { url: 'app.media.education_1', count: 0, text: '待接单' ,route:'pages/kitchenStaff'},
    { url: 'app.media.education_2', count: 0, text: '配送单' ,route:'pages/peisongdan'},
    { url: 'app.media.education_3', count: 0, text: '送货单' ,route:'pages/songhuodan'},
  ];

  // 直接通过 AppStorage 获取
  @StorageLink(AppKeys.TOKEN) storageToken: string = '';
  @StorageLink(AppKeys.TENANT_ID) storageTenantId: number = 0;
  @State selectedTab: number = 0

  @State realname: string = '';
  @State telephone: string = '';
  @State organizationName: string = '';

  @State gonggao: string[] = []//公告内容

  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上


  aboutToAppear() {
    // 获取参数
    let params = router.getParams() as Record<string, string>
    this.realname  = params.realname || ''
    this.telephone  = params.telephone || ''
    this.organizationName  = params.organizationName || ''
  }

  onPageShow() {//这是一个接收传递参数的方法
    // 使用接口类型断言
    // const params = router.getParams() as RouteParams;
    // console.log('shouye', params?.token);// 打印接收到的参数
    // console.log('shouye', params?.relTenantIds);//  打印接收到的参数
    //
    // // 安全取值
    // if (params?.token) {
    //   this.receivedToken = params.token;
    // }
    //
    // if (params?.relTenantIds) {
    //   this.tenantId = params.relTenantIds;
    // }
    // console.log('shouye', this.storageToken);
    // console.log('shouye', this.storageTenantId.toString());
    this.receivedToken  = this.storageToken;
    this.tenantId = this.storageTenantId;
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
              Text(this.gonggao+'')
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
                  relTenantIds:this.tenantId,
                }
              })
            })
            .padding({top:10})
            .width('100%')
            .height(60)
            .padding({
              left: 10,
            })

            Text('订单管理')
              .fontSize(20)
              .width('100%')
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .margin({ top: 20, left: 10,bottom: 10 })

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
                              relTenantIds:this.tenantId,
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
          }
          .width('100%')
          .height('100%')
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
              .width(60)
              .height(60)
              .layoutWeight(1)
              .borderRadius(25);
            Column() {
              Text('彦红粮油有限公司')
                .width('100%')
                .margin({ left: 20})
                .fontSize(20);
              Text('彦红粮油有限公司18991274264')
                .width('100%')
                .margin({ left: 20})
                .fontSize(14);
            }
            .layoutWeight(4);
          }
          .padding({ top: 20, left: 20, right: 20 });

          Row(){
            Column(){
              Image($r('app.media.information1'))
                .width(40)
                .padding({bottom:5})
              Text('基本信息')
            }
            .onClick(() => {
              router.pushUrl({          // 使用push入栈一个新页面
                url: 'pages/jibenxinxi' // 通过url指定新打开的页面
              })
            })
            .padding({ left: 20, right: 20, top:10})
            Column(){
              Image($r('app.media.information2'))
                .width(40)
                .padding({bottom:5})
              Text('供应范围')
            }
            .onClick(() => {
              router.pushUrl({          // 使用push入栈一个新页面
                url: 'pages/gongyingfanwei' // 通过url指定新打开的页面
              })
            })
            .padding({ left: 20, right: 20,top:10 })
            Column(){
              Image($r('app.media.information3'))
                .width(40)
                .padding({bottom:5})
              Text('供应商品')
            }
            .padding({ left: 20, right: 20 ,top:10})
          }
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
                url: 'pages/gerenxinxi', // 通过url指定新打开的页面
                params:{
                  token:this.receivedToken,
                  relTenantIds:this.tenantId,
                  realname:this.realname,
                  telephone:this.telephone,
                  organizationName:this.organizationName
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
              router.pushUrl({          // 使用push入栈一个新页面
                url: 'pages/login'     // 通过url指定新打开的页面
              ,
                params:{
                  token:this.receivedToken,
                  relTenantIds:this.tenantId

                }
              })
            })
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