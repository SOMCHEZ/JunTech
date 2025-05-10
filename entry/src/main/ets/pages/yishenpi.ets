import router from '@ohos.router';
import prompt from '@ohos.prompt';

interface IngredientItem {
  name: string;
  brand: string;
  price: number;
  quantity: number;
  unit: string;
  image: Resource;
  tag?: string; // 角标内容
}

interface GeneratedObjectLiteralInterface_1 {
  unit: string;
  orderNo: string;
  date: string;
  type: string;
  mealType: string;
  meal: string;
  createTime: string;
}

@Entry
@Component
struct OutboundOrderDetail {
  @State items: Array<IngredientItem> = [
    {
      name: '白萝卜',
      brand: '农家',
      price: 1.8,
      quantity: 1,
      unit: 'Kg',
      image: $r('app.media.about'),
      tag: '称重'
    },
    {
      name: '芹菜',
      brand: '农家',
      price: 1.56,
      quantity: 1,
      unit: 'Kg',
      image: $r('app.media.about'),
      tag: '称重'
    }
  ];

  private orderInfo: GeneratedObjectLiteralInterface_1 = {
    unit: '实训第一学校餐厅',
    orderNo: 'CK20250506001',
    date: '2025-05-06',
    type: '学生餐',
    mealType: '营养餐',
    meal: '午餐',
    createTime: '2025-05-06 17:22:18'
  };

  get totalAmount(): string {
    let sum = 0;
    this.items.forEach(item => {
      sum += item.price * item.quantity;
    });
    return sum.toFixed(2);
  }

  build() {
    Column() {
      // 顶部条纹图片
      Image($r('app.media.info_bord'))
        .width('100%')
        .height(24)
        .objectFit(ImageFit.Fill);

      // 顶部信息卡片+返回
      Row() {
        // 返回按钮
        Image($r('app.media.left_icon'))
          .width(32).height(32)
          .margin({ left: 8, right: 8, top: 8 })
          .onClick(() => router.back());
        // 信息卡片
        Column() {
          Text(this.orderInfo.unit)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 });
          Text('单据号：' + this.orderInfo.orderNo).fontSize(16).fontColor('#666').margin({ bottom: 2 });
          Text('出库日期：' + this.orderInfo.date).fontSize(16).fontColor('#666').margin({ bottom: 2 });
          Text('出库类型：' + this.orderInfo.type).fontSize(16).fontColor('#666').margin({ bottom: 2 });
          Text('用餐类型：' + this.orderInfo.mealType).fontSize(16).fontColor('#666').margin({ bottom: 2 });
          Text('餐别：' + this.orderInfo.meal).fontSize(16).fontColor('#666').margin({ bottom: 2 });
          Text('制单时间：' + this.orderInfo.createTime).fontSize(16).fontColor('#666');
        }
        .padding(20)
        .backgroundColor('#fff')
        .borderRadius(18)
        .shadow({ radius: 12, color: '#E6E6E6', offsetX: 0, offsetY: 6 })
        .margin({ bottom: 18, left: 0, right: 12, top: 8 });
      }
      .margin({ bottom: 0, left: 0, right: 0, top: 0 });

      // 食材明细卡片
      ForEach(this.items, (item: IngredientItem, index: number) => {
        Stack() {
          // 卡片主体
          Column() {
            Row() {
              Text(item.name)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#222')
                .margin({ left: 8, top: 12, bottom: 8 });
            }
            .width('100%');

            Row() {
              Text('单 位: ' + item.unit).fontSize(16).fontColor('#888').margin({ right: 12 });
              Text('品牌: ' + item.brand).fontSize(16).fontColor('#888');
            }
            .margin({ left: 16, right: 16, bottom: 4 });

            Row() {
              Text('供应价: ')
                .fontSize(16).fontColor('#888');
              Text(item.price + '元/' + item.unit)
                .fontSize(16)
                .fontColor('#FF4040')
                .fontWeight(FontWeight.Bold)
                .margin({ right: 12 });
              Text('出库数量: ' + item.quantity + item.unit)
                .fontSize(16).fontColor('#888');
            }
            .margin({ left: 16, right: 16, bottom: 4 });

            Row() {
              Text('合计: ')
                .fontSize(16).fontColor('#888');
              Text((item.price * item.quantity).toFixed(2) + '元')
                .fontSize(18)
                .fontColor('#FF4040')
                .fontWeight(FontWeight.Bold)
                .margin({ left: 4 });
            }
            .margin({ left: 16, right: 16, bottom: 12 });
          }
          .backgroundColor('#fff')
          .borderRadius(16)
          .shadow({ radius: 10, color: '#FFE0B2', offsetX: 0, offsetY: 6 })
          .margin({ top: 20, bottom: 12, left: 16, right: 16 });

          // 角标
          if (item.tag) {
            Column() {
              Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Text(item.tag)
                  .fontSize(14)
                  .fontColor('#fff')
                  .fontWeight(FontWeight.Bold)
                  .margin({ left: 0, right: 0, top: 2, bottom: 2 });
              }
              .width(54)
              .height(28)
              .backgroundColor('#FFA726')
              .borderRadius({ topLeft: 12, topRight: 0, bottomLeft: 0, bottomRight: 12 })
              .transform([{ rotateZ: -18 }])
              .margin({ left: -12, top: -12 });
            }
            .position({ x: 0, y: 0 });
          }
        }
      }, (item: IngredientItem) => item.name);

      // 底部合计与按钮
      Row() {
        Column() {
          Text('总计：' + 3.36+ '元')
            .fontSize(24)
            .fontColor('#FF4040')
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 2 });
          Text('共' + this.items.length + '种')
            .fontSize(18)
            .fontColor('#222');
        }
        .layoutWeight(1);
        Button('电子签')
          .type(ButtonType.Capsule)
          .backgroundColor('#07C160')
          .fontColor('#fff')
          .fontSize(20)
          .width(120)
          .height(48)
          .borderRadius(24)
          .shadow({ radius: 8, color: '#B2DFDB', offsetX: 0, offsetY: 4 })
          .margin({ right: 16 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/signature' });
          });
      }
      .padding({ left: 16, right: 16, top: 24, bottom: 24 })
      .backgroundColor('#fff')
      .borderRadius(16)
      .shadow({ radius: 10, color: '#E0E0E0', offsetX: 0, offsetY: 4 })
      .margin({ top: 32, bottom: 12, left: 8, right: 8 });
    }
    .width('100%')
    .backgroundColor('#F8F8F8')
    .height('100%');
  }
}