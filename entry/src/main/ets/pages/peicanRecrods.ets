import { router } from '@kit.ArkUI'

interface RecordType {
  unit: string;
  meal: string;
  position: string;
  name: string;
  evaluation: string;
  date: string;
}

interface GeneratedTypeLiteralInterface_1 {
  record?: string;
}

@Entry
@Component
struct CalendarPage {
  @State private currentDate: Date = new Date()
  @State private selectedDate: Date = new Date()
  @State records: RecordType[] = []
  private weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六']

  aboutToAppear() {
    const params = router.getParams() as GeneratedTypeLiteralInterface_1;
    if (params?.record) {
      this.records.unshift(JSON.parse(params.record));
      router.getParams(); // 确保清除参数
    }
  }


  private getDatesForWeek(): number[] {
    const firstDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), 1)
    const lastDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 0)
    const currentDayOfWeek = this.selectedDate.getDay()
    const startDate = new Date(this.selectedDate)
    startDate.setDate(this.selectedDate.getDate() - currentDayOfWeek)

    const dates: number[] = []
    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate)
      currentDate.setDate(startDate.getDate() + i)
      dates.push(currentDate.getDate())
    }
    return dates
  }

  private changeWeek(increment: number) {
    const newDate = new Date(this.selectedDate)
    newDate.setDate(this.selectedDate.getDate() + (increment * 7))
    this.currentDate = new Date(newDate)
    this.selectedDate = newDate
  }

  @Builder
  private CalendarHeaderBuilder() {
    Column() {
      Text('陪餐记录')
        .fontSize(24)
        .fontColor('#FFFFFF')
        .margin({ bottom: 8 })

      Row() {
        Text(`${this.currentDate.getFullYear()}年${this.currentDate.getMonth() + 1}月`)
          .fontSize(20)
          .fontColor('#FFFFFF')
        Blank()
        Row() {
          Text('<')
            .font({size: 24})
            .onClick(() => this.changeWeek(-1))
            .fontColor(Color.White)
          Text('>')
            .fontSize(24)
            .margin({ left: 20 })
            .onClick(() => this.changeWeek(1))
            .fontColor(Color.White)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#00C853')
  }

  @Builder
  private WeekDaysBuilder() {
    Row() {
      ForEach(this.weekDays, (day: string) => {
        Text(day)
          .width('14.28%')
          .textAlign(TextAlign.Center)
          .fontColor('#FFFFFF')
      })
    }
  }

  // ... (其他代码保持不变)

  @Builder
  private RecordCardBuilder(record: RecordType) {
    Column() {
      Row() {
        Text(record.date).fontColor('#666').fontSize(14)
        Text(record.unit).fontColor('#333').fontSize(16).margin({ left: 10 })
      }
      .justifyContent(FlexAlign.Start)

      Row() {
        Text(`餐别：${record.meal}`).fontSize(14)
        Text(`身份：${record.position}`).margin({ left: 15 }) // 确保这里显示的是字符串值
      }
      .margin({ top: 8 })

      Text(`姓名：${record.name}`).fontSize(14).margin({ top: 4 })
      Text(`评价：${record.evaluation}`).fontSize(14).margin({ top: 4 })
    }
    .padding(10)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ top: 10 })
    .width('90%')
    .shadow({ radius: 4, color: '#30000000', offsetX: 1, offsetY: 1 })
  }

  // ... (其他代码保持不变)



  build() {
    Column() {
      this.CalendarHeaderBuilder()

      Column() {
        this.WeekDaysBuilder()

        Row() {
          ForEach(this.getDatesForWeek(), (date: number) => {
            Column() {
              Stack() {
                if (date === this.selectedDate.getDate()) {
                  Circle()
                    .size({width:20 , height:20 })
                    .fill('#FFFFFF')
                }
                Text(`${date.toString().padStart(2, '0')}`)
                  .fontColor(date === this.selectedDate.getDate() ? '#00C853' : '#FFFFFF')
              }
            }
            .width('14.282039094572344908579867648657%')
            .height(50)
            .onClick(() => {
              const newDate = new Date(this.selectedDate)
              newDate.setDate(date)
              this.selectedDate = newDate
            })
          })
        }
      }
      .backgroundColor('#00C853')

      Button('上传陪餐记录', { type: ButtonType.Capsule })
        .width('90%')
        .height(40)
        .backgroundColor('#00C853')
        .fontColor('#FFFFFF')
        .position({x:20 , y: '90%'})
        .onClick(() => {
          router.pushUrl({
            url: 'pages/reportRecords',
          });
        })

      if (this.records.length === 0) {
        Text('~ 暂无相关数据 ~')
          .fontSize(15)
          .fontColor('#BBBBBB')
          .margin({ top: 30 })
      } else {
        Scroll() {
          Column() {
            ForEach(this.records, (record: RecordType) => {
              this.RecordCardBuilder(record)
            })
          }
        }
        .height('30%')
        .margin({ top: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}