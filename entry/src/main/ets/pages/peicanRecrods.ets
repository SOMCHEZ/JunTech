import { router } from '@kit.ArkUI'

@Entry
@Component
struct CalendarPage {
  @State private currentDate: Date = new Date()
  @State private selectedDate: Date = new Date()
  private weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六']

  // 获取当前周的日期数组
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

  // 周切换功能
  private changeWeek(increment: number) {
    const newDate = new Date(this.selectedDate)
    newDate.setDate(this.selectedDate.getDate() + (increment * 7))
    this.currentDate = new Date(newDate)
    this.selectedDate = newDate
  }

  // 日历头部
  @Builder
  private CalendarHeaderBuilder() {
    Column() {
      // 新增配餐记录标题
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

  // 星期标题行
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
    //.padding({ vertical: 8 })
  }

  build() {
    Column() {
      // 头部区域
      this.CalendarHeaderBuilder()

      // 日历主体
      Column() {
        this.WeekDaysBuilder()

        // 日期行
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
            .width('14.28%')
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

      // 底部上传按钮
      Button('上传陪餐记录', { type: ButtonType.Capsule })
        .width('90%')
        .height(40)
        .backgroundColor('#00C853')
        .fontColor('#FFFFFF')
        .position({x:20 , y: '90%'})
        .onClick(() => {
                  router.pushUrl({
                     url: 'pages/sad',
                  });
        })

      // 暂无数据提示
      Text('~ 暂无相关数据 ~')
        .fontSize(15)
        .fontColor('#BBBBBB')
        .margin({ top: 30 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}