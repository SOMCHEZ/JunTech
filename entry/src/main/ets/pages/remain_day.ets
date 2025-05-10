import router from '@ohos.router';
@Entry
@Component
struct CalendarPage {
  // 当前显示的月份和年份（响应式状态变量）
  @State private currentDate: Date = new Date()
  // 当前选中的日期（响应式状态变量）
  @State private selectedDate: Date = new Date()
  private weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六']
  @State private selectedTab: number = 0 // 0:全部 1:晨检 2:午检 3:晚检
  private tabList: string[] = ['全部', '晨检', '午检', '晚检']
  private (date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
  }


  private getDatesForWeek(): number[] {
    // 计算当月第一天
    const firstDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), 1)
    // 计算当月最后一天
    const lastDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 0)

    // 获取当前选中日期的星期几（0-6，0表示星期日）
    const currentDayOfWeek = this.selectedDate.getDay()

    // 计算当前选中日期所在周的第一天（星期日）
    const startDate = new Date(this.selectedDate)
    startDate.setDate(this.selectedDate.getDate() - currentDayOfWeek)

    // 生成当前周的日期数组
    const dates: number[] = []
    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate)
      currentDate.setDate(startDate.getDate() + i)
      dates.push(currentDate.getDate())
    }
    return dates
  }


  private changeWeek(increment: number) {
    // 计算新日期（当前日期 ± 增量周数）
    const newDate = new Date(this.selectedDate)
    newDate.setDate(this.selectedDate.getDate() + (increment * 7))

    // 更新月份和年份显示
    this.currentDate = new Date(newDate)
    this.selectedDate = newDate
  }

  @Builder
  private CalendarHeaderBuilder() {
    Row() {
      // 显示当前年月
      Text(`${this.currentDate.getFullYear()}年${this.currentDate.getMonth() + 1}月`)
        .fontSize(24)
        .fontWeight(FontWeight.Medium)
        .fontColor('#ffffffff')
      Blank()
      // 周切换按钮
      Row() {
        Text('<') // 上一周按钮
          .fontSize(24)
          .fontColor('#ffffffff')
          .margin({ right: 20 })
          .onClick(() => this.changeWeek(-1))
        Text('>') // 下一周按钮
          .fontSize(24)
          .fontColor('#ffffffff')
          .onClick(() => this.changeWeek(1))
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor('#00C853')
  }

  //构建星期标题行
  @Builder
  private WeekDaysBuilder() {
    Row() {
      // 渲染星期文本（一至日）
      ForEach(this.weekDays, (day: string) => {
        Text(day)
          .fontSize(15)
          .width('14.28%') // 平均分配宽度（100%/7）
          .textAlign(TextAlign.Center)
          .fontColor('#ffffffff')
      })
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }

  /**
   * 组件构建方法
   */
  build() {
    Column() {
      // 渲染日历头部
      this.CalendarHeaderBuilder()
      // 日历内容绿色区域
      Column() {
        // 渲染星期标题行
        this.WeekDaysBuilder()
        // 渲染日期选择行
        Row() {
          ForEach(this.getDatesForWeek(), (date: number) => {
            Column() {
              Stack() {
                // 选中日期高亮背景
                if (date === this.selectedDate.getDate()) {
                  Circle()
                    .width(40)
                    .height(40)
                    .fill('#ffffffff')
                }
                // 日期文本（选中日期使用主题色，未选中使用白色）
                Text(`${date < 10 ? '0' : ''}${date}`)
                  .fontSize(18)
                  .fontColor(date === this.selectedDate.getDate() ? '#00C853' : '#FFFFFF')
              }
            }
            .width('14.28%') // 平均分配宽度（100%/7）
            .height(50)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              // 更新选中日期
              const newDate = new Date(this.selectedDate)
              newDate.setDate(date)
              this.selectedDate = newDate
            })
          })
        }
        .width('100%')
        .padding({ bottom: 16 })
      }
      .width('100%')
      .backgroundColor('#00C853') // 绿色背景只包裹日历内容

      Column() {
        Column() {
          Text('~暂无相关数据~')
            .margin({top: 16})
            .fontSize(15)
            .fontColor('#BBBBBB')
        }
        .layoutWeight(1)
      }
      .width('100%')
      .layoutWeight(1)

      Button('新增留样')
        .width('90%')
        .height(50)
        .fontSize(16)
        .fontColor('#ffffffff')
        .backgroundColor('#00C853')
        .margin({ bottom: 16 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/remain'
          });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
