import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import http from '@ohos.net.http'

// API响应接口
interface ApiResponse<T> {
  code: number
  message: string
  result: T
  success: boolean
  timestamp: number
}

// 分页数据接口
interface IPage<T> {
  current: number
  pages: number
  records: T[]
  size: number
  total: number
}

// 配送单数据接口
interface DeliveryOrder {
  distributionNo: string      // 配送单号
  supplyDate: string         // 供应日期
  supplyTime: string         // 供应时间
  schoolName: string         // 学校名称
  unitName: string          // 需求单位
  summary: string           // 摘要
  status: string           // 配送状态
  username: string         // 下单人
  telephone: string        // 下单电话
}

// 配送单页面参数接口
interface RouterParams {
  orderDetail: DeliveryOrder
}

// 路由返回参数接口
interface StatusUpdateParams {
  action: string
  orderId: string
  newStatus: number
  timestamp?: number  // 添加时间戳字段，可选以兼容旧数据
}

// 页面状态枚举
enum DeliveryStatus {
  PENDING = 0,            // 未配送
  DELIVERING = 1,         // 配送中
  RECEIVED = 2,           // 已收货
  REJECTED = 3,           // 已拒收
  CANCELED = 4            // 已取消
}

interface GeneratedObjectLiteralInterface_1 {
  pageNo: number;
  pageSize: number;
  status: string;
}

@Entry
@Component
struct PeisongdanPage {
  @State currentTab: number = 0
  @State orders: DeliveryOrder[] = []
  @State isLoading: boolean = false
  @State supplyDate: string = ''
  @State pageNo: number = 1
  @State pageSize: number = 10
  @State currentStatus: DeliveryStatus = DeliveryStatus.PENDING
  @State pendingUpdateOrderId: string = ''
  @State pendingUpdateStatus: DeliveryStatus = DeliveryStatus.PENDING

  // 状态标签
  private statusTabs: string[] = ['未结算', '已结算']

  aboutToAppear() {
    console.info('配送单列表页面 - aboutToAppear')

    // 设置当前日期为供应日期
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const day = String(now.getDate()).padStart(2, '0')
    this.supplyDate = `${year}-${month}-${day}`

    this.checkStatusUpdate()

    // 加载配送单数据
    this.loadOrders()
  }

  onPageShow() {
    console.info('配送单列表页面 - onPageShow 被触发')
    this.checkStatusUpdate()
  }

  // 检查是否有状态更新需要处理
  checkStatusUpdate() {
    // 从全局上下文获取状态更新参数
    if (globalThis.statusUpdateParams) {
      const params = globalThis.statusUpdateParams as StatusUpdateParams
      console.info(`从全局上下文获取参数: ${JSON.stringify(params)}`)

      if (params && params.action === 'updateOrderStatus') {
        console.info(`需要更新订单状态: ${params.orderId} -> ${params.newStatus}`)
        // 保存待更新信息，准备在订单加载后应用
        this.pendingUpdateOrderId = params.orderId
        this.pendingUpdateStatus = params.newStatus as DeliveryStatus

        // 清除全局变量，避免重复处理
        globalThis.statusUpdateParams = undefined

        // 如果订单已加载，则立即更新状态
        if (this.orders.length > 0) {
          console.info('订单已加载，立即更新状态')
          this.updateOrderStatus(this.pendingUpdateOrderId, this.pendingUpdateStatus)

          // 清除待更新信息
          this.pendingUpdateOrderId = ''
          this.pendingUpdateStatus = DeliveryStatus.PENDING
        } else {
          console.info('订单未加载，将在加载完成后更新状态')
        }
      }
    } else {
      console.info('没有找到状态更新参数')
    }
  }

