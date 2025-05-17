import router from '@system.router';

@Entry
@Component
struct xiangqing {
  @State productName: string = ''
  @State stockAmount: string = ''
  @State orderNo: string = ''
  @State operateTime: string = ''
  @State operateAmount: string = ''
  @State operator: string = ''
  @State supplier: string = ''

  aboutToAppear() {
    // 获取参数
    let params = router.getParams() as Record<string, string>
    this.productName = params.productName || ''//商品名称
    this.stockAmount = params.stockAmount || ''//库存量
    this.orderNo = params.orderNo || ''//单据号——采购
    this.operateTime = params.operateTime || ''//操作时间
    this.operateAmount = params.operateAmount || ''//操作数量
    this.operator = params.operator || ''//操作人
    this.supplier = params.supplier || ''//供应商
  }

  build() {
    Column() {
      // 顶部栏
      Row() {
        Text('✕')
          .fontSize(24)
          .margin({ left: 16 })
          .onClick(() => { router.back() })
        Column() {
          Text('实时库存详情')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .margin({ bottom: 2 })
        }
        .margin({ left: 16 })
        Blank()
      }
      .width('100%')
      .height(48)
      .alignItems(VerticalAlign.Center)
      .margin({ top: 8, bottom: 8, left: 8, right: 8 })

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
            .width('100%')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 12, left: 16, bottom: 8 })
          Text('库    存    量：' + this.stockAmount)
            .fontSize(16)
            .width('100%')
            .margin({ left: 16, bottom: 16 })
        }
        .width('100%')
        .backgroundColor('#fff')
        .borderRadius({ bottomLeft: 16, bottomRight: 16 })
      }
      .width('92%')
      .margin({ left: '4%', right: '4%', bottom: 16 })

      // 单据号
      Row() {
        Text('●')
          .fontSize(18)
          .fontColor('#3ec97c')
          .margin({ right: 4 })
        Text('单据号：' + this.orderNo)
          .fontSize(16)
          .fontColor('#3ec97c')
      }
      .width('92%')
      .margin({ left: 16, bottom: 12 })

      // 操作信息卡片
      Column() {
        Row() {
          Text('⏱ 操作时间：' + this.operateTime)
            .fontSize(15)
            .width('100%')
            .margin({ bottom: 4 })
        }
        Text('操作数量：' + this.operateAmount+'kg')
          .fontSize(15)
          .width('100%')
          .margin({ bottom: 2 })
        Text('操作人：' + this.operator)
          .fontSize(15)
          .width('100%')
          .margin({ bottom: 8 })
        Text(this.supplier)
          .width('100%')
          .height(40)
          .backgroundColor('#3ec97c')
          .fontColor('#fff')
          .fontSize(15)
          .borderRadius(3)
          .margin({ top: 8, bottom: 8 })
      }
      .width('92%')
      .margin({ left: '4%', right: '4%', top: 0 })
      .backgroundColor('#fff')
      .borderRadius(12)
      .shadow({ radius: 8, color: '#3ec97c22', offsetX: 0, offsetY: 4 })
      .padding(12)
    }
    .backgroundColor('#f7f7f7')
    .width('100%')
    .height('100%')
  }
}