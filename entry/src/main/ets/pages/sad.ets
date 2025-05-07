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

      // 提交单位选择
      Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
        .selected(0)
        .onSelect((index: number) => {
          this.selectedUnit = this.unitOptions[index]
        })
        .margin(10)
        .width('90%')

      // 新增：餐别选择
      Select(this.mealOptions.map<SelectOption>((item: string) => ({ value: item })))
        .selected(0)
        .onSelect((index: number) => {
          this.selectedMeal = this.mealOptions[index]
        })
        .margin(10)
        .width('90%')

      // 陪餐人职务选择
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
        .width('90%')

      // 其余保持不变的UI组件...
      TextInput({ placeholder: '陪餐人姓名 *', text: this.name })
      // ...保持原有实现

      Button('上传陪餐图片 *')
      // ...保持原有实现

      TextInput({ placeholder: '请输入评价', text: this.evaluation })
      // ...保持原有实现

      Text(`${this.charCount}/10`)
      // ...保持原有实现
    }
    .width('100%')
  }
}