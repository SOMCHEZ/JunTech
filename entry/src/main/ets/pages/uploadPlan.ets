import router from '@ohos.router';
@Entry
@Component
struct ReportPlanPage {

  @State x: number = 0
  @State s: number = 0
  @State name: string = ''
  @State selectedUnit: string = '请选择需求单位'
  @State selectedDate: string = '请选择供应日期'
  @State selectDate: Date = new Date()

  private unitOptions = [
    '选择需求单位',
    '实验第二学校（库房）',
    '实验第二学校餐厅'
  ]

  aboutToAppear() {
    if (this.unitOptions.length > 0) {
      this.selectedUnit = this.unitOptions[0]
    }

  }

  build() {

      Column() {

        Row() {
          Button('未上报')
            .width('50%')
            .height(40)
            .backgroundColor(this.x === 0 ? '#E8F5E9' : '#F5F5F5')
            .fontColor(this.x === 0 ? '#07C160' : '#666666')
            .fontWeight(this.x ===0?FontWeight.Bold : FontWeight.Normal)
            .borderRadius(0)// 去除圆角
            .borderWidth(0)// 去除边框
            .onClick(() => {
              this.x = 0
            })

          Button('已上报')
            .width('50%')
            .height(40)
            .backgroundColor(this.x === 1 ? '#E8F5E9' : '#F5F5F5')
            .fontColor(this.x === 1 ? '#07C160' : '#666666')
            .fontWeight(this.x ===1?FontWeight.Bold : FontWeight.Normal)
            .borderRadius(0)
            .borderWidth(0)
            .onClick(() => {
              this.x = 1
            })
        }
        .width('100%')
        .margin({ bottom: 20 })


        Row({space:40}) {
          Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
            .value(this.unitOptions[0])
            .onSelect((index: number) => {
              this.selectedUnit = this.unitOptions[index]
            })

            .margin(10)
            .width('40%')
            .height(40)
            .font({ size: 10 })

          Select([])
            .value(this.selectedDate)
            .onClick(() => {
              this.showDateDialog()
            })
            .margin(10)
            .width('40%')
            .height(40)
            .font({ size: 10 })

        }
        .width('100%')
        .margin({ bottom: 15 })

        Column() {
          Column() {
            Text('- 暂无相关数据 -')
              .position({
                x: 110,
                y: 180
              })
          }
        }
        .width('100%')
        .backgroundColor('#f2dbdada')
        .layoutWeight(1)

        Button('新建上报计划', { type: ButtonType.Capsule })
          .width('100%')
          .height(50)
          .backgroundColor('#02BC65')
          .fontColor('#FFFFFF')
          .margin({ top: 20 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/addpan' })
          })
      }

      .width('100%')
      .height('100%')
      .padding(20)
      .backgroundColor('#F5F5F5')

  }

  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        // 使用可选链和默认值保证安全性
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()

        this.selectDate = new Date(year, month - 1, day)
        this.selectedDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

}