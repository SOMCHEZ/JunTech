import { promptAction } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'

@Entry
@Component
struct DatePickerExample {

  @State private showSelect: boolean = false // 控制 Select 是否显示
  @State selectedDate: string = ''
  @State selectDate: Date = new Date()
  @State  selectedText: string[] = ['请选择','请选择','请选择','请选择','请选择','请选择',]
  private unitOptions = ['实验第二学校（库房）', '实验第二学校餐厅']

  private selectedTime =['上午', '下午']
  private demandOptions = ['学生餐', '老师餐']
  private mealOptions = ['其他', '早餐', '午餐', '晚餐']



  build() {
    Column() {
      Column({ space: 10 }) {
        this.buildLabelRow($r("app.media.unitName"), "需求单位", true,0)
        this.buildLabelRow($r("app.media.supplyDate"), "供应日期", true,1)
        this.buildLabelRow($r("app.media.supplyTime"), "供应时间", false,2)
        this.buildLabelRow($r("app.media.demand"), "需求类型", true,3)
        this.buildLabelRow($r("app.media.mealCategory"), "餐别", true,4)
        this.buildLabelRow($r("app.media.remarks"), "摘要", false,5)
      }
      .width('100%')
      .padding(10)

      // 条件渲染 Select 组件
      if (this.showSelect) {
        Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
          .value('')
            // .onClick(() => {
            //   this.selectedText[0] = this.unitOptions[0]
            //   console.log('Selected unit:', this.selectedText[0])
            //   this.showSelect = false // 选择完成后隐藏 Select
            // })
          .onSelect((index: number) => {
            this.selectedText[0] = this.unitOptions[index]
            console.log('Selected unit:', this.selectedText[0])
            this.showSelect = false // 选择完成后隐藏 Select
          })
          .margin(10)
          .width('40%')
          .height(40)
          .font({ size: 10 })

        // Text(this.selectedText[0])
//         .onClick(() => {
//           promptAction.showActionMenu({   // 显示一个菜单栏
//             title: "ActionMenu标题", // 设置标题
//             buttons: [              // 设置选项
//               {
//                 text: "按钮1",
//                 color: "#aabbcc"
//               },
//               {
//                 text: "按钮2",
//                 color: "#bbccaa"
//               },
//               {
//                 text: "按钮3",
//                 color: "#ccaabb"
//               }
//             ]
//           }, (error, index) => {    // 事件回调
//             let msg = error ? JSON.stringify(error) : "index: " + index;
//             promptAction.showToast({
//               message: msg
//             })
//           })
//         })
  .position({ x: 250, y: 0 })


      }

    }
  }



  // 封装可复用的行构建方法
  @Builder
  buildLabelRow(iconResource: Resource, label: string, showAsterisk: boolean, index: number) {
    Row() {
      // 左侧图标和标签
      Row() {
        Image(iconResource)
          .width(30)
          .height(30)
          .objectFit(ImageFit.Contain)
          .margin({ right: 10 })

        Text(label)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)

        if (showAsterisk) {
          Text("*")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Red)
            .margin({ left: 4 })
        }
      }
      .layoutWeight(1)

      // 右侧选择区域
      Row() {
         Text(this.selectedText[index])
           .fontSize(14)
           .fontColor('#000000')
        Image($r("app.media.ic_arrow_right")) // 右侧箭头图标
          .width(20)
          .height(20)
          .margin({ left: 5 })
          .fillColor('#8A96A2')



      }
      .onClick(() => {
        if (label === "需求单位") {
          this.showSelect = true // 显示 Select

        }
        else if (label === "供应日期") {
         this.showDateDialog()
        }
      })
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .height(40)
    .padding({ right: 10 })
  }
  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()
        this.selectDate = new Date(year, month - 1, day)
        this.selectedText[1] = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }
}









