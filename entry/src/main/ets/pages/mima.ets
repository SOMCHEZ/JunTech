@Entry
@Component
struct mima {
  @State mima: string = ''
  @State mima1: string = ''
  @State mima2: string = ''
  build() {
    Column() {
      TextInput({placeholder: '请输入旧密码'})
        .onChange((value: string) => {
          this.mima = value
        })
        .type(InputType.Password)
        .fontSize(20)
        .width(330)
        .padding(10)
        .margin({top: 20, bottom: 20, left: 20, right: 20 })
        TextInput({ placeholder: '请输入新密码' })
          .onChange((value: string) => {
            this.mima1 = value
          })
          .type(InputType.Password)
          .width(330)
          .padding(10)
          .margin({ bottom: 20, left: 20, right: 20 })
      TextInput({ placeholder: '请再次输入新密码' })
        .onChange((value: string) => {
          this.mima2 = value
        })
        .type(InputType.Password)
        .width(330)
        .padding(10)
        .margin({ bottom: 20, left: 20, right: 20 })
      Button('确认修改')
        .width(330)
        .height(40)
        .backgroundColor('#36C56B')
        .margin(20)
        .onClick(() => {
          // 在这里添加确认修改的逻辑，例如保存到服务器或本地存储
          //添加判断mima1==mima2的判断
          console.log(`旧密码: ${this.mima}, 新密码: ${this.mima2}`)
        })
      }
      .width('100%')
      .margin(10)
    }
  }
