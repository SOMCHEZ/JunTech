import router from '@ohos.router';

// Page1.ets
interface GeneratedObjectLiteralInterface_1 {
  unit: string;
  meal: string;
  position: string;
  name: string;
  evaluation: string;
  date: string;
}

@Entry
@Component
struct Page1 {
  @State selectedPosition: string = ''
  @State selectedUnit: string = ''
  @State selectedMeal: string = '' // 新增：选中的餐别
  @State name: string = ''
  @State evaluation: string = ''
  @State charCount: number = 0
  @State date: string = '选择日期'
  @State selectedDate: string = '请选择供应日期'
  @State selectDate: Date = new Date()
  @State dates: string = '请选择'
  @State unit:string=''
  @State meal: string=''
  private unitOptions = [

    '实训第一中学',
    '实训第二中学',
    '实训第三中学'
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


    Text("选择日期")
   //   .fontColor(Color.Black)
   //   .fontSize(16)
   //   Text(this.dates)
  Select([])

    .onClick(() => {
      this.showDateDialog()

    })
    .value(this.dates)
    .margin(10)
    .width('70%')
    .margin({left:20,right:0,bottom:10})
  // DatePicker()
  //   .lunar(false)
  //   .onDateChange(value=>{
  //     this.date=value.toDateString()
  //   })
  //   .width("80%")
  //   .height(50)
}

      Row(){

        Text("提交单位")
          .fontColor(Color.Black)
          .fontSize(16)

        Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
          .value('请选择')
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
          .value('请选择')
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
          .value('请选择')
          .selected(0)
          .onSelect((index: number) => {
            this.selectedPosition = index.toString()
          })
          .margin(10)
          .width('70%')
          .margin({left:8,right:0,bottom:10})
      }

      TextInput({ placeholder: '陪餐人姓名 *', text: this.name })
        .onChange((value: string) => {
          this.name = value; // 更新状态变量
        })
        .margin({bottom:10})

      TextInput({ placeholder: '请输入评价', text: this.evaluation })
        .onChange((value: string) => {
          this.evaluation = value; // 更新状态变量
        })


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
      // 修改提交按钮的 onClick 事件

      .onClick(() => {
        const positionOptions = ['教师', '家长', '中层领导', '校领导'];
        const record: GeneratedObjectLiteralInterface_1 = {
          unit: this.selectedUnit,
          meal: this.selectedMeal,
          position: positionOptions[parseInt(this.selectedPosition)], // 转换为实际的字符串值
          name: this.name,
          evaluation: this.evaluation,
          date: this.dates
        };
        router.pushUrl({
          url: 'pages/peicanRecrods',
          params: { record: JSON.stringify(record) }
        });
      })


    }
    .width('100%')
    .height('100%')
  }
  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        // 使用可选链和默认值保证安全性
        const year = value.year ?? new Date().getFullYear();
        const month = value.month ?? new Date().getMonth() + 1; // 这里不需要减1
        const day = value.day ?? new Date().getDate();

        this.selectDate = new Date(year, month - 1, day); // 这里需要减1
        this.dates = `${year}-${(month+1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
      }
    })
  }

}