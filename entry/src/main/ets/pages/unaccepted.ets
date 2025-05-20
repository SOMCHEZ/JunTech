import router from '@ohos.router';
@Entry
@Component
struct Daijiedan {

  @State x: number = 0
  @State s: number = 0
  @State selectedDate: string = '请选择供应日期'
  @State selectDate: Date = new Date()
  @State upload:boolean  = false;
  build() {
    Column() {
      Column() {
        Row() {
          Button('待接单')
            .width('50%')
            .height(40)
            .backgroundColor(this.x === 0 ? '#E8F5E9' : '#F5F5F5')
            .fontColor(this.x === 0 ? '#07C160' : '#666666')
            .fontWeight(this.x === 0 ? FontWeight.Bold : FontWeight.Normal)
            .borderRadius(1)// 去除圆角
            .borderWidth(0)// 去除边框
            .onClick(() => {
              this.x = 0
              this.upload = false
            })

          Button('已接单')
            .width('50%')
            .height(40)
            .backgroundColor(this.x === 1 ? '#E8F5E9' : '#F5F5F5')
            .fontColor(this.x === 1 ? '#07C160' : '#666666')
            .fontWeight(this.x === 1 ? FontWeight.Bold : FontWeight.Normal)
            .borderRadius(1)
            .borderWidth(0)
            .onClick(() => {
              this.x = 1
              this.upload = true
            })
        }
      }
      .width('100%')
      .margin({ bottom: 20 })
      .height('5%')

      Divider()
        .color('#cccccc')// 分界线颜色
        .strokeWidth(1)// 分界线粗细
        .margin({ top: 5, bottom: 5 }) // 上下边距
        .height('1%')

      Select([])
        .value(this.selectedDate)
        .onClick(() => {
          this.showDateDialog()
        })
        .margin({ top: 10, right: 200, bottom: 20 })
        .width('40%')
        .height('5%')
        .font({ size: 12 })
      Column() {
        if (this.x === 0) {
          Column() {
            Text('实训第二学校 ')
              .width('50%')
              .fontSize(25)
              .fontWeight(700)
              .margin({ bottom: 10 })
            Row({ space: 20 }) {
              Text('供应时间:')
                .fontWeight(400)
              Text('2025-05-19下午')
                .fontWeight(400)
            }
            .margin({ bottom: 10 })

            Text('下单人:')
              .fontWeight(400)
              .margin({ bottom: 10 })
            Text('下单电话:')
              .fontWeight(400)
              .margin({ bottom: 10 })
            Row({ space: 20 }){
              Text('摘       要:')
                .fontWeight(400)
              Text('123')
                .fontWeight(400)
            }
            Column(){
              Text('确认接单')
                .fontSize(18)
                .fontWeight(700)
                .fontColor('#16B76A')
                .onClick(()=>{
                  this.x = 1
                  this.upload = true
                })
                .margin({top:8})

            }.backgroundColor('#F5F5F5' )
            .borderRadius(4)
            .width(120)
            .height(35)
            .margin({left:200,top:-20})
          }
          .width('98%')
          .alignItems(HorizontalAlign.Start)
          .padding(20)
          .borderWidth(2)
          .backgroundColor(Color.White)
          .borderColor('#16B76A')
          .borderRadius(7)
          .justifyContent(FlexAlign.SpaceBetween)
          .shadow({
            radius: 10,
            color: '#16B76A',
            offsetX: 0,
            offsetY: 4
          })
        }else{
          Column() {
            Text('实训第二学校 ')
              .width('50%')
              .fontSize(25)
              .fontWeight(700)
              .margin({ bottom: 10 })
            Row({space: 20}){
              Text('单 据 号:')
                .fontWeight(400)
              Text('XQ20250509005')
                .fontWeight(400)
            }.margin({ bottom: 10 })
            Row({ space: 20 }) {
              Text('供应时间:')
                .fontWeight(400)
              Text('2025-05-19下午')
                .fontWeight(400)
            }
            .margin({ bottom: 10 })
            Row({ space: 20 }){
              Text('需求单位:')
                .fontWeight(400)
              Text('实训第二学校(库房)')
                .fontWeight(400)
            }.margin({ bottom: 10 })
            Row({ space: 20 }){
              Text('摘       要:')
                .fontWeight(400)
              Text('123')
              .fontWeight(400)
            }
          }
          .width('98%')
          .alignItems(HorizontalAlign.Start)
          .padding(20)
          .borderWidth(2)
          .backgroundColor(Color.White)
          .borderColor('#16B76A')
          .borderRadius(7)
          .justifyContent(FlexAlign.SpaceBetween)
          .shadow({
            radius: 10,
            color: '#16B76A',
            offsetX: 0,
            offsetY: 4
          })
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/order'
            });
          })
        }
      }
    }

  }
  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        // 使用可选链和默认值保证安全性
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth()+1
        const day = value.day ?? new Date().getDate()

        this.selectDate = new Date(year, month , day)
        this.selectedDate = `${year}-${(month+1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;

      }

    })
  }
}