  async loadOrders() {
    this.isLoading = true
    try {
      // 创建HTTP请求客户端
      let httpRequest = http.createHttp()

      // 构建请求URL和参数
      let url = 'http://your-api-base-url/jeecg-supplier/supplier/gysDistributionManagement/list'
      let params: GeneratedObjectLiteralInterface_1 = {
        pageNo: this.pageNo,
        pageSize: this.pageSize,
        status: this.currentTab === 0 ? '0' : '2' // 0:未配送, 2:已收货
      }

      // 发起GET请求
      let response = await httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          extraData: params,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }
        }
      )

      // 检查响应状态
      if (response.responseCode === 200) {
        let responseData = JSON.parse(response.result.toString()) as ApiResponse<IPage<DeliveryOrder>>
        if (responseData.success) {
          this.orders = responseData.result.records
        } else {
          console.error('API返回错误:', responseData.message)
          promptAction.showToast({
            message: responseData.message || '加载失败',
            duration: 2000
          })
        }
      } else {
        throw new Error(`HTTP请求失败: ${response.responseCode}`)
      }
    } catch (error) {
      console.error('加载配送单失败:', error)
      promptAction.showToast({
        message: '加载失败，请重试',
        duration: 2000
      })
    } finally {
      this.isLoading = false

      // 释放HTTP客户端

    }
  }

  // 根据状态筛选订单
  getFilteredOrders(): DeliveryOrder[] {
    console.info(`getFilteredOrders: 当前选项卡=${this.currentStatus}, 总订单数=${this.orders.length}`)

    // 根据当前选中的状态筛选订单
    const filteredOrders = this.orders.filter(order => {
      const matches = order.status === DeliveryStatus[this.currentStatus]
      console.info(`订单 ${order.distributionNo} 状态=${order.status}, 是否匹配当前选项卡=${matches}`)
      return matches
    })

    console.info(`筛选结果: 找到 ${filteredOrders.length} 个匹配订单`)
    return filteredOrders
  }

  // 更新订单状态
  updateOrderStatus(orderId: string, newStatus: DeliveryStatus): boolean {
    console.info(`准备更新订单 ${orderId} 的状态为 ${newStatus}`)

    // 查找订单并更新状态
    const orderIndex = this.orders.findIndex(order => order.distributionNo === orderId)
    console.info(`找到订单索引: ${orderIndex}`)

    if (orderIndex >= 0) {
      console.info(`当前订单状态: ${this.orders[orderIndex].status}, 目标状态: ${newStatus}`)

      // 复制整个订单对象并修改状态，而不是直接修改
      const updatedOrder: DeliveryOrder = {
        distributionNo: this.orders[orderIndex].distributionNo,
        supplyDate: this.orders[orderIndex].supplyDate,
        supplyTime: this.orders[orderIndex].supplyTime,
        schoolName: this.orders[orderIndex].schoolName,
        unitName: this.orders[orderIndex].unitName,
        summary: this.orders[orderIndex].summary,
        status: DeliveryStatus[newStatus],

        username: this.orders[orderIndex].username,
        telephone: this.orders[orderIndex].telephone
      }

      // 创建新数组而不使用扩展运算符
      const newOrders: DeliveryOrder[] = []
      for (let i = 0; i < this.orders.length; i++) {
        if (i === orderIndex) {
          newOrders.push(updatedOrder)
        } else {
          newOrders.push(this.orders[i])
        }
      }

      // 重新赋值整个数组以触发UI更新
      this.orders = newOrders

      // 打印所有订单状态
      this.orders.forEach((order, index) => {
        console.info(`更新后订单 ${index}: ID=${order.distributionNo}, 状态=${order.status}`)
      })

      // 切换到对应的选项卡
      this.currentStatus = newStatus
      console.info(`已切换到选项卡: ${this.currentStatus}`)

      // 应该在这里调用API更新远程数据
      console.info(`订单 ${orderId} 状态已更新为: ${newStatus}，当前选项卡: ${this.currentStatus}`)

      // 过滤后的订单数量
      const filteredCount = this.getFilteredOrders().length
      console.info(`当前选项卡(${this.currentStatus})下的订单数量: ${filteredCount}`)

      // 此处仅为演示，实际应用中应调用API
      promptAction.showToast({
        message: '订单状态已更新',
        duration: 2000
      })

      return true
    }

    console.error(`未找到订单 ${orderId}`)
    return false
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('←')
          .fontSize(24)
          .fontColor('#333333')
          .margin({ left: 16 })
          .onClick(() => {
            router.back()
          })

        Text('配送单')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF')

      // 状态选项卡
      Row() {
        ForEach(this.statusTabs, (item: string, index: number) => {
          Column() {
            Text(item)
              .fontSize(16)
              .fontColor(this.currentTab === index ? '#31B46A' : '#999999')
              .fontWeight(this.currentTab === index ? FontWeight.Medium : FontWeight.Normal)
              .padding({ left: 12, right: 12, top: 12, bottom: 8 })

            if (this.currentTab === index) {
              Divider()
                .width(80)
                .height(2)
                .color('#31B46A')
            }
          }
          .onClick(() => {
            this.currentTab = index
            this.loadOrders()
          })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor('#FFFFFF')

      // 日期筛选
      Row() {
        Text('请选择供应日期 ▼')
          .fontSize(14)
          .fontColor('#333333')
          .onClick(() => {
            DatePickerDialog.show({
              start: new Date('2020-01-01'),
              end: new Date('2030-12-31'),
              selected: new Date(this.supplyDate),
              onAccept: (value) => {
                if (value && value.year !== undefined && value.month !== undefined && value.day !== undefined) {
                  const year = value.year
                  const month = String(value.month + 1).padStart(2, '0')
                  const day = String(value.day).padStart(2, '0')
                  this.supplyDate = `${year}-${month}-${day}`
                  this.loadOrders()
                }
              }
            })
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F5F5F5')

      // 订单列表
      List() {
        ForEach(this.getFilteredOrders(), (order: DeliveryOrder) => {
          ListItem() {
            Column() {
              Row() {
                Text('单据号：')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                Text(order.distributionNo)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
              }
              .width('100%')
              .margin({ bottom: 12 })

              Row() {
                Text('供应日期：')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(order.supplyTime)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ bottom: 8 })

              Row() {
                Text('下单学校：')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(order.schoolName)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ bottom: 8 })

              Row() {
                Text('需求单位：')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(order.unitName)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ bottom: 8 })

              Row() {
                Text('摘要：')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(order.summary || '-')
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ bottom: 8 })
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .margin({ bottom: 12 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/songhuodan1',
                params: {
                  orderDetail: order
                } as RouterParams
              })
            })
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding(16)
      .backgroundColor('#F5F5F5')

      if (this.isLoading) {
        LoadingProgress()
          .color('#31B46A')
          .width(30)
          .height(30)
          .position({ x: '50%', y: '50%' })
      }
    }
    .width('100%')
    .height('100%')
  }
}