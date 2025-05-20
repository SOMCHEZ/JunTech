import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

// 配送单数据接口
interface DeliveryOrder {
  orderId: string         // 单据号
  supplyTime: string      // 供应时间
  demandUnit: string      // 需求单位
  orderPerson: string     // 下单人
  orderPhone: string      // 下单电话
  summary: string         // 摘要
  schoolName: string      // 学校名称
  status: DeliveryStatus
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

@Entry
@Component
struct PeisongdanPage {
  @State currentStatus: DeliveryStatus = DeliveryStatus.PENDING
  @State orders: DeliveryOrder[] = []
  @State isLoading: boolean = false
  @State supplyDate: string = ''
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
      // 模拟数据，实际应用中应调用API获取数据
      this.orders = [
        {
          orderId: 'PS20250514004',
          supplyTime: '2025-05-12',
          demandUnit: '实训第二学校(库房)',
          orderPerson: '人',
          orderPhone: '15502933673',
          summary: '',
          schoolName: '实训第二学校',
          status: DeliveryStatus.PENDING
        },
        {
          orderId: 'PS20250514005',
          supplyTime: '2025-05-12上午',
          demandUnit: '实训第二学校(库房)',
          orderPerson: '人',
          orderPhone: '15502933673',
          summary: '',
          schoolName: '实训第二学校',
          status: DeliveryStatus.PENDING
        },
        {
          orderId: 'PS20250514006',
          supplyTime: '2025-05-12',
          demandUnit: '实训第二学校(库房)',
          orderPerson: '人',
          orderPhone: '15502933673',
          summary: '',
          schoolName: '实训第二学校',
          status: DeliveryStatus.PENDING
        }
      ]

      console.info(`加载了 ${this.orders.length} 个订单`)

