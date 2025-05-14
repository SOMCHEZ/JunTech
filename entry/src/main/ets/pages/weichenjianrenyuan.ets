import { router } from '@kit.ArkUI'
import http from '@ohos.net.http'
import promptAction from '@ohos.promptAction'

// 接口响应类型定义
interface StaffRecord {
  id: string
  personName: string
  position: string
  idCard: string
  healthCertificateState: number
  healthCertificateStateStr: string
  createTime: string
  state: string
  unitName: string
  pictureImg?: string
  pictureBackImg?: string
  sceneImg?: string
}

interface GeneratedTypeLiteralInterface_1 {
  records: StaffRecord[];
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
  date: string
}

@Entry
@Component
struct Chenjian1Page {
  @State staffList: StaffRecord[] = []
  @State loading: boolean = false
  private token: string = ''
  private tenantId: string | number = 0
  private date: string = ''
  private httpRequest: http.HttpRequest | null = null


  aboutToAppear() {
    try {
      const params = router.getParams() as RouterParams
      console.info('Router params:', JSON.stringify(params))
      if (params) {
        this.token = params.token
        this.tenantId = params.relTenantIds
        this.date = params.date
        this.getStaffList()
      }
    } catch (error) {
      console.error('Router params error:', error.message)
      promptAction.showToast({
        message: '参数错误',
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

  private async getStaffList() {
    if (!this.token || !this.tenantId || !this.date) {
      console.error('Missing required parameters')
      return
    }

    this.loading = true
    try {
      this.httpRequest = http.createHttp()
      const response = await this.httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxUnitCheckdata/list',
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'tenant-id': this.tenantId.toString(),
            'X-Access-Token': this.token
          },
          extraData: {
            pageNo: 1,
            pageSize: 100,
            checkDayTime: '晨检',
            startTime: this.date,
            endTime: this.date,
            health: '1' // 获取未检查的人员
          },
          connectTimeout: 60000,
          readTimeout: 60000
        }
      )

      console.info('Response:', response.result)
      if (response.responseCode === http.ResponseCode.OK) {
        const data = JSON.parse(response.result.toString()) as ApiResponse
        if (data.success) {
          this.staffList = data.result.records
          // 按创建时间倒序排序
          this.staffList.sort((a, b) =>
          new Date(b.createTime).getTime() - new Date(a.createTime).getTime()
          )
        } else {
          promptAction.showToast({
            message: data.message || '获取数据失败',
            duration: 2000
          })
        }
      }
    } catch (error) {
      console.error('Fetch staff list failed:', error)
      promptAction.showToast({
        message: '网络请求失败',
        duration: 2000
      })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.about'))
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.back()
          })
        Text('未晨检人员')
          .fontSize(18)
          .fontColor('#FFFFFF')
          .margin({ left: 85 })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#00C853')

      // 主要内容区域
      Column() {
        if (this.loading) {
          LoadingProgress()
            .width(50)
            .height(50)
            .margin({ top: 20 })
        } else if (this.staffList.length === 0) {
          Column() {
            Blank()
            Text('~暂无相关数据~')
              .fontSize(15)
              .fontColor('#BBBBBB')
            Blank()
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          List() {
            ForEach(this.staffList, (staff: StaffRecord) => {
              ListItem() {
                Column() {
                  Row() {
                    Text('姓    名：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.personName)
                      .fontSize(16)
                      .fontColor('#333')
                    Blank()
                    Text(staff.state || '在职')
                      .fontSize(14)
                      .fontColor(staff.state === '在职' ? '#4CAF50' : '#FF5722')
                      .backgroundColor(staff.state === '在职' ? '#E8F5E9' : '#FBE9E7')
                      .borderRadius(4)
                      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('职    位：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.position || '未设置')
                      .fontSize(16)
                      .fontColor('#333')
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('单位名称：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.unitName || '未设置')
                      .fontSize(16)
                      .fontColor('#333')
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('身份证号：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.idCard || '未设置')
                      .fontSize(16)
                      .fontColor('#333')
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('健康证状态：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.healthCertificateStateStr || '未知')
                      .fontSize(16)
                      .fontColor(staff.healthCertificateState === 1 ? '#4CAF50' : '#FF5722')
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })

                  if (staff.pictureImg || staff.pictureBackImg || staff.sceneImg) {
                    Row() {
                      if (staff.pictureImg) {
                        Image(staff.pictureImg)
                          .width(80)
                          .height(80)
                          .objectFit(ImageFit.Cover)
                          .borderRadius(4)
                          .margin({ right: 8 })
                      }
                      if (staff.pictureBackImg) {
                        Image(staff.pictureBackImg)
                          .width(80)
                          .height(80)
                          .objectFit(ImageFit.Cover)
                          .borderRadius(4)
                          .margin({ right: 8 })
                      }
                      if (staff.sceneImg) {
                        Image(staff.sceneImg)
                          .width(80)
                          .height(80)
                          .objectFit(ImageFit.Cover)
                          .borderRadius(4)
                      }
                    }
                    .margin({ top: 8 })
                  }
                }
                .width('100%')
                .padding(16)
                .backgroundColor('#FFF')
                .border({
                  width: 1,
                  color: '#4CAF50',
                  style: BorderStyle.Solid
                })
                .borderRadius(8)
              }
              .margin({ bottom: 10 })
            })
          }
          .width('100%')
          .padding(10)

          Text('-END-')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 20, bottom: 20 })
            .width('100%')
            .textAlign(TextAlign.Center)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
    }
    .width('100%')
    .height('100%')
  }
}