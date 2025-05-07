@Entry
@Component
struct Index {
  // 新增登录相关状态变量
  @State adminUsername: string = '';
  @State adminPassword: string = '';
  @State userUsername: string = '';
  @State userPassword: string = '';


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
          .backgroundColor(Color.Red)
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

        Button('登录')
          .id('userBtn')
          .width('80%')
          .margin({ top: 20 })
          .backgroundColor(Color.Green)
          .onClick(() => {
            console.log('User login attempted');
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
