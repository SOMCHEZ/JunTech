import router from '@ohos.router';
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';
import { PrintExtensionAbility } from '@kit.BasicServicesKit';

//永久存储token和租户id
AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);


interface UserInfo {
  id: string;
  username: string;
  clientType: string;
  realname: string;
  avatar: string | null;
  relTenantIds:number;
  // 其他字段根据实际API响应补充...
}

interface HouchuResult {
  userInfo: UserInfo;
  token: string;
}

interface HouchuResponse {
  code: number;
  message: string;
  result: HouchuResult;
  timestamp: number;
}

interface HouchuHandlerResult {
  success: boolean;
  code?: number;
  userInfo?: UserInfo;
  token?: string;
  message?: string;
  relTenantIds?:number;
}


interface RouteParams {
  token?: string;
  relTenantIds?: number;
}
@Entry
@Component
struct KitchenStaffList {
  @State selectedUnit: string = '所属单位';
  @State units: string[] = ['所属单位', '实训第二学校餐厅', '其他单位'];
  @State showDropdown: boolean = false;
  @State kitchenStaffs: string[] = []; // 后厨人员数据


  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上

  onPageShow() {//这是一个接收传递参数的方法
    // 使用接口类型断言
    const params = router.getParams() as RouteParams;
    console.log('houchu', params?.token);// 打印接收到的参数
    console.log('houchu', params?.relTenantIds);//  打印接收到的参数

    // 安全取值如果返回值空，则使用appsetcreat中所预保存的token和id
    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
    }

    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
    }

    // 同步到组件状态
    this.receivedToken = AppStorage.get('token')??'';
    this.tenantId = AppStorage.get('tenantId')??0;

    console.log('yee', params?.relTenantIds);//  打印接收到的参数
  }



  build() {
    Stack() {
      Column({
        space: 16
      }) {
        Row() {
          DropdownSelector({
            selected: this.selectedUnit,
            options: this.units,
            showDropdown: this.showDropdown,
            onToggle: () => { this.showDropdown = !this.showDropdown; },
            onSelect: (unit: string) => {
              this.selectedUnit = unit;
              this.showDropdown = false;
            }
          })
        }
        .padding({ left: 16, right: 16 });

        // 暂无相关数据提示（条件渲染）
        if (this.kitchenStaffs.length === 0) {
          Text('~ 暂无相关数据 ~')
            .fontSize(16)
            .fontColor(Color.Gray)
            .padding({ top: 200 })
            .textAlign(TextAlign.Center); // 居中显示
        }

        // 返回按钮
        Image($r('app.media.left_icon'))
          .width(32)
          .height(32)
          .position({ bottom: 16, right: 16 });
        // 新建后厨人员按钮


        Button({type: ButtonType.Normal}){
          Text('新建后厨人员')
            .fontSize(16)
            .fontColor(Color.White)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .borderRadius(8)
            .onClick(() => {
              router.pushUrl({          // 使用push入栈一个新页面
                url: "pages/addStaff_test"  // 通过url指定新打开的页面
                ,
                params:{
                  token:this.receivedToken,
                  relTenantIds:this.tenantId

                }
              })
            })
        }
        .width('80%')
        .height(45)
        .backgroundColor(Color.Green)
        .fontColor(Color.White)
        .borderRadius(8)
        .onClick(() => {
          console.log('New kitchen staff button clicked');
        })
        .margin({ top: 385 });
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White);
    }.backgroundColor("#ff969696")
  }
}

@Component
struct DropdownSelector {
  @Link selected: string;
  options: string[] = [];
  @State showDropdown: boolean = false;

  // 新增回调函数类型属性
  onToggle?: () => void;
  onSelect?: (unit: string) => void;

  build() {
    Column() {
      Row() {
        Text(this.selected)
          .fontSize(16);

        Image($r('app.media.down'))
          .width(16)
          .height(16)
          .onClick(() => { // ✅ 改为只在点击下拉箭头时触发
            this.showDropdown = !this.showDropdown;
            if (this.onToggle) {
              this.onToggle();
            }
          })
      }
      .width('70%')
      .padding({ left: 8, right: 8, top: 8, bottom: 8 })
      .border({ width: 1, color: Color.Gray, radius: 8 })

      if (this.showDropdown) {
        Scroll() {
          Column() {
            ForEach(this.options, (unit: string) => {
              Text(unit)
                .fontSize(16)
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .onClick(() => {
                  this.selected = unit;
                  this.showDropdown = false;
                  if (this.onSelect) {
                    this.onSelect(unit);
                  }
                })
            }, (unit: string) => unit)
          }
        }
        .scrollBarWidth(0)
        .width('100%')
        .backgroundColor(Color.White)
        .border({ width: 1, color: Color.Gray, radius: 8 })
        .position({ x: 0, y: 48 })
        .zIndex(100)
      }
    }
  }








  private async Houchuchaxun(): Promise<HouchuHandlerResult> {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-system/sys/login',
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({
            //username: this.userUsername,
           // password: this.userPassword
          })
        }
      );

      if (response.responseCode !== 200) {
        return {
          success: false,
          message: `HTTP Error: ${response.responseCode}`
          // 添加其他错误处理逻辑
        };
      }

      const jsonData = JSON.parse(response.result as string) as HouchuResponse;
      // console.log('',jsonData.result.userInfo.relTenantIds);
      return {
        success: jsonData.code === 200,
        code: jsonData.code,
        userInfo: jsonData.result.userInfo,
        message: jsonData.message,
        relTenantIds:jsonData.result.userInfo.relTenantIds
      };
    } catch (error) {
      console.error('Login Error:', JSON.stringify(error));
      return {
        success: false,
        message: '服务器繁忙'
      };
    }
  }
}
