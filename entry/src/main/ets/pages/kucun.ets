import router from '@ohos.router';

@Entry
@Component
struct PurchaseInventory {
  @State activeTab: number = 0;
  @State message: string = '~暂无相关数据~';
  @State showSupplierPopup: boolean = false;
  @State showDatePopup: boolean = false;
  private options: SelectOption[] = [
    { value: '领用单位' },
    { value: '实训第一学校餐厅' }
  ]
  @State selectedValue: string = '领用单位';
  @State currentTabContent: string = '待审批';
  @State isPressed: boolean = false;

  build() {
    Column() {
      // 标题
      Row(){
        Text('<')
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Center)
          .margin({ top: 0, bottom: 10 })
          .onClick(() => {
            router.back()
          });

        Text('供应出库')
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Center)
          .margin({ top: 0, bottom: 10 });
      }

      // 选项卡
      Row() {
        Text('待审批')
          .fontSize(16)
          .fontWeight(this.activeTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .width('50%')
          .maxLines(1)
          .alignSelf(ItemAlign.Center)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.currentTabContent = '待审批';
            this.activeTab = 0;
          });

        Text('已审批')
          .fontSize(16)
          .fontWeight(this.activeTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          .width('50%')
          .maxLines(1)
          .alignSelf(ItemAlign.Center)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.currentTabContent = '已审批';
            this.activeTab = 1;
          });
      }
      .width('100%')
      .margin({ left: 10, right: 10, bottom: 10 });

      // 选择框
      Row() {
        Select(this.options)
          .selected(0)
          .value(this.selectedValue)
          .onSelect((_: number, value: string) => {
            this.selectedValue = value;
          })
          .alignSelf(ItemAlign.Start)
          .width("100%")
          .fontColor('#333')
          .backgroundColor('#FFF')
          .borderRadius(8)
          .border({ width: 0, color: '#DDD' });
      }
      .margin({ bottom: 10 });

      // 内容展示区
      if (this.currentTabContent === '待审批') {
        Scroll() {
          Column() {
            Text('~暂无相关数据~')
              .fontSize(16)
              .fontWeight(FontWeight.Normal)
              .alignSelf(ItemAlign.Center);
          }
          .backgroundColor(0xCCCCCC)
          .width('100%')
          .height('80%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .borderRadius(8);
        }
      } else if (this.currentTabContent === '已审批') {
        Scroll() {
          Column() {
            // 卡片内容
            Column() {
              Text('实训第一学校餐厅')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 8 });
              Text('单据号：CK20250506001').fontSize(16).margin({ bottom: 2 });
              Text('出库日期：2025-05-06').fontSize(16).margin({ bottom: 2 });
              Text('出库类型：学生餐').fontSize(16).margin({ bottom: 2 });
              Text('用餐类型：营养餐').fontSize(16).margin({ bottom: 2 });
              Text('餐    别：午餐').fontSize(16).margin({ bottom: 2 });
              Text('制单时间：2025-05-06 17:22:18').fontSize(16).margin({ bottom: 2 });
            }
            .padding(16)
            .backgroundColor('#fff')
            .borderRadius(16)
            .border({ width: 2, color: '#07C160' })
            .width('95%')
            .margin({ top: 20, bottom: 20 })
            .shadow({ radius: 8, color: '#07C160', offsetX: 0, offsetY: 4 })
            .onClick(() => {
              // 跳转到详情页面
              router.pushUrl({
                url: 'pages/yishenpi' // 这里填写你的详情页面路径
              });
            });
          }
          .width('100%')
          .height('80%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center);
        }
      }

      // 底部按钮
      Text('新建出库单')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .padding(12)
        .backgroundColor(Color.Green)
        .width('90%')
        .alignSelf(ItemAlign.Center)
        .textAlign(TextAlign.Center)
        .margin({ top: 15, bottom: 20 })
        .borderRadius(8)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.isPressed = true;
          } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
            this.isPressed = false;
          }
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/chukudan'
          });
        });
    }
    .height('100vh')
    .width('100vw')
    .padding({ top: 10, bottom: 10, left: 10, right: 10 })
    .backgroundColor(Color.White);
  }
}