import Router from '@system.router';

@Entry
@Component
struct kucun {
  @State selectedCategory: string = '全部分类';
  @State selectedStockType: string = '库存类型';
  @State selectedMealType: string = '用餐类型';
  @State selectedMealCategory: string = '餐别';
  @State searchText: string = '';

  categoryOptions: string[] = ['全部分类', '谷薯类', '蔬菜水果类', '鱼禽肉蛋类','牛奶类','大豆坚果类','干菜调料类','糕点面包类','主食半成品类','其他'];
  stockTypeOptions: string[] = ['库存类型', '学生餐', '教师餐'];
  mealTypeOptions: string[] = ['用餐类型', '其他', '营养餐'];
  mealCategoryOptions: string[] = ['餐别', '其他', '早餐', '午餐', '晚餐'];

  // 使用箭头函数，确保builder为函数引用
  categoryController: CustomDialogController = new CustomDialogController({
    builder: () => this.renderDialogContent(this.categoryOptions, (value: string) => {
      this.selectedCategory = value;
      this.categoryController.close();
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });

  stockTypeController: CustomDialogController = new CustomDialogController({
    builder: () => this.renderDialogContent(this.stockTypeOptions, (value: string) => {
      this.selectedStockType = value;
      this.stockTypeController.close();
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });

  mealTypeController: CustomDialogController = new CustomDialogController({
    builder: () => this.renderDialogContent(this.mealTypeOptions, (value: string) => {
      this.selectedMealType = value;
      this.mealTypeController.close();
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });

  mealCategoryController: CustomDialogController = new CustomDialogController({
    builder: () => this.renderDialogContent(this.mealCategoryOptions, (value: string) => {
      this.selectedMealCategory = value;
      this.mealCategoryController.close();
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });

  // @Builder方法生成弹窗内容
  @Builder
  renderDialogContent(options: string[], onSelect: (value: string) => void): void {
    Column() {
      Row() {
        Text('请选择')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .height(50)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(50)
      .backgroundColor('#F5F5F5')
      .justifyContent(FlexAlign.Center)

      // 支持滑动的下拉菜单内容
      Scroll() {
        List() {
          ForEach(options, (option: string) => {
            ListItem() {
              Text(option)
                .fontSize(16)
                .width('100%')
                .height(50)
                .textAlign(TextAlign.Center)
                .backgroundColor(Color.White)
                .onClick(() => {
                  onSelect(option);
                })
            }
            .width('100%')
            .height(50)
          })
        }
        .width('100%')
      }
      .height(200) // 最大高度，超出可滑动
      .backgroundColor(Color.White)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius({ topLeft: 16, topRight: 16 })
  }

  build(): void {
    // 页面直接从Tabs开始，无顶部栏
    Tabs() {
      TabContent() {
        Column() {
          Row() {
            // 全部分类选择器
            Column() {
              Text(this.selectedCategory)
                .fontSize(16)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .onClick(() => {
                  this.categoryController.open();
                })
            }
            .width(75)
            .margin({ right: 8 })

            // 库存类型选择器
            Column() {
              Text(this.selectedStockType)
                .fontSize(16)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .onClick(() => {
                  this.stockTypeController.open();
                })
            }
            .width(75)
            .margin({ right: 8 })

            // 用餐类型选择器
            Column() {
              Text(this.selectedMealType)
                .fontSize(16)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .onClick(() => {
                  this.mealTypeController.open();
                })
            }
            .width(75)
            .margin({ right: 8 })

            // 餐别选择器
            Column() {
              Text(this.selectedMealCategory)
                .fontSize(16)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .onClick(() => {
                  this.mealCategoryController.open();
                })
            }
            .width(75)
          }
          .margin({ bottom: 8 })
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          // 搜索框
          Search({ placeholder: '搜索商品名称' as ResourceStr, value: this.searchText })
            .onChange((value: string) => {
              this.searchText = value;
            })
            .onSubmit(() => {
              if (this.searchText.trim()) {
                console.log('搜索文本:' + this.searchText);
                // 在这里添加搜索逻辑
              } else {
                console.warn('搜索内容为空');
              }
            })
            .margin({ bottom: 8 })
          Button('去出库')
            .height(40)
            .width(100)
            .position({x: 250, y: 500})
            .onClick(() => {
              Router.push({
                uri: 'pages/chuku',
              });
            })
            .fontColor('#a3000000')
            .backgroundColor('#ffc1bdbd')
        }
        .padding(0)
        .height('100%')
        .width('100%')
      }
      .tabBar('非零库存')
      TabContent() {
        Column() {
          Row() {
            // 全部分类选择器
            Column() {
              Text(this.selectedCategory)
                .fontSize(16)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .onClick(() => {
                  this.categoryController.open();
                })
            }
            .width(75)
            .margin({ right: 8 })

            // 库存类型选择器
            Column() {
              Text(this.selectedStockType)
                .fontSize(16)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .onClick(() => {
                  this.stockTypeController.open();
                })
            }
            .width(75)
            .margin({ right: 8 })

            // 用餐类型选择器
            Column() {
              Text(this.selectedMealType)
                .fontSize(16)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .onClick(() => {
                  this.mealTypeController.open();
                })
            }
            .width(75)
            .margin({ right: 8 })

            // 餐别选择器
            Column() {
              Text(this.selectedMealCategory)
                .fontSize(16)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .onClick(() => {
                  this.mealCategoryController.open();
                })
            }
            .width(75)
          }
          .margin({ bottom: 8 })
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          // 搜索框
          Search({ placeholder: '搜索商品名称' as ResourceStr, value: this.searchText })
            .onChange((value: string) => {
              this.searchText = value;
            })
            .onSubmit(() => {
              if (this.searchText.trim()) {
                console.log('搜索文本:' + this.searchText);
                // 在这里添加搜索逻辑
              } else {
                console.warn('搜索内容为空');
              }
            })
            .margin({ bottom: 8 })
          Button('去出库')
            .height(40)
            .width(100)
            .position({x: 250, y: 500})
            .onClick(() => {
              Router.push({
                uri: 'pages/chuku',
              });
            })
            .fontColor('#a3000000')
            .backgroundColor('#ffc1bdbd')
        }
        .padding(0)
        .height('100%')
        .width('100%')
      }
      .tabBar('零库存')
    }
  }
}