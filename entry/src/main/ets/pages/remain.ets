@Entry
@Component

struct SampleFormPage {
  @State submitUnit: string = '实训第二学校餐厅'
  @State sampleDate: string = '请选择日期'
  @State sampleType: string = '不区分'
  @State mealType: string = '午餐'
  @State fridgeTemp: string = '5'
  @State dishName: string = ''
  @State sampleWeight: string = ''
  @State destroyPerson: string = ''
  @State destroyTime: string = '请选择销毁时间'
  @State sampleImages: string[] = []
  @State fridgeImages: string[] = []
  @State remark: string = ''

  private unitOptions: string[] = ['实训第二学校餐厅', '其他']
  private typeOptions: string[] = ['不区分', '教师餐', '学生餐']
  private mealOptions: string[] = ['早餐', '午餐', '晚餐', '其他']
  private destroyTimeOptions: string[] = ['上午', '下午', '晚上']

  build() {
    Column() {
      Scroll() {
        Column() {
          // 顶部提示
          Text('根据政策要求，样本重量不少于125克，且该留样时间必须在48小时以上。预计该样本在2025年05月11日后可以销毁。')
            .fontColor('#FF7F50')
            .fontSize(15)
            .margin({ bottom: 16, top: 8 })

          // 提交单位
          Row() {
            this.formRow('提交单位', true)
            Select(this.unitOptions.map<SelectOption>(item => ({ value: item })))
              .value(this.submitUnit)
              .onSelect(index => this.submitUnit = this.unitOptions[index])
              .width('65%')
          }
          .margin({top: 5, bottom: 5 })
          // 留样日期
          Row(){
            this.formRow('留样日期', true)
            Text(this.sampleDate)
              .onClick(() => this.showDatePicker())
              .fontColor(this.sampleDate === '请选择日期' ? '#bbb' : '#222')
              .width('65%')
          }
          .margin({top: 5, bottom: 5 })
          // 留样类型
          Row() {
            this.formRow('留样类型', true)
            Select(this.typeOptions.map<SelectOption>(item => ({ value: item })))
              .value(this.sampleType)
              .onSelect(index => this.sampleType = this.typeOptions[index])
              .width('65%')
          }
          .margin({top: 5, bottom: 5 })
          // 餐别
          Row() {
            this.formRow('留样类型', true)
            Select(this.mealOptions.map<SelectOption>(item => ({ value: item })))
              .value(this.mealType)
              .onSelect(index => this.mealType = this.mealOptions[index])
              .width('65%')
          }
          .margin({top: 5, bottom: 5 })
          // 留样柜温度
          Row(){
            this.formRow('留样柜温度℃', true)
            TextInput({ placeholder: '5' })
              .type(InputType.Number)
              .onChange(val => this.fridgeTemp = val)
              .width('100%')
          }
          .margin({top: 5, bottom: 5 })
          // 菜品名称
          Row(){
            this.formRow('菜品名称', true)
            TextInput({ placeholder: '请输入菜品名称' })
              .onChange(val => this.dishName = val)
              .width('100%')
          }
          .margin({top: 5, bottom: 5 })
          // 留样重量
          Row(){
            this.formRow('留样重量(克)', true)
            TextInput({ placeholder: '请输入留样重量' })
              .type(InputType.Number)
              .onChange(val => this.sampleWeight = val)
              .width('100%')
          }
          .margin({top: 5, bottom: 5 })
          // 销毁人员
          Row(){
            this.formRow('销毁人员', true)
            TextInput({ placeholder: '请输入销毁人员' })
              .onChange(val => this.destroyPerson = val)
              .width('100%')
          }
          .margin({top: 5, bottom: 5 })
          // 销毁时间
          Row(){
            this.formRow('销毁时间', false)
            Select(this.destroyTimeOptions.map<SelectOption>(item => ({ value: item })))
              .value(this.destroyTime)
              .onSelect(index => this.destroyTime = this.destroyTimeOptions[index])
              .width('65%')
          }
          .margin({top: 5, bottom: 5 })
          // 上传留样图片
          this.formImageRow('上传留样图片', true, this.sampleImages, 10, (imgs) => this.sampleImages = imgs)
          // 放入留样柜拍照
          this.formImageRow('放入留样柜拍照', true, this.fridgeImages, 2, (imgs) => this.fridgeImages = imgs)

          // 备注
          Column() {
            Text('备注').fontWeight(FontWeight.Bold).margin({ top: 16, bottom: 4 })
            TextInput({ placeholder: '请输入备注信息' })
              .onChange(val => this.remark = val)
              .width('100%')
          }

        }
        .padding(16)
        .width('100%')
      }
      .layoutWeight(1)

      // 提交按钮
      Button('提交')
        .width('100%')
        .height(48)
        .backgroundColor('#07C160')
        .fontColor('#fff')
        .fontSize(20)
        .margin({ top: 24, bottom: 24 })
        .onClick(() => this.submit())
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }

  // 表单行封装
  @Builder
  private formRow(label: string, required: boolean) {
    Row(){
      Text(label)
        .fontWeight(FontWeight.Bold)
      if ((required?'*':'')) {
        Text('*')
          .fontColor('#ff0000')
          .margin({ left: 4 });
      }
    }
    .margin({ top: 8, bottom: 8 })
    .width('35%')
    .alignItems(VerticalAlign.Center)
  }

  // 图片上传行封装
  @Builder
  private formImageRow(label: string, required: boolean, images: string[], max: number, onChange: (imgs: string[]) => void) {
    Column(){
      Row() {
        Text(label)
          .fontWeight(FontWeight.Bold)
          .width('45%')
        if ((required?'*':'')) {
          Text('*')
            .fontColor('#ff0000')
            .margin({ left: 4 });
        }
        Text(`${images.length}/${max}`)
          .fontColor('#888')
          .width('50%')
          .textAlign(TextAlign.End)
      }
      .margin({top: 5, bottom: 5 })
      Row() {
        // 这里只做示意，实际可用ImagePicker组件
        Image($r('app.media.evidence_add'))
          .width(80)
          .height(80)
          .borderWidth(1)
          .borderColor('#eee')
          .borderRadius(8)
          .onClick(() => {
            // 这里实现图片选择逻辑
            //onChange([...images, '新图片路径'])
          })
          .margin({right:220})
      }
      .margin({top: 5, bottom: 5 })
    }
    .margin({ top: 8, bottom: 8 })
    .width('100%')
  }

  // 日期选择
  private showDatePicker() {
    DatePickerDialog.show({
      start: new Date('2020-01-01'),
      end: new Date('2030-12-31'),
      selected: new Date(),
      onAccept: (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()
        this.sampleDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

  private submit() {
    // 校验与提交逻辑
    // ...
  }
}