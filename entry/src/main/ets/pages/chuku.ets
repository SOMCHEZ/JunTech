import router from '@ohos.router';

@Entry
@Component
struct PurchaseInventory {
  @State activeTab: number = 0; // 用于跟踪当前激活的选项卡索引
  @State message: string = '~暂无相关数据~'; // 显示的消息
  @State showSupplierPopup: boolean = false; // 控制供应商选择框显示
  @State showDatePopup: boolean = false; // 控制日期选择框显示
  private options: SelectOption[] = [
    { value: '领用单位' },
    { value: '实训第一学校餐厅' }
  ]
  @State selectedValue: string = '领用单位'; // 存储选中值

  @State currentTabContent: string = '待审批'; // 新增状态变量，用于控制显示的内容

  @State isPressed: boolean = false;

  build() {
    Column() {
      // 第一块：标题，使其居中
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


      // 第二块：选项卡
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

      // 第三块：选择框
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

      // 第四块：内容展示区（已支持滚动）
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
      }

      // 第五块：底部按钮
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
            this.isPressed = true; // 按下时变深色
          } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
            this.isPressed = false; // 抬起或取消恢复原色
          }
        })
        .onClick(() => {
          // 跳转到 chukudan 页面
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
