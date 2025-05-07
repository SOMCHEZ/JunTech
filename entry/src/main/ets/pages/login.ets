// Login.ets
import http from '@ohos.net.http'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct LoginPage {
  @State username: string = ''
  @State password: string = ''

  build() {
    Column() {
      TextInput({ placeholder: '用户名' })
        .width('80%')
        .onChange((value: string) => { this.username = value })

      TextInput({ placeholder: '密码' })
        .width('80%')
        .type(InputType.Password)
        .onChange((value: string) => { this.password = value })

      Button('登录')
        .width('80%')
        .margin({ top: 20 })
        .onClick(() => { this.login() })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  // 最简单的登录请求
  private login() {
    const httpRequest = http.createHttp()
    const url = 'http://your-server-domain/jeecg-system/sys/mLogin'

    httpRequest.request(
      url,
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify({
          username: this.username,
          password: this.password
        })
      },
      (err, response) => {
        console.info('HTTP响应状态码:', response?.responseCode) // 打印状态码
        console.info('HTTP响应结果:', response?.result) // 打印响应数据
        console.info('HTTP错误:', err) // 打印错误信息

        if (!err && response?.responseCode === 200) {
          promptAction.showToast({ message: '连接成功: ' + response.result })
        } else {
          promptAction.showToast({ message: '连接失败: ' + (err?.message || response?.responseCode) })
        }
        httpRequest.destroy()
      }
    )
  }
}