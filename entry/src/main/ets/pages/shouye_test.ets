import router from '@ohos.router';
import http from '@ohos.net.http';
import { promptAction, Router } from '@kit.ArkUI';
import { PrintExtensionAbility } from '@kit.BasicServicesKit';
import { AppKeys } from '../common/Constants';

interface RouteParams {
  token?: string;
  relTenantIds?: number;
}

interface ImageCount {
  url: string
  count: number
  text: string
  route: string
}

interface cuku {
  url1: string
  count1: number
  text1: string
  route1: string
}

interface pingfen {
  pinfen: number
  baifenbi: number
  fenxian: string
}

interface TabData {
  pinfen: number,
  baifenbi: number,
  fenxian: string
}

interface LogoutResponse {
  success: boolean;
  message: string;
  code: number;
  result: string;
  timestamp: number;
}

interface GeneratedObjectLiteralInterface_1 {
  'Content-Type': string;
  'Tenant-Id': string;
  'X-Access-Token': string;
  'Accept': string;
}

@Entry
@Component
struct Index1 {
  @State image: ImageCount[] = [
    { url: 'app.media.education_3', count: 0, text: '每日工作', route: 'pages/kitchenStaff' },
    { url: 'app.media.home_1', count: 0, text: '上报计划', route: 'pages/uploadPlan' },
    { url: 'app.media.home_2', count: 0, text: '需求审批', route: 'pages/ApprovalPage' },
    { url: 'app.media.home_4', count: 0, text: '新品审批', route: 'pages/addStaff_test' },
    { url: 'app.media.home_recipe_reporting', count: 0, text: '今日菜品', route: 'pages/food_day' },
    { url: 'app.media.education_6', count: 0, text: '后厨人员', route: 'pages/kitchenStaff' },
    { url: 'app.media.education_4', count: 0, text: '每日留样', route: 'pages/remain_day' },
    { url: 'app.media.home_9', count: 0, text: '晨检记录', route: 'pages/chenjianjilu' },
    { url: 'app.media.home_3', count: 0, text: '陪餐记录', route: 'pages/peicanRecords' },
    { url: 'app.media.home_13', count: 0, text: '陪餐评价', route: 'pages/addStaff' },
  ];
  @State image1: cuku[] = [
    { url1: 'app.media.home_6', count1: 0, text1: '供应出库', route1: 'pages/kucun' },
    { url1: 'app.media.home_12', count1: 0, text1: '实时库存', route1: 'pages/shishikucun' },
  ]

  @StorageLink(AppKeys.TOKEN) storageToken: string = '';
  @StorageLink(AppKeys.TENANT_ID) storageTenantId: number = 0;
  @State selectedTab: number = 0
  private tabs: Array<string> = ['今日', '本周', '本月', '本年']

  @State tabData: TabData[] = [
    { pinfen: 0, baifenbi: 0, fenxian: '安全' },    // 今日
    { pinfen: 2, baifenbi: 30, fenxian: '低风险' },  // 本周
    { pinfen: 8, baifenbi: 70, fenxian: '中风' },   // 本月
    { pinfen: 9, baifenbi: 95, fenxian: '高风险' }   // 本年
  ]

  @State receivedToken: string = '';
  @State tenantId: number = 0;

  onPageShow() {
    this.receivedToken = this.storageToken;
    this.tenantId = this.storageTenantId;
  }

  // 退出登录方法
  private async handleLogout() {
    try {
      const httpRequest = http.createHttp();

      // 准备请求头
      const headers: GeneratedObjectLiteralInterface_1 = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Tenant-Id': this.storageTenantId?.toString() || '100001',
        'X-Access-Token': this.storageToken || '',
        'Accept': 'application/json, text/plain, */*'
      };

      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-system/sys/logout',
        {
          method: http.RequestMethod.POST,
          header: headers,
          connectTimeout: 60000,
          readTimeout: 60000
        }
      );

      const jsonData = JSON.parse(response.result as string) as LogoutResponse;

      if (jsonData.success) {
        // 清除本地存储的token和租户ID
        AppStorage.delete(AppKeys.TOKEN);
        AppStorage.delete(AppKeys.TENANT_ID);

        // 显示退出成功提示
        promptAction.showToast({
          message: '退出登录成功',
          duration: 2000,
          bottom: 670
        });

        // 跳转到登录页面
        router.pushUrl({ url: 'pages/login_test' });
      } else {
        promptAction.showToast({
          message: jsonData.message || '退出登录失败',
          duration: 2000,
          bottom: 670
        });
      }
    } catch (error) {
      console.error('退出登录错误:', error);
      promptAction.showToast({
        message: '退出登录失败，请稍后重试',
        duration: 2000,
        bottom: 670
      });
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
                              relTenantIds:this.tenantId,
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
              router.pushUrl({ url: 'pages/gerenxinxi' });
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
              router.pushUrl({ url: 'pages/mima' });
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
              router.pushUrl({ url: 'pages/wentijieda' });
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
              AlertDialog.show({
                title: '提示',
                message: '确定要退出登录吗？',
                primaryButton: {
                  value: '取消',
                  action: () => {
                    console.info('取消退出登录');
                  }
                },
                secondaryButton: {
                  value: '确定',
                  action: () => {
                    this.handleLogout();
                  }
                }
              });
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