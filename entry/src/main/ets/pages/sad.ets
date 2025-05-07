// Page1.ets
@Entry
@Component
struct Page1 {
  @State selectedPosition: string = ''
  @State selectedUnit: string = ''
  @State selectedMeal: string = '' // 新增：选中的餐别
  @State name: string = ''
  @State evaluation: string = ''
  @State charCount: number = 0

  private unitOptions = [
    '实验第一中学',
    '实验第二中学',
    '实验第三中学'
  ]

  // 新增：餐别选项列表
  private mealOptions = [
    '早餐',
    '午餐',
    '晚餐'
  ]

  build() {
    Column() {

      Text('陪餐记录')
        .fontSize(24)
        .margin(20)


      Row(){
        Text("提交单位")
          .fontColor(Color.Black)
          .fontSize(16)

        Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
          .selected(0)
          .onSelect((index: number) => {
            this.selectedUnit = this.unitOptions[index]
          })
          .margin(10)
          .width('70%')
          .margin({left:20,right:0,bottom:10})
      }

      Row(){
        Text("餐别选择")
          .fontColor(Color.Black)
          .fontSize(16)

        Select(this.mealOptions.map<SelectOption>((item: string) => ({ value: item })))
          .selected(0)
          .onSelect((index: number) => {
            this.selectedMeal = this.mealOptions[index]
          })
          .margin(10)
          .width('70%')
          .margin({left:20,right:0,bottom:10})

      }

      Row(){
        Text("配餐人身份")
          .fontColor(Color.Black)
          .fontSize(16)

        Select([
          { value: '教师' },
          { value: '家长' },
          { value: '中层领导' },
          { value: '校领导' },
        ] as SelectOption[])
          .selected(0)
          .onSelect((index: number) => {
            this.selectedPosition = index.toString()
          })
          .margin(10)
          .width('70%')
          .margin({left:8,right:0,bottom:10})
      }

      TextInput({ placeholder: '陪餐人姓名 *', text: this.name })
        .margin({bottom:10})

      TextInput({ placeholder: '请输入评价', text: this.evaluation })

      Text("陪餐图片上传")
        .fontColor(Color.Black)
        .fontSize(16)
        .margin({left:-250,top:10})

      Button({type:ButtonType.Normal})
        .width(75)
        .height(75)
        .backgroundColor(Color.White)
        .backgroundImage($r('app.media.evidence_add'))
        .backgroundImageSize(1)
        .margin({left:-225})

      Button({type: ButtonType.Normal})
      {
        Text("提交")
          .margin({top: 1,bottom: 1})
          .fontColor(Color.White)
          .width('90%')
          .height(40)
          .textAlign(TextAlign.Center)
      }
      .width('90%')
      .height(40)
      .margin({top: 250})
      .borderRadius(5)
      .backgroundColor(Color.Green)


    }
    .width('100%')
    .height('100%')
  }
}