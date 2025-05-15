import router from '@system.router';

// 定义订单类型接口
interface OrderItem {
  orderNo: string;
  operateTime: string;
  operateAmount: string;
  operator: string;
  actionDesc: string;
  actionType: 'in' | 'out';
  actionBtn: string;
}

interface RouteParams {
  productName?: string;
  stockAmount?: string;
  orderList?: Array<OrderItem>;
}

@Entry
@Component
struct xiangqing {
  @State productName: string = ''
  @State stockAmount: string = ''
  @State orderList: Array<OrderItem> = []

  aboutToAppear() {
    let params = router.getParams() as RouteParams;
    this.productName = params.productName || '圆白菜'
    this.stockAmount = params.stockAmount || '0斤 (0Kg)'
    this.orderList = params.orderList || [
      {
        orderNo: 'CK20250509001',
        operateTime: '2025-05-09 09:35:46',
        operateAmount: '-1Kg',
        operator: '人',
        actionDesc: '供应出库,给【实训第二学校餐厅】供应出库',
        actionType: 'out',
        actionBtn: '供应出库'
      },
      {
        orderNo: 'RK20250506002',
        operateTime: '2025-05-09 09:35:46',
        operateAmount: '1Kg',
        operator: '人',
        actionDesc: '采购入库,从【诚信蔬菜批发门市】处采购入库',
        actionType: 'in',
        actionBtn: '采购入库'
      }
    ]
  }

  build() {
    Column() {
      // 顶部栏
      Row() {
        Text('✕')
          .fontSize(24)
          .margin({ left: 16 })
          .onClick(() => { router.back() })
        Blank()
        Column() {
          Text('实时库存详情')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 2 })
            .textAlign(TextAlign.Center)
        }
        .width('70%')
        Blank()
      }
      .width('100%')
      .height(48)
      .alignItems(VerticalAlign.Center)
      .margin({ top: 8, bottom: 8 })

      // 商品信息卡片
      Column() {
        Row() {
          Text('商品信息')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#fff')
            .margin({ left: 16, top: 8, bottom: 8 })
        }
        .width('100%')
        .backgroundColor('#3ec97c')
        .borderRadius({ topLeft: 16, topRight: 16 })

        Column() {
          Text(this.productName)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 12, left: 16, bottom: 8 })
          Text('库    存 量：' + this.stockAmount)
            .fontSize(16)
            .margin({ left: 16, bottom: 16 })
        }
        .width('100%')
        .backgroundColor('#fff')
        .borderRadius({ bottomLeft: 16, bottomRight: 16 })
      }
      .width('92%')
      .margin({ left: '4%', right: '4%', bottom: 16 })

      // 单据列表
      Scroll() {
        Column() {
          ForEach(this.orderList, (order: OrderItem) => {
            Column() {
              // 单据号
              Row() {
                Text('●')
                  .fontSize(18)
                  .fontColor(order.actionType === 'in' ? '#3ec97c' : '#bdbdbd')
                  .margin({ right: 4 })
                Text('单据号：' + order.orderNo)
                  .fontSize(16)
                  .fontColor(order.actionType === 'in' ? '#3ec97c' : '#bdbdbd')
              }
              .margin({ left: 16, bottom: 8, top: 8 })

              // 操作信息卡片
              Column() {
                Row() {
                  Text('⏱ 操作时间：' + order.operateTime)
                    .fontSize(15)
                    .margin({ bottom: 4 })
                }
                Text('操作数量：' + order.operateAmount)
                  .fontSize(15)
                  .margin({ bottom: 2 })
                Text('操作人：' + order.operator)
                  .fontSize(15)
                  .margin({ bottom: 8 })
                // 操作描述绿色文本块
                Text(order.actionDesc)
                  .width('100%')
                  .backgroundColor('#3ec97c')
                  .fontColor('#fff')
                  .fontSize(16)
                  .borderRadius(4)
                  .padding({ left: 8, right: 8, top: 6, bottom: 6 })
                  .margin({ top: 8, bottom: 0 })
              }
              .width('92%')
              .margin({ left: '4%', right: '4%', top: 0, bottom: 16 })
              .backgroundColor('#fff')
              .border({ color: '#3ec97c', width: 2 })
              .borderRadius(12)
              .shadow({ radius: 8, color: '#3ec97c22', offsetX: 0, offsetY: 4 })
              .padding(12)
            }
          })
        }
      }
      .width('100%')
      .margin({ bottom: 8 })
    }
    .backgroundColor('#f7f7f7')
    .width('100%')
    .height('100%')
  }
}