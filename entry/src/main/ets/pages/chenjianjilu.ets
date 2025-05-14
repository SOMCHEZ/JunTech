import router from '@ohos.router'
import http from '@ohos.net.http'
import promptAction from '@ohos.promptAction'

// 接口响应类型定义
interface CheckRecord {
  id: string
  personName: string
  unitName: string
  temperature: number
  health: string
  healthStr: string
  checkDate: string
  checkDayTime: string
  pictureImg: string
  pictureBackImg: string
  sceneImg: string
  healthCertificateState: number
  healthCertificateStateStr: string
  riskTypeOne: number
  riskTypeOneStr: string
  riskTypeTwo: number
  riskTypeTwoStr: string
  state: string
}

interface GeneratedTypeLiteralInterface_1 {
  records: CheckRecord[];
  total: number;
  size: number;
  current: number;
  pages: number;
}

interface ApiResponse {
  code: number
  message: string
  success: boolean
  result: GeneratedTypeLiteralInterface_1
}

interface RouterParams {
  token: string
  relTenantIds: string | number
}

interface GeneratedObjectLiteralInterface_1 {
  total: number;
  checked: number;
  unchecked: number;
  unqualified: number;
}

interface GeneratedObjectLiteralInterface_2 {
  pageNo: number;
  pageSize: number;
  checkDayTime: string;
  startTime: string;
  endTime: string;
}

@Entry
@Component
struct CalendarPage {
  @State private currentDate: Date = new Date()
  @State private selectedDate: Date = new Date()
  @State private selectedTab: number = 0 // 0:全部 1:晨检 2:午检 3:晚检
  @State private loading: boolean = false
  @State private records: CheckRecord[] = []
  @State private stats: GeneratedObjectLiteralInterface_1 = {
    total: 0,
    checked: 0,
    unchecked: 0,
    unqualified: 0
  }
  @State private message: string = ''

  private weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六']
  private tabList: string[] = ['全部', '晨检', '午检', '晚检']
  private token: string = ''
  private tenantId: string | number = 0
  private httpRequest: http.HttpRequest | null = null

  aboutToAppear() {
    try {
      const params = router.getParams() as RouterParams
      console.info('Router params:', JSON.stringify(params))
      if (params) {
        this.token = params.token
        this.tenantId = params.relTenantIds
        if (!this.token || !this.tenantId) {
          this.message = '缺少必要的认证信息'
          promptAction.showToast({
            message: this.message,
            duration: 2000
          })
          return
        }
        this.fetchRecords()
      }
    } catch (error) {
      console.error('Router params error:', error.message)
      this.message = '参数错误'
      promptAction.showToast({
        message: this.message,
        duration: 2000
      })
    }
  }

  aboutToDisappear() {
    if (this.httpRequest) {
      this.httpRequest.destroy()
      this.httpRequest = null
    }
  }

  /**
   * 格式化日期为 YYYY-MM-DD 格式
   */
  private formatDate(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
  }

