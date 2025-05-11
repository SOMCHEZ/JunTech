import router from '@ohos.router';

// 定义接收的参数类型
interface RecipeFormData {
  formDataList: boolean;
  from: string;
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
  @State formDataList: RecipeFormData[] =  []// 改为数组存储多条数据

  aboutToAppear() {
    let params = router.getParams() as RecipeFormData;

    if (params && params.from === 'food_day_new') {
      // 确保 formDataList 是数组类型
      if (Array.isArray(params.formDataList)) {
        this.formDataList = params.formDataList;
      } else {
        // 兼容旧逻辑：将当前参数作为新条目加入数组
        this.formDataList.push({
          from: params.from,
          date: params.date,
          recipeName: params.recipeName,
          mealType: params.mealType,
          diningType: params.diningType,
          place: params.place,
          photoUri: params.photoUri,
          formDataList: false // 保持接口字段完整性
        });
      }
    } else if (params) {
      // 首次新建页面传参处理（非 food_day_new 跳转）
      this.formDataList.push(params as RecipeFormData);
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
          Column() {
            ForEach(this.formDataList, (formData: RecipeFormData) => {
              Scroll() {
                Column() {
                  // 信息区
                  Column() {
                    Text(`食谱日期：${formData.date}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ top: 8, bottom: 4 })
                    Text(`食谱名称：${formData.recipeName}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ bottom: 4 })
                    Text(`餐    别：${formData.mealType}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ bottom: 4 })
                    Text(`用餐类型：${formData.diningType}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ bottom: 4 })
                    Text(`餐    厅：${formData.place}`)
                      .fontSize(16)
                      .fontColor('#222')
                      .margin({ bottom: 8 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  // 图片区
                  if (formData.photoUri) {
                    Image(formData.photoUri)
                      .width(120)
                      .height(90)
                      .margin({ top: 8, bottom: 8 })
                      .borderRadius(8)
                  }
                  // 按钮区
                  Row() {
                    Blank()
                    Button('重新编辑')
                      .width(120)
                      .height(36)
                      .fontColor('#07C160')
                      .fontSize(15)
                      .borderRadius(18)
                      .borderWidth(1)
                      .borderColor('#07C160')
                      .backgroundColor('#fff')
                      .onClick(() => {
                        router.pushUrl({
                          url: 'pages/food_day_new',
                          params: {
                            date: formData.date || '',
                            recipeName: formData.recipeName || '',
                            mealType: formData.mealType || '',
                            diningType: formData.diningType || '',
                            place: formData.place || '',
                            photoUri: formData.photoUri || ''
                          }
                        })
                      })
                    Button('删除单据')
                      .width(120) // 增大宽度
                      .height(36)
                      .fontColor('#07C160')
                      .fontSize(15)
                      .borderRadius(18)
                      .borderWidth(1)
                      .borderColor('#07C160')
                      .backgroundColor('#fff')
                      .margin({ left: 16 })
                      .onClick(() => {
                        this.formDataList = this.formDataList.filter(item => item !== formData)
                      })
                  }
                  .margin({ top: 16, bottom: 0 })
                  .justifyContent(FlexAlign.End)
                }
                .backgroundColor('#fff')
                .borderRadius(18)
                .borderWidth(2)
                .borderColor('#07C160')
                .shadow({ radius: 8, color: '#07C16022', offsetX: 0, offsetY: 4 })
                .margin({ top: 12, bottom: 12, left: 8, right: 8 })
                .padding(18)
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
        .width('90%')
        .height(50)
        .backgroundColor('#07C160')
        .fontColor('#FFFFFF')
        .fontSize(18)
        .borderRadius(12)
        .margin({ top: 10, bottom: 20 })
        .alignSelf(ItemAlign.Center)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/food_day_new',
            params: {
              formDataList: this.formDataList
            }
          })
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