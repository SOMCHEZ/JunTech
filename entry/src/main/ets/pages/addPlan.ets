import { promptAction } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import prompt from '@ohos.prompt';


import router from '@ohos.router';

interface GeneratedObjectLiteralInterface_1 {
  date: string;
  recipeName: string;
  mealType: string;
  diningType: string;
  place: string;
  photoUri: string;
}

@Entry
@Component
struct DatePickerExample {

  @State selectedDate: string = ''
  @State selectDate: Date = new Date()
  @State showDialog: boolean = false
  @State opacityValue: number = 0
  @State scaleValue: number = 0.8
  @State summary: string = ''// 摘要内容
  @State selectedText: string[] = ['请选择','请选择','请选择','请选择','请选择','请选择','请输入摘要']
  @State private showMealType: boolean = false // 控制是否显示用餐类型
  private unitOptions = ['实验第二学校（库房）', '实验第二学校餐厅']
  private selectedTime = ['上午', '下午']
  private demandOptions = ['学生餐', '老师餐']
  private mealTypeOptions = ['其他','营养餐']
  private mealOptions = ['其他', '早餐', '午餐', '晚餐']



  build() {
    Stack(){
      Column() {
        Column(){
          Column({ space: 10 }) {
            this.buildLabelRow($r("app.media.unitName"), "需求单位", true, 0)
            this.buildLabelRow($r("app.media.supplyDate"), "供应日期", true, 1)
            this.buildLabelRow($r("app.media.supplyTime"), "供应时间", false, 2)
            this.buildLabelRow($r("app.media.demand"), "需求类型", true, 3)

            // 条件用餐类型行
            if (this.showMealType) {
              this.buildLabelRow($r("app.media.requirementType"), "用餐类型", true, 4)
            }

            this.buildLabelRow($r("app.media.mealCategory"), "餐别", true, 5)
            this.buildLabelRow($r("app.media.remarks"), "摘要", false, 6)
          }
          .width('100%')
          .padding(10)

          // 添加食材按钮
          Row() {
            Button({type: ButtonType.Normal}) {
              Text('+添加食材')
                .fontSize(16)
                .fontColor(Color.White)
                .padding({
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8
                })
                .borderRadius(8)
            }
            .width('80%')
            .height(35)
            .backgroundColor('#02BC65')
            .fontColor(Color.White)
            .borderRadius(8)
            .width('auto')
            .padding({ left: 15, right: 15 })

            Text('已选中*种食材')
              .fontColor('#8A96A2')
              .position({ x: 137, y: 15 })
          }

          Column()//渐变框
            .linearGradient({
              angle: 180,
              colors: [['#93D0B1', 0.1],['#FDFDFD',1]],
            })
            .margin({top: 10})
            .width('100%')
            .height(20)
        }
        .layoutWeight(1)

        if (this.showDialog) {
          // 半透明背景层
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#80000000')
            .position({ x: 0, y: 0 })
            .opacity(this.opacityValue)
            .onClick(() => {
              animateTo({
                duration: 300,
                curve: Curve.EaseOut
              }, () => {
                this.opacityValue = 0
                this.scaleValue = 0.8
              })
              setTimeout(() => {
                this.showDialog = false
              }, 300)
            })
            .zIndex(2)

          // 对话框内容
          Column() {
            Text('摘要')
              .fontSize(18)
              .margin({ bottom: 16 })

            TextArea({ text:this.summary,placeholder: '输入摘要'})

              .onChange((value: string) => {
                // this.summary = value
                this.selectedText[6] = value
              })
              .height(150)
              .width('100%')
              .border({
                width: 2,                     // 边框宽度
                color: '#4CAF50',             // 边框颜色
                radius: 8,                    // 圆角半径

              })

            Row({space:100}) {
              Button('取消', {type: ButtonType.Normal})
                .onClick(() => { this.showDialog = false })
                .backgroundColor('#ffffffff')
                .fontColor('#ff706f6f')
              Button('确定', {type: ButtonType.Normal})
                .backgroundColor('#ffffffff')
                .fontColor('#5BC043')
                .onClick(() => { this.showDialog = false })
            }
          }
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .width('80%')
          .position({ x: '11%', y: '30%' })
          .opacity(this.opacityValue)
          .scale({ x: this.scaleValue, y: this.scaleValue })
          .animation({
            duration: 300,
            curve: Curve.EaseOut
          })
          .zIndex(2)
        }
        // 底部按钮部分
        Column() {
          Row() {
            Text('总计：*元')
              .fontColor('#8A96A2')
              .fontSize(16)
              .margin({ right: 10 })

            Button({type: ButtonType.Normal}){
              Text('保存')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .height(35)
            .backgroundColor('#02BC65')
            .fontColor(Color.White)
            .borderRadius(8)
            .width('auto')
            .padding({ left: 15, right: 15 })

            Button({type: ButtonType.Normal}){
              Text('保存上报')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .onClick(() => {
              this.submitForm();

            })
            .height(35)
            .backgroundColor('#02BC65')
            .fontColor(Color.White)
            .borderRadius(8)
            .width('auto')
            .padding({ left: 15, right: 15 })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: 20 })
        }
        .padding(10)
        .zIndex(1)
      }}

  }

  @Builder
  buildLabelRow(iconResource: Resource, label: string, showAsterisk: boolean, index: number) {
    Column() {
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
          // 使用固定宽度容器包裹 Text 组件

          if (label === "摘要") {
            Column() {
              Text(this.selectedText[index] === '请输入摘要' ? '请输入摘要' :
                `${this.selectedText[index].substring(0, 10)}${this.selectedText[index].length > 10 ? '...' : ''}`)
                .fontSize(14)
                .fontColor(this.selectedText[index] === '请输入摘要' ? '#000000' : '#000000')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('250px')

            }
            .alignItems(HorizontalAlign.End)
          } else {
            Text(this.selectedText[index])
              .fontSize(14)
              .fontColor('#000000')
          }


          Image($r("app.media.ic_arrow_right"))
            .width(20)
            .height(20)
            .margin({ left: 5 })
            .fillColor('#8A96A2')
        }

        .justifyContent(FlexAlign.End) // 确保文本和箭头靠右对齐

        .onClick(() => {
          switch (label){
            case "需求单位":
              this.showTextDialog(this.unitOptions,0)
              break;
            case "供应日期":
              this.showDateDialog()
              break;
            case "供应时间":
              this.showTextDialog(this.selectedTime,2)
              break;
            case "需求类型":
              this.showTextDialog(this.demandOptions,3)
              break;
            case "用餐类型":
              this.showTextDialog(this.mealTypeOptions,4)
              break;
            case "餐别":
              this.showTextDialog(this.mealOptions,5)
              break;
            case "摘要":
              this.summary = this.selectedText[6] === '请输入摘要' ? '' : this.selectedText[6]
              this.showDialog = true
              this.opacityValue = 1
              this.scaleValue = 1
              break;

          }
        })      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .height(40)
      .padding({ right: 10 })

      // 添加横线
      Divider()
        .strokeWidth(1)
        .color('#ffb1afaf')
        .margin({ top: 0, bottom: 7 })
    }
    .width('100%')
  }
  //日历函数

  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth()+1
        const day = value.day ?? new Date().getDate()
        this.selectDate = new Date(year, month-1 , day)
        this.selectedText[1] = `${year}-${(month+1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

  private showTextDialog(array:string[],index:number) {
    TextPickerDialog.show({
      range: array,
      selected: array.findIndex(item => item === this.selectedText[index]),
      canLoop:false,
      onAccept: (value: TextPickerResult) => {
        // 安全写法：添加双重验证
        if (typeof value.index === 'number' &&
          value.index < array.length) {
          this.selectedText[index] = array[value.index]
        }
        switch (index){
          case 3:
            if(this.selectedText[index] === '学生餐')
              this.showMealType = true
            else{
              this.showMealType = false
              this.selectedText[4] = '请选择'
            }
            break;
          case 4:
            this.showMealType = true
            break;
          default :
            if(!this.showMealType){
              this.showMealType = false
              this.selectedText[4] = '请选择'
            }
            break;

        }
      }

    })
  }

  private submitForm() {
    // 验证必填项
    if (!this.selectedText[1] ||
      !this.selectedText[1] ||
      !this.selectedText[3] ||
      !this.selectedText[5]) {
      prompt.showToast({
        message: '请填写所有必填项',
        duration: 2000
      });
      return;
    }

    prompt.showToast({
      message: '保存成功',
      duration: 2000
    });

    // 创建表单数据对象
    let formData: GeneratedObjectLiteralInterface_1 = {
      date: this.selectedText[1],
      recipeName: this.selectedText[1], // 使用已选择的日期
      mealType: this.selectedText[3],   // 使用已选择的餐别
      diningType: this.selectedText[4], // 用餐类型
      place: this.selectedText[5],      // 需求单位
      photoUri: this.selectedText[5]    // 餐别（如果需要）
    };

    // 跳转到 'uploadPlan' 页面并传递 formData
    router.pushUrl ({
      url: 'pages/uploadPlan',  // 页面路径
      params: formData          // 传递的参数
    });
  }


}