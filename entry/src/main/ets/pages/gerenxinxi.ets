import { router } from '@kit.ArkUI'

@Entry
@Component
struct gerenxinxi {
  @State  email: string = ''
  @State  phoneNumber: string = ''
  @State  gender: string = '女' // 添加性别状态
  @State  name: string = ''
  private genders: Array<string> = ['男', '女']
  @State realname: string = '';
  @State telephone: string = '';
  @State organizationName: string = '';

  aboutToAppear() {
    // 获取参数
    let params = router.getParams() as Record<string, string>
    this.realname  = params.realname || ''
    this.telephone  = params.telephone || ''
    this.organizationName  = params.organizationName || ''
  }

  build() {
    Column() {
      Row() {
        Text('姓名：')
          .width(100)
          .padding(10)
        TextInput({ placeholder: '请输入姓名', text: this.realname })
          .onChange((value: string) => {
            this.realname = value
          })
          .textAlign(TextAlign.End)
          .width(240)
          .padding(10)
      }
      .width('100%')
      .margin(10)

      Row() {
        Text('性别：')
          .width(70)
          .padding(10)
          .margin({right: 130})
        Row() {
          ForEach(this.genders, (item: string) => {
            Row() {
              Radio({ value: item, group: 'genderGroup' })
                .checked(this.gender === item)
                .onChange((isSelect: boolean) => {
                  if (isSelect) {
                    this.gender = item
                  }
                })
              Text(item)
                .padding({ left: 6, right: 16 })
            }
          })
        }
        .padding(10)
      }
      .width('100%')
      .margin(10)

      Row() {
        Text('邮箱：')
          .width(100)
          .padding(10)
        TextInput({ placeholder: '请输入邮箱', text: this.email })
          .onChange((value: string) => {
            this.email = value
          })
          .textAlign(TextAlign.End)
          .width(240)
          .padding(10)
      }.width('100%').margin(10)

      Row() {
        Text('手机号：')
          .width(100)
          .padding(10)
        TextInput({ placeholder: '请输入手机号码', text: this.telephone })
          .onChange((value: string) => {
            this.telephone = value
          })
          .textAlign(TextAlign.End)
          .width(240)
          .padding(10)
      }
      .width('100%')
      .margin(10)

      Button('确认修改')
        .width(200)
        .height(40)
        .backgroundColor('#36C56B')
        .margin(20)
        .onClick(() => {
          // 在这里添加确认修改的逻辑，例如保存到服务器或本地存储
          console.log(`邮箱: ${this.email}, 手机号: ${this.phoneNumber}`)
        })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#F5F5F5')
  }
}
