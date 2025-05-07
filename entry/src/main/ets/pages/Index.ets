import { PrintExtensionAbility } from '@kit.BasicServicesKit';
import router from '@ohos.router';
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  // 新增登录相关状态变量
  @State userUsername: string = '18991274261';
  @State userPassword: string = 'lwjy123456';


  build() {
    Stack() {
      Row(){
        Image($r("app.media.login_bg")) // 确保图片放在src/main/resources/base/media目录
          .width('100%')
          .height('30%')
          .objectFit(ImageFit.Cover)
      }
      .position({x:0,y:0})

      RelativeContainer() {
        // 新增用户登录区域

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
            // 接收 LoginCheck 返回值
            const success = await LoginCheck(this.userUsername, this.userPassword);

            if (success) {
              // 登录成功逻辑，如跳转页面或提示
              promptAction.showToast({
                message: '登录成功',
                duration: 2000,
                bottom:670
              })

               // router.pushUrl({ url: 'pages/shouye' }); // 示例：跳转到主页
            } else {
              // 登录失败逻辑，提示用户
              promptAction.showToast({
                message: '登录失败，检查账号密码是否正确！',
                duration: 2000,
                bottom:670
              })
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
}
async function LoginCheck(username: string, password: string): Promise<boolean> {
  let httpRequest = http.createHttp();

  interface Data {
    username: string;
    password: string;
  }
 interface LoginResponse {
    success: boolean;
    message: string;
    code: number;
    result: null;
    timestamp: number;
  }

  let url = 'https://api.suoeryun.com/ifood/jeecg-system/sys/login';
  let data: Data = {
    username: username,
    password: password
  };

  try {
    let response = await httpRequest.request(
      url,
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify(data)
      }
    );

    // 确保请求成功（HTTP 状态码为200）
    if (response.responseCode === 200) {
      const jsonResponse = JSON.parse(response.result as string) as LoginResponse;
// 将结果解析为JSON对象
      console.log('响应 code:', jsonResponse.result); // 获取code字段
      return jsonResponse.code === 200; // 返回code值
    } else {
      console.log('请求失败，状态码:', response.responseCode);
      return false;
    }
  } catch (error) {
    console.error('请求异常:', error);
    return false;
  }
}