  /**
   * 获取当前选中周的所有日期
   */
  private getDatesForWeek(): number[] {
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

  /**
   * 更改选中的周并重新获取数据
   */
  private async changeWeek(increment: number) {
    const newDate = new Date(this.selectedDate)
    newDate.setDate(this.selectedDate.getDate() + (increment * 7))
    this.currentDate = new Date(newDate)
    this.selectedDate = newDate
    await this.fetchRecords()
  }

  /**
   * 获取晨检记录数据和统计信息
   */
  private async fetchRecords() {
    if (!this.token || !this.tenantId) {
      console.error('Missing token or tenantId')
      return
    }

    this.loading = true
    try {
      // 创建请求对象
      this.httpRequest = http.createHttp()

      // 获取检查类型
      const checkDayTime = this.selectedTab === 0 ? '' :
        this.selectedTab === 1 ? '晨检' :
          this.selectedTab === 2 ? '午检' : '晚检'

      // 构建请求参数
      const queryParams: GeneratedObjectLiteralInterface_2 = {
        pageNo: 1,
        pageSize: 100,
        checkDayTime: checkDayTime,
        startTime: this.formatDate(this.selectedDate),
        endTime: this.formatDate(this.selectedDate)
      }

      // 构建URL
      const baseUrl = 'https://api.suoeryun.com/ifood/jeecg-school/school/xxUnitCheckdata/list'
      const queryString = Object.entries(queryParams)
        .filter((entry: [string, string | number]) => entry[1] !== '')


        .filter((entry: [string, string | number]) => entry[1] !== '')


        .join('&')
      const requestUrl = `${baseUrl}?${queryString}`

      // 发送请求
      const response = await this.httpRequest.request(
        requestUrl,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'tenant-id': this.tenantId.toString(),
            'X-Access-Token': this.token,

          },
          connectTimeout: 60000,
          readTimeout: 60000,
          expectDataType: http.HttpDataType.STRING
        }
      )
      console.log('aaa',this.tenantId);
      console.log('code',response.responseCode);
      console.log('code',response.result);
      console.info('API Response:', response.result)



      if (response.responseCode === http.ResponseCode.OK) {
        const jsonStr = typeof response.result === 'string' ? response.result : JSON.stringify(response.result);
        const data: ApiResponse = JSON.parse(jsonStr);

        if (data.success) {
          // 更新记录列表
          this.records = data.result.records || []

          // 更新统计数据
          this.stats = {
            total: data.result.total || 0,
            checked: this.records.length,
            unchecked: (data.result.total || 0) - this.records.length,
            unqualified: this.records.filter(r => r.health === '1').length
          }

          this.message = ''
          console.info('Records fetched successfully:', this.records.length)
        } else {
          if (data.code === 401) {
            this.message = '登录已过期，请重新登录'
            promptAction.showToast({
              message: this.message,
              duration: 2000
            })
            router.back()
          } else {
            this.message = data.message || '获取数据失败'
            promptAction.showToast({
              message: this.message,
              duration: 2000
            })
          }
        }
      } else {
        this.message = '网络请求失败'
        promptAction.showToast({
          message: this.message,
          duration: 2000
        })
      }
    } catch (error) {
      this.message = '网络请求失败'
      console.error('Fetch records failed:', error)
      promptAction.showToast({
        message: this.message,
        duration: 2000
      })
    } finally {
      this.loading = false
      if (this.httpRequest) {
        this.httpRequest.destroy()
        this.httpRequest = null
      }
    }
  }

  @Builder
  private CalendarHeaderBuilder() {
    Row() {
      Text(`${this.currentDate.getFullYear()}年${this.currentDate.getMonth() + 1}月`)
        .fontSize(24)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
      Blank()
      Row() {
        Text('<')
          .fontSize(24)
          .fontColor('#FFFFFF')
          .margin({ right: 20 })
          .onClick(() => this.changeWeek(-1))
        Text('>')
          .fontSize(24)
          .fontColor('#FFFFFF')
          .onClick(() => this.changeWeek(1))
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor('#00C853')
  }

  @Builder
  private WeekDaysBuilder() {
    Row() {
      ForEach(this.weekDays, (day: string) => {
        Text(day)
          .fontSize(15)
          .width('14.28%')
          .textAlign(TextAlign.Center)
          .fontColor('#FFFFFF')
      })
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }

  @Builder
  private TabButtonRowBuilder() {
    Row() {
      Row() {
        ForEach(this.tabList, (tab: string, idx: number) => {
          Text(tab)
            .fontSize(13)
            .fontColor(this.selectedTab === idx ? '#FFFFFF' : '#000000')
            .backgroundColor(this.selectedTab === idx ? '#00C853' : '#E5E5E5')
            .border({ color: this.selectedTab === idx ? '#00C853' : '#FFFFFF', width: 1 })
            .borderRadius(4)
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })
            .margin({ right: 2 })
            .onClick(async () => {
              this.selectedTab = idx
              await this.fetchRecords()
            })
        })
      }
      .layoutWeight(1)
      Blank()
      Text('未晨检人员 >')
        .fontSize(16)
        .fontColor('#00C853')
        .onClick(() => {
          router.pushUrl({
            url: 'pages/weichenjianrenyuan',
            params: {
              token: this.token,
              relTenantIds: this.tenantId,
              date: this.formatDate(this.selectedDate)
            }
          })
        })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor('#FFFFFF')
    .borderRadius({ topLeft: 16, topRight: 16, bottomLeft: 0, bottomRight: 0 })
    .margin({ top: 0 })
  }

  @Builder
  private StatsRowBuilder() {
    Row() {
      Column() {
        Text('总人数')
          .fontSize(12)
          .fontColor('#666666')
        Text(this.loading ? '...' : `${this.stats.total}`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222222')
      }
      .width('25%')
      .alignItems(HorizontalAlign.Center)

      Column() {
        Text('已检测')
          .fontSize(12)
          .fontColor('#666666')
        Text(this.loading ? '...' : `${this.stats.checked}`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#00C853')
      }
      .width('25%')
      .alignItems(HorizontalAlign.Center)

      Column() {
        Text('未检测')
          .fontSize(12)
          .fontColor('#666666')
        Text(this.loading ? '...' : `${this.stats.unchecked}`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF9800')
      }
      .width('25%')
      .alignItems(HorizontalAlign.Center)

      Column() {
        Text('不合格')
          .fontSize(12)
          .fontColor('#666666')
        Text(this.loading ? '...' : `${this.stats.unqualified}`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#F44336')
      }
      .width('25%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .padding({ top: 12, bottom: 12, left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .border({ width: { bottom: 1 }, color: '#EEEEEE' })
  }

  @Builder
  private RecordListBuilder() {
    List() {
      ForEach(this.records, (record: CheckRecord) => {
        ListItem() {
          Column() {
            Row() {
              Text(record.personName)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
              Blank()
              Text(record.state || '在职')
                .fontSize(14)
                .fontColor(record.state === '在职' ? '#00C853' : '#FF5722')
                .backgroundColor(record.state === '在职' ? '#E8F5E9' : '#FBE9E7')
                .borderRadius(4)
                .padding({ left: 8, right: 8, top: 2, bottom: 2 })
            }
            .width('100%')
            .padding({ bottom: 8 })

            Row() {
              Text(`体温: ${record.temperature}℃`)
                .fontSize(14)
                .fontColor(record.temperature > 37.3 ? '#FF0000' : '#666666')
              Blank()
              Text(record.healthStr)
                .fontSize(14)
                .fontColor(record.health === '0' ? '#00C853' : '#FF0000')
            }
            .width('100%')

            if (record.pictureImg || record.pictureBackImg || record.sceneImg) {
              Row() {
                if (record.pictureImg) {
                  Image(record.pictureImg)
                    .width(80)
                    .height(80)
                    .objectFit(ImageFit.Cover)
                    .borderRadius(4)
                    .margin({ right: 8 })
                }
                if (record.pictureBackImg) {
                  Image(record.pictureBackImg)
                    .width(80)
                    .height(80)
                    .objectFit(ImageFit.Cover)
                    .borderRadius(4)
                    .margin({ right: 8 })
                }
                if (record.sceneImg) {
                  Image(record.sceneImg)
                    .width(80)
                    .height(80)
                    .objectFit(ImageFit.Cover)
                    .borderRadius(4)
                }
              }
              .margin({ top: 8 })
            }
          }
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .margin({ bottom: 8 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/checkrecorddetail',
              params: {
                id: record.id,
                token: this.token,
                relTenantIds: this.tenantId
              }
            })
          })
        }
      })
    }
    .width('100%')
    .layoutWeight(1)
    .padding({ left: 16, right: 16 })
  }

  build() {
    Column() {
      // 日历头部
      this.CalendarHeaderBuilder()

      // 日历主体
      Column() {
        this.WeekDaysBuilder()
        Row() {
          ForEach(this.getDatesForWeek(), (date: number) => {
            Column() {
              Stack() {
                if (date === this.selectedDate.getDate()) {
                  Circle()
                    .width(40)
                    .height(40)
                    .fill('#FFFFFF')
                }
                Text(`${date < 10 ? '0' : ''}${date}`)
                  .fontSize(18)
                  .fontColor(date === this.selectedDate.getDate() ? '#00C853' : '#FFFFFF')
              }
            }
            .width('14.28%')
            .height(50)
            .justifyContent(FlexAlign.Center)
            .onClick(async () => {
              const newDate = new Date(this.selectedDate)
              newDate.setDate(date)
              this.selectedDate = newDate
              await this.fetchRecords()
            })
          })
        }
        .width('100%')
        .padding({ bottom: 16 })
      }
      .width('100%')
      .backgroundColor('#00C853')

      // 选项卡和统计
      this.TabButtonRowBuilder()
      this.StatsRowBuilder()

      if (this.message) {
        Row() {
          Text(this.message)
            .fontSize(14)
            .fontColor('#F44336')
            .backgroundColor('#FFEBEE')
            .padding(8)
            .borderRadius(4)
        }
        .width('100%')
        .padding(16)
        .justifyContent(FlexAlign.Center)
      }

      // 记录列表区域
      Refresh({ refreshing: this.loading, offset: 120, friction: 100 }) {
        Column() {
          if (this.loading) {
            LoadingProgress()
              .width(50)
              .height(50)
              .margin({ top: 20 })
          } else if (this.records.length === 0) {
            Row() {
              Column() {
                Image($r('app.media.about'))
                  .width(120)
                  .height(120)
                  .margin({ bottom: 12 })
                Text('暂无相关数据')
                  .fontSize(16)
                  .fontColor('#999999')
              }
              .width('100%')
              .margin({ top: 80 })
              .alignItems(HorizontalAlign.Center)
            }
            .width('100%')
          } else {
            this.RecordListBuilder()
          }
        }
        .width('100%')
        .layoutWeight(1)
      }
      .onRefreshing(async () => {
        await this.fetchRecords()
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}