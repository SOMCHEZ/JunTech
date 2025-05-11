import { PrintExtensionAbility } from '@kit.BasicServicesKit';
import router from '@ohos.router';
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';

// 明确定义所有接口类型
interface UserInfo {
  id: string;
  username: string;
  clientType: string;
  realname: string;
  avatar: string | null;
  relTenantIds:number;
  // 其他字段根据实际API响应补充...
}

interface LoginResult {
  userInfo: UserInfo;
  token: string;
}

interface LoginResponse {
  code: number;
  message: string;
  result: LoginResult;
  timestamp: number;
}

interface LoginHandlerResult {
  success: boolean;
  code?: number;
  userInfo?: UserInfo;
  token?: string;
  message?: string;
  relTenantIds?:number;
}

@Entry
@Component
struct Index {
  @State typeid: string = '';
  @State userUsername: string = '';
  @State userPassword: string = '';

  // 状态管理
  @State private responseCode: number = 0;
  @State private authToken: string = '';
  @State private currentUser: UserInfo | null = null;

  build() {
    Stack() {
      Row(){
        Image($r("app.media.login_bg"))
          .width('100%')
          .height('30%')
          .objectFit(ImageFit.Cover)
      }
      .position({x:0,y:0})

      RelativeContainer() {
        Image("")
          .backgroundColor(Color.White)
          .width('100%')
          .height('100%')
          .position({x:0,y:-50})
          .borderRadius({topLeft: 20,topRight: 20})

        TextInput({ text: this.userUsername, placeholder: '用户账号' })
          .id('userUser')
          .height(40)
          .width('80%')
          .margin({ top: 40 })
          .alignRules({
            top: { anchor: 'adminBtn', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onChange((value) => {
            this.userUsername = value;
          })

        TextInput({ text: this.userPassword, placeholder: '用户密码' })
          .id('userPwd')
          .type(InputType.Password)
          .height(40)
          .width('80%')
          .margin({ top: 10 })
          .alignRules({
            top: { anchor: 'userUser', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onChange((value) => {
            this.userPassword = value;
          })

        Button('登录')
          .id('userBtn')
          .width('80%')
          .margin({ top: 20 })
          .backgroundColor(Color.Green)
          .onClick(async () => {
            const result = await this.executeLogin();

            if (result.success) {
              // 数据存储
              this.currentUser = result.userInfo!;
              this.authToken = result.token!;

              // 路由逻辑
              this.handleUserRedirection(result.userInfo?.clientType);

              promptAction.showToast({
                message: '登录成功',
                duration: 2000,
                bottom:670
              });
            } else {
              promptAction.showToast({
                message: result.message || '登录失败',
                duration: 2000,
                bottom:670
              });
            }
          })
          .alignRules({
            top: { anchor: 'userPwd', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .height('100%')
      .width('100%')
      .margin({ top: 500})
    }.backgroundColor(Color.Gray)
  }

  // 私有方法：执行登录操作
  private async executeLogin(): Promise<LoginHandlerResult> {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-system/sys/login',
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({
            username: this.userUsername,
            password: this.userPassword
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

      const jsonData = JSON.parse(response.result as string) as LoginResponse;
      //console.log('',jsonData.result.userInfo.relTenantIds);
      return {
        success: jsonData.code === 200,
        code: jsonData.code,
        userInfo: jsonData.result.userInfo,
        token: jsonData.result.token,
        message: jsonData.message,
        relTenantIds:jsonData.result.userInfo.relTenantIds
      };
    } catch (error) {
      console.error('Login Error:', JSON.stringify(error));
      return {
        success: false,
        message: '账号或密码输入错误'
      };
    }
  }

  // 私有方法：处理用户跳转
  private handleUserRedirection(clientType?: string) {
    switch(clientType) {
      case "2"://跳学校的首页，夹带token等私货
        router.pushUrl({ url: 'pages/shouye_test',
          params:{
          token:this.authToken,
            relTenantIds:this.currentUser?.relTenantIds

          }



        });
        break;


      case "3"://跳供应商的首页页面夹带token等私货
        router.pushUrl({ url: 'pages/Today_VEG',
          params:{
            token:this.authToken,
            relTenantIds:this.currentUser?.relTenantIds

          }
        });

        break;
      default:
        console.error("未定义的用户类型:", clientType);
    }
  }

}