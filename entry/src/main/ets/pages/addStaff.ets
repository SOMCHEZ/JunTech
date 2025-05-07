import router from '@ohos.router';

@Entry
@Component
struct addStaff {
  build() {
    Column({ space: 20 }) {
      // 标题
      Text("添加员工")
        .fontSize(30)
        .fontWeight(FontWeight.Bold)

      // 姓名输入框
      TextInput({ placeholder: '请输入姓名' })
        .width('90%')
        .height(50)
        .borderWidth(1)
        .borderColor('#ccc')
        .padding({ left: 10 })

      // 电话输入框
      TextInput({ placeholder: '请输入电话' })
        .width('90%')
        .height(50)
        .borderWidth(1)
        .borderColor('#ccc')
        .padding({ left: 10 })

      // 职位输入框
      TextInput({ placeholder: '请输入职位' })
        .width('90%')
        .height(50)
        .borderWidth(1)
        .borderColor('#ccc')
        .padding({ left: 10 })

      // 提交按钮
      Button("提交")
        .width('90%')
        .height(50)
        .backgroundColor('#4CAF50')
        .onClick(() => {
          // 提交逻辑
          console.log("提交员工信息");
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .padding({ top: 20, left: 10, right: 10 })
  }
}