      // 处理待更新的订单
      if (this.pendingUpdateOrderId && this.pendingUpdateStatus !== DeliveryStatus.PENDING) {
        console.info(`立即处理待更新订单: ${this.pendingUpdateOrderId} -> ${this.pendingUpdateStatus}`)
        const success = this.updateOrderStatus(this.pendingUpdateOrderId, this.pendingUpdateStatus)
        console.info(`处理结果: ${success ? '成功' : '失败'}`)

        // 清除待更新信息
        this.pendingUpdateOrderId = ''
        this.pendingUpdateStatus = DeliveryStatus.PENDING
      } else {
        console.info(`没有待处理的订单更新`)
      }
    } catch (error) {
      console.error('加载配送单失败:', error)
      promptAction.showToast({
        message: '加载失败，请重试',
        duration: 2000
      })
    } finally {
      this.isLoading = false
    }
  }

  // 根据状态筛选订单
  getFilteredOrders(): DeliveryOrder[] {
    console.info(`getFilteredOrders: 当前选项卡=${this.currentStatus}, 总订单数=${this.orders.length}`)

    // 根据当前选中的状态筛选订单
    const filteredOrders = this.orders.filter(order => {
      const matches = order.status === this.currentStatus
      console.info(`订单 ${order.orderId} 状态=${order.status}, 是否匹配当前选项卡=${matches}`)
      return matches
    })

    console.info(`筛选结果: 找到 ${filteredOrders.length} 个匹配订单`)
    return filteredOrders
  }

  // 更新订单状态
  updateOrderStatus(orderId: string, newStatus: DeliveryStatus): boolean {
    console.info(`准备更新订单 ${orderId} 的状态为 ${newStatus}`)

    // 查找订单并更新状态
    const orderIndex = this.orders.findIndex(order => order.orderId === orderId)
    console.info(`找到订单索引: ${orderIndex}`)

    if (orderIndex >= 0) {
      console.info(`当前订单状态: ${this.orders[orderIndex].status}, 目标状态: ${newStatus}`)

      // 复制整个订单对象并修改状态，而不是直接修改
      const updatedOrder: DeliveryOrder = {
        orderId: this.orders[orderIndex].orderId,
        supplyTime: this.orders[orderIndex].supplyTime,
        demandUnit: this.orders[orderIndex].demandUnit,
        orderPerson: this.orders[orderIndex].orderPerson,
        orderPhone: this.orders[orderIndex].orderPhone,
        summary: this.orders[orderIndex].summary,
        schoolName: this.orders[orderIndex].schoolName,
        status: newStatus
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
        console.info(`更新后订单 ${index}: ID=${order.orderId}, 状态=${order.status}`)
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
            router.pushUrl({
              url: 'pages/gongyingshangshouye'
            })
          })

        Text('送货单')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('⋮')
          .fontSize(24)
          .fontColor('#333333')
          .margin({ right: 16 })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffffff')

      // 状态选项卡
      Row() {
        ForEach(this.statusTabs, (item: string, index: number) => {
          Column() {
            Text(item)
              .fontSize(16)
              .fontColor(this.currentStatus === index ? '#31B46A' : '#999999')
              .fontWeight(this.currentStatus === index ? FontWeight.Medium : FontWeight.Normal)
              .padding({ left: 12, right: 12, top: 12, bottom: 8 })

            if (this.currentStatus === index) {
              Divider()
                .width(80)
                .height(2)
                .color('#31B46A')
            }
          }
          .onClick(() => {
            this.currentStatus = index
          })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor('#fffaf3f3')

      // 日期筛选
      Row() {
        Row() {
          Text('请选择供应日期')
            .fontSize(14)
            .fontColor('#333333')

          Text('▼')
            .fontSize(14)
            .fontColor('#333333')
            .margin({ left: 8 })
        }
        .onClick(() => {
          // 显示日期选择器
          DatePickerDialog.show({
            start: new Date('2020-01-01'),
            end: new Date('2030-12-31'),
            selected: new Date(this.supplyDate),
            onAccept: (value) => {
              // 确保value.month不是undefined
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
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor('#F4F4F4')

      // 订单列表
      List() {
        ForEach(this.getFilteredOrders(), (order: DeliveryOrder) => {
          ListItem() {
            Column() {
              // 学校名称
              Text(order.schoolName)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 12 })

              // 订单信息
              Row() {
                Text('单 据 号:')
                  .fontSize(14)
                  .fontColor('#666666')
                  .width(80)

                Text(order.orderId)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ top: 6, bottom: 6 })
              .alignItems(VerticalAlign.Center)

              Row() {
                Text('供应时间:')
                  .fontSize(14)
                  .fontColor('#666666')
                  .width(80)

                Text(order.supplyTime)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ top: 6, bottom: 6 })
              .alignItems(VerticalAlign.Center)

              Row() {
                Text('需求单位:')
                  .fontSize(14)
                  .fontColor('#666666')
                  .width(80)

                Text(order.demandUnit)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ top: 6, bottom: 6 })
              .alignItems(VerticalAlign.Center)

              Row() {
                Text('下 单 人:')
                  .fontSize(14)
                  .fontColor('#666666')
                  .width(80)

                Text(order.orderPerson)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ top: 6, bottom: 6 })
              .alignItems(VerticalAlign.Center)

              Row() {
                Text('下单电话:')
                  .fontSize(14)
                  .fontColor('#666666')
                  .width(80)

                Text(order.orderPhone)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ top: 6, bottom: 6 })
              .alignItems(VerticalAlign.Center)

              Row() {
                Text('摘    要:')
                  .fontSize(14)
                  .fontColor('#666666')
                  .width(80)

                Text(order.summary || '-')
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ top: 6, bottom: 6 })
              .alignItems(VerticalAlign.Center)

              // 添加确认货已送达按钮，只在"配送中"状态显示
              if (order.status === DeliveryStatus.DELIVERING) {
                Row() {
                  Button('确认货已送达')
                    .fontSize(16)
                    .fontColor('#fffaf7f7')
                    .backgroundColor('#1E88E5')
                    .borderRadius(4)
                    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                    .margin({ top: 12 })
                    .onClick(() => {
                      // 更新订单状态为已收货
                      this.updateOrderStatus(order.orderId, DeliveryStatus.RECEIVED)

                      promptAction.showToast({
                        message: '已确认收货',
                        duration: 2000
                      })

                      // 返回 true 阻止事件继续传播
                      return true
                    })
                }
                .width('100%')
                .justifyContent(FlexAlign.Center)
                // 添加事件拦截
                .onClick(() => {
                  // 空事件处理器，拦截冒泡事件
                  return true
                })
              }
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#ffffffff')
            .borderRadius(8)
            .borderWidth(1)
            .borderColor('#31B46A')
            .onClick(() => {
              // 添加日志输出，帮助调试
              console.info(`准备跳转到详情页，订单号: ${order.orderId}`)

              try {
                router.pushUrl({
                  url: 'pages/songhuodan1', // 使用带有gh标记的页面
                  params: {
                    orderDetail: order
                  } as RouterParams
                })
                  .then(() => {
                    console.info('跳转成功')
                  })
                  .catch((err: Error) => {
                    console.error(`导航失败: ${JSON.stringify(err)}`)
                    promptAction.showToast({
                      message: '跳转失败，请重试',
                      duration: 2000
                    })
                  })
              } catch (e) {
                console.error(`跳转异常: ${JSON.stringify(e)}`)
                promptAction.showToast({
                  message: '跳转发生异常，请重试',
                  duration: 2000
                })
              }
            })
          }
          .margin({ bottom: 12 })
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 12 })
      .backgroundColor('#F4F4F4')
    }
    .width('100%')
    .height('100%')
  }
}