import { router } from '@kit.ArkUI'

@Entry
@Component
struct CalendarPage {
  // 当前显示的月份和年份（响应式状态变量）
  @State private currentDate: Date = new Date()
  // 当前选中的日期（响应式状态变量）
  @State private selectedDate: Date = new Date()
  // 星期显示文本
  private weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六']
  @State private selectedTab: number = 0 // 0:全部 1:晨检 2:午检 3:晚检
  private tabList: string[] = ['全部', '晨检', '午检', '晚检']
  /**
   * 格式化日期为 YYYY-MM-DD 格式
   * @param date - 需要格式化的日期对象
   * @returns 格式化后的日期字符串
   */
  private (date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
  }

  /**
   * 获取当前选中周的所有日期
   * @returns 包含7个日期数字的数组
   */
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

  /**
   * 更改选中的周
   * @param increment - 增量值，负数表示上一周，正数表示下一周
   */
  private changeWeek(increment: number) {
    // 计算新日期（当前日期 ± 增量周数）
    const newDate = new Date(this.selectedDate)
    newDate.setDate(this.selectedDate.getDate() + (increment * 7))

    // 更新月份和年份显示
    this.currentDate = new Date(newDate)
    this.selectedDate = newDate
  }

  /**
   * 构建日历头部（显示年月和周切换按钮）
   */
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

  /**
   * 构建星期标题行
   */
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
   * 构建底部按钮行
   * 包含"全部、晨检、午检、晚检"四个切换按钮，靠左排列，点击高亮；
   * 右侧为"未晨检人员>"跳转按钮。
   * 整体底部白色横条，按钮间距紧凑，样式与日历区域分层。
   */
  @Builder
  private TabButtonRowBuilder() {
    Row() {
      // 左侧按钮组
      Row() {
        ForEach(this.tabList, (tab: string, idx: number) => {
          // 渲染每个切换按钮，选中高亮，未选中灰边
          Text(tab)
            .fontSize(13)
            .fontColor(this.selectedTab === idx ? '#ffffffff' : '#ff000000')
            .backgroundColor(this.selectedTab === idx ? '#00C853' : '#ffe5e5e5')
            .border({ color: this.selectedTab === idx ? '#00C853' : '#ffffffff', width: 1 })
            .borderRadius(4)
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })
            .margin({ right: 2 })
            .onClick(() => { this.selectedTab = idx })
        })
      }
      .layoutWeight(1)
      // 右侧"未晨检人员>"按钮
      Blank()
      Text('未晨检人员 >')
        .fontSize(16)
        .fontColor('#00C853')
        .onClick(() => {
          router.push({ url: 'pages/weichenjianrenyuan' })
        })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor('#ffffffff') // 底部白色横条
    .borderRadius({ topLeft: 16, topRight: 16, bottomLeft: 0, bottomRight: 0 })
    .margin({ top: 0 })
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
      // 渲染底部按钮行
      this.TabButtonRowBuilder()
      // 渲染统计信息行
      Row() {
        Text('总人数：0人')
          .fontSize(11)
          .fontColor('#222222')
        Blank()
        Text('已检测：0人')
          .fontSize(11)
          .fontColor('#222222')
        Blank()
        Text('未检测：0人')
          .fontSize(11)
          .fontColor('#222222')
        Blank()
        Text('不合格：0人')
          .fontSize(11)
          .fontColor('#222222')
      }
      .width('100%')
      .padding({ top: 8, bottom: 8, left: 8, right: 8 })
      .backgroundColor('#F8F8F8')
      // 添加暂无数据提示
      Row() {
        Blank()
        Text('~暂无相关数据~')
          .fontSize(15)
          .fontColor('#BBBBBB')
        Blank()
      }
      .width('100%')
      .padding({ top: 16, bottom: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}