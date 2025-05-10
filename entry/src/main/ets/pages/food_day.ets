import router from '@ohos.router';

// 定义接收的参数类型
interface RecipeFormData {
  date?: string;
  recipeName?: string;
  mealType?: string;
  diningType?: string;
  place?: string;
  photoUri?: string;
}

@Entry
@Component
struct food_day {
  private selectDate: Date = new Date()
  @State selectedMeal: string = '请选择餐别'
  @State selectedDate: string = '请选择筛选日期'
  private unitOptions = [
    '其他', '早餐', '午餐', '晚餐'
  ]
  @State formDataList: RecipeFormData[] = [] // 改为数组存储多条数据

  aboutToAppear() {
    let params = router.getParams()
    if (params && params.toString()) {
      this.formDataList.push(params as RecipeFormData)
    }
  }

  build() {
    Column() {
      // 顶部选择栏
      Column() {
        Row() {
          Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
            .selected(0)
            .value(this.unitOptions[0])
            .onSelect((index: number) => {
              this.selectedMeal = this.unitOptions[index]
            })
            .margin(10)
            .width('40%')
            .height(40)
            .font({ size: 15 })

          Text(this.selectedDate)
            .width('60%')
            .height(40)
            .textAlign(TextAlign.Center)
            .borderRadius(4)
            .borderWidth(1)
            .borderColor('#CCCCCC')
            .onClick(() => {
              this.showDateDialog()
            })
        }
        .width('100%')
        .margin({ bottom: 15 })

        // 数据展示区
        if (this.formDataList.length > 0) {
          List() {
            ForEach(this.formDataList, (formData: RecipeFormData) => {
              ListItem() {
                Column() {
                  Text(`食谱日期：${formData.date}`)
                    .width('50%')
                    .fontSize(20)
                    .margin({ top: 10, bottom: 10 })
                  Text(`食谱名称：${formData.recipeName}`)
                    .fontSize(20)
                    .width('50%')
                    .margin({ bottom: 10 })
                  Text(`餐    别：${formData.mealType}`)
                    .fontSize(20)
                    .width('50%')
                    .margin({ bottom: 10 })
                  Text(`用餐类型：${formData.diningType}`)
                    .fontSize(20)
                    .width('50%')
                    .margin({ bottom: 10 })
                  Text(`餐    厅：${formData.place}`)
                    .fontSize(20)
                    .width('50%')
                    .margin({ bottom: 10 })
                  if (formData.photoUri) {
                    Image(formData.photoUri)
                      .width('80%')
                      .height(120)
                      .margin({ top: 10, bottom: 10 })
                  }
                  Row({ space: 30 }) {
                    Button('重新编辑')
                      .width('20%')
                      .fontColor('#07C160')
                      .borderRadius(30)
                      .borderWidth(2)
                      .borderColor('#07C160')
                      .backgroundColor('#fff')
                      .margin({left:'40%'})
                      .onClick(() => {
                        router.pushUrl({
                          url: 'pages/food_day_new',
                          params: formData
                        })
                      })
                    Button('删除单据')
                      .width('20%')
                      .fontColor('#07C160')
                      .borderRadius(30)
                      .borderWidth(2)
                      .borderColor('#07C160')
                      .backgroundColor('#fff')
                      .onClick(() => {
                        this.formDataList = this.formDataList.filter(item => item !== formData)
                      })
                  }
                  .margin({ top: 30 })
                }
                .backgroundColor('#fff')
                .borderRadius(20)
                .borderWidth(2)
                .borderColor('#07C160')
                .margin({ top: 10, bottom: 10, left: 10, right: 10 })
                .padding(20)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          // 下拉回弹效果
        } else {
          Column() {
            Text('- 暂无相关数据 -')
              .position({
                x: 110,
                y: 180
              })
          }
        }
      }
      .layoutWeight(1)


      // 新建食谱按钮
      Button('新建食谱', { type: ButtonType.Capsule })
        .width('100%')
        .height(50)
        .backgroundColor('#07C160')
        .fontColor('#FFFFFF')
        .margin({ top: 20 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/food_day_new'
          });
        })
    }
    .width('100%')
    .padding({ left: 10, right: 10 })
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
        this.selectedDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }
}