import router from '@ohos.router';

// 定义一个菜品的数据结构

interface FoodItem {
  name: string;
  price: string;
  unit: string;
  stock: string;
  supplier: string;
  imageResId: Resource ; // 图片资源 ID，例如 $r('app.media.food')
  isFavorite: boolean;
  isSelected: boolean;

}

@Entry
@Component
struct shicai {
  @State foodList: FoodItem[] = [
    {
      name: '绿豆',
      price: '12.96',
      unit: '元/Kg',
      stock: '1',
      supplier: '彦红粮油有限公司',
      imageResId: $r('app.media.food'),
      isFavorite: false,
      isSelected: false
    },
    {
      name: '大米',
      price: '5.88',
      unit: '元/Kg',
      stock: '10',
      supplier: '彦红粮油有限公司',
      imageResId: $r('app.media.food'),
      isFavorite: false,
      isSelected: false
    },
    {
      name: '小肉',
      price: '15.00',
      unit: '元/Kg',
      stock: '0',
      supplier: '小杨肉食店',
      imageResId: $r('app.media.food'),
      isFavorite: false,
      isSelected: false
    },
    {
      name: '广红萝卜',
      price: '5.76',
      unit: '元/Kg',
      stock: '0',
      supplier: '蔬菜批发门市',
      imageResId: $r('app.media.food'),
      isFavorite: false,
      isSelected: false
    },
    {
      name: '广红萝卜1',
      price: '5.76',
      unit: '元/Kg',
      stock: '0',
      supplier: '蔬菜批发门市',
      imageResId: $r('app.media.food'),
      isFavorite: false,
      isSelected: false
    }

  ];
  @State x: number = 0
  @State s: number = 0
  @State name: string = ''
  @State x2: boolean = false //分类判断
  @State x3: boolean = false //分类判断
  @State selectedcategory: string = '全部分类'
  @State selectedUnit: string = '请选择供应商'
  @State searchText: string = ''
  @State isFavorite: boolean[] = []
  @State isBothClicked: boolean[] = []
  @State showToast: boolean = false
  @State toastMessage: string = ''
  @State hasDate : boolean = false
  @State activeTab: number = 0; // 用于跟踪当前激活的选项卡索引
  @State refreshTrigger: number = 80 // 触发刷新的下拉距离(像素)
  //分类种类
  private categoryOptions = [
    '全部分类',
    '谷薯类',
    '蔬菜水果类',
    '鱼禽肉蛋类',
    '牛奶类',
    '大豆坚果类',
    '干菜调料类',
    '糕点面包类',
    '主食半成品类',
    '其他'

  ]
  //供应商种类
  private unitOptions = [
    '请选择供应商',
    '小杨肉食店',
    '诚信蔬菜批发门市',
    '彦红粮油有限公司'
  ]

  private showAlert(message: string) {
    this.toastMessage = message
    this.showToast = true
    // 3秒后自动隐藏
    setTimeout(() => {
      this.showToast = false
    }, 2000)
  }

  aboutToAppear() {
    if (this.categoryOptions.length > 0) {
      this.selectedcategory = this.categoryOptions[0] // '全部分类'
    }
    if (this.unitOptions.length > 0) {
      this.selectedUnit = this.unitOptions[0]
    }
    for (let index = 0; index < this.foodList.length; index++) {
      this.isFavorite[index] = false
      this.isBothClicked[index] = false
    }
  }



  build() {
    Column() {
      Column() {
        Row() {
          Button('全部商品')
            .height(30)
            .backgroundColor(Color.White)
            .fontSize(25)
            .fontWeight(this.activeTab === 0 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(Color.Black)
            .stateEffect(true)
            .onClick(() => {
              this.activeTab = 0
              this.x = 0
            })
            .margin({ right: 65 })
          Image($r('app.media.shoucang'))
            .height(28)
            .position({ x: '170' })
          Button({ type: ButtonType.Normal }) {
            Text('常用商品')
              .fontSize(25)
              .fontWeight(this.activeTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          }
          .height(30)
          .backgroundColor(Color.White)

          .fontColor(Color.Black)
          .onClick(() => {
            this.x = 1
            this.activeTab = 1
          })

        }  //大选择
        .width('100%')
        .padding({ left: 20, right: 20 })

        Divider()
          .color('#cccccc')// 分界线颜色
          .strokeWidth(1)// 分界线粗细
          .margin({ top: 10, bottom: 10 }) // 上下边距


        Row() {
          Select(this.categoryOptions.map<SelectOption>((item: string) => ({ value: item })))
            .value(this.selectedcategory)// 绑定到状态变量
            .onSelect((index) => {
              this.selectedcategory = this.categoryOptions[index]
              this.x2 = true
            })

            .width('40%')
            .margin({ top: 10 })
          //选择供应商
          Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
            .value(this.selectedUnit)
            .width(190)
            .onSelect((index: number) => {
              this.selectedUnit = this.unitOptions[index]
              this.x3 = true
            })

            .margin({ right: 50, left: 30, top: 10 })
          if (this.x2) {
            Button('x')
              .width(50)
              .height(60)
              .backgroundColor('#f5f5f5')
              .fontColor(Color.Black)
              .position({
                x: 95,
                y: 14
              })
              .height(30)
              .onClick(() => {
                this.selectedcategory = this.categoryOptions[0] // 重置为第一个选项
                this.x2 = false
              })
          }
          if (this.x3) {
            Button('x')
              .width(50)
              .height(60)
              .backgroundColor('#f5f5f5')
              .fontColor(Color.Black)
              .position({
                x: 320,
                y: 14
              })
              .height(30)
              .onClick(() => {
                this.selectedUnit = this.unitOptions[0] // 重置为第一个选项
                this.x3 = false
              })
          }

        } //选择分类


        Column() {
          // 搜索栏容器
          Row() {
            // 搜索图标
            Image($r('app.media.chazhao'))// 替换为你的搜索图标资源
              .width(20)
              .height(20)
              .margin(10)


            // 输入框
            TextInput({ placeholder: '搜索商品名称' })
              .width('80%')
              .height(40)
              .backgroundColor('#f5f5f5')
              .type(InputType.Normal)
              .onChange((value: string) => {
                this.searchText = value // 更新搜索内容
                console.log('搜索内容:', value)
              })


          }
          .width('90%')
          .height(50)
          .borderRadius(25) // 圆角
          .backgroundColor('#f5f5f5') // 背景色
          .alignItems(VerticalAlign.Center) // 垂直居中
          .justifyContent(FlexAlign.Start) // 左对齐


        }  //搜索栏
        .width('100%')
        .padding({ top: 20, bottom: 10 })
      }.height('25%')


      Column() {
        List({space:3}){
          ForEach(this.foodList, (item: FoodItem, index: number) => {
            ListItem() {
              Stack() {
                // Toast 提示（仅顶部显示一次）


                // 第一行：图片、名称和收藏按钮
                Row({ space: 10 }) {
                  Row(){
                    Image(item.imageResId)
                      .width(70)
                      .borderRadius(0)
                      .margin({ left: 5, top: -115 })
                  }.width('30%').margin({top:20})

                  Row(){
                    Text(item.name)
                      .fontSize(25)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(Color.Black)
                      .margin({  top: -100 })
                  }.width('50%')

                  Row(){
                    Button() {
                      Image((this.isFavorite[index] && this.foodList[index].isFavorite)? $r('app.media.shoucang') : $r('app.media.noshoucang'))
                        .width(30)
                        .height(30)
                    }
                    .width(50)
                    .height(50)
                    .backgroundColor(Color.White)
                    .borderRadius(25)
                    .margin({  left: -10,top: -120 })
                    .onClick(() => {
                      this.isFavorite[index] = !this.isFavorite[index]
                      this.foodList[index].isFavorite = !this.foodList[index].isFavorite
                      this.showAlert(this.isFavorite[index] ? '操作成功' : '操作成功')
                    })
                  }.width('20%')

                }
                .width('100%')
                .height(80)
                .padding({ left: 20 })

                // 分割线
                Row()
                  .width('86%')
                  .height(1)
                  .margin({ top: -10, left: 8 })
                  .linearGradient({
                    angle: 90,
                    colors: [['#FCE4CF', 0], ['#F5A35F', 0.5], ['#FCE4CF', 1]]
                  })
                  .zIndex(1)

                // 采购价、供应商、库存等信息
                Column() {
                  Row() {
                    Text('采  购  价：')
                      .fontWeight(600)
                      .width(90)
                    Text(item.price)
                      .fontSize(21)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(Color.Red)
                    Text(item.unit)
                      .fontWeight(600)
                      .fontColor(Color.Red)
                  }
                  .margin({ top: 10 })
                  .zIndex(2)

                  // 供应商信息
                  Row() {
                    Text('供  应  商：')
                      .fontWeight(600)
                      .width(90)
                    Text(item.supplier)
                      .fontWeight(600)
                  }
                  .margin({ top: 10 })

                  // 库存信息
                  Row() {
                    Text('学校库存：')
                      .fontWeight(600)
                      .width(90)
                    Text(item.stock)
                      .fontSize(21)
                      .fontWeight(FontWeight.Bold)
                    Text('Kg')
                      .fontWeight(600)
                  }
                  .margin({ top: 10 })
                }
                .alignItems(HorizontalAlign.Start)
                .width(220)
                .margin({ top: 100, left: -70 })

                // 左上角三角形标签
                Path()
                  .width(40)
                  .height(40)
                  .commands('M0 0 L180 0 L0 180 Z')
                  .fill('#FFA500')
                  .margin({ left: -293, top: -180 })
                  .stroke('#FFA500')// 无边框
                  .shadow({ radius: 0 }) // 确保无阴影

                Text('称重')
                  .fontSize(15)
                  .fontColor(Color.White)
                  .rotate({ angle: -45 })
                  .margin({ left: -300, top: -180 })

                // 右下角三角形 (精确匹配)
                Path()
                  .width(60)
                  .height(30)
                  .commands('M230 0 L230 230 L0 230 Z')
                  .fill((this.isBothClicked[index] &&this.foodList[index].isSelected) ? '#16B76A' : '#CCCCCC')// 点击后绿色，默认灰色
                  .margin({ left: 240, top: 96 })
                  .stroke(Color.White)// 无边框
                  .shadow({ radius: 0 })// 确保无阴影s
              }
              .width('95%')
              .height(220)
              .borderColor(Color.Orange)
              .backgroundColor(Color.White)
              .borderWidth(2)
              .margin(10)
              .padding(5)
              .shadow({
                radius: 10,
                color: '#fffabc85',
                offsetX: 20,
                offsetY: 20
              })
              .onClick(() => {
                this.isBothClicked[index] = !this.isBothClicked[index]
                this.foodList[index].isSelected  = !this.foodList[index].isSelected
                this.showAlert(this.isBothClicked[index] ? '已选择' : '取消选择')
              })
            }
          }, (item: FoodItem) => item.name.toString())
        }
        .margin({right:5})
      }
      .backgroundColor('#f2dbdada')
      .width('100%')
      .height('70%')

      if (this.showToast) {
        Text(this.toastMessage)

          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#585858')
          .padding(10)
          .borderRadius(4)
          .zIndex(999)
          .width('24%')
          .position({ x: '40%', y: '50%' }) // 使用百分比定位
          .transition({
            type: TransitionType.All,
            translate: { y: -100 } // 改为使用translate属性
          })
          .animation({ duration: 300, curve: Curve.EaseInOut })
          .shadow({
            radius: 10,
            color: '#50000000',
            offsetX: 0,
            offsetY: 4
          })
      }
      Column() {
        Row() {
          Text('已选中*种食材')
            .fontSize(15)
            .fontWeight(50)
            .margin({ right: 140, left: 10, bottom: 10 })
          Button({ type: ButtonType.Normal }) {
            Text("确定")
              .margin({ bottom: 10,top:10 })
              .onClick(() => {
                console.log('11')
                // 跳转到 chuku 页面
                router.back();

              });
          }
          .height(38)
          .width(110)
          .fontColor(Color.White)
          .backgroundColor('#16B76A')
          .borderRadius(5)

        }
        .height(23)
        .position({
          y:690
        })
      }  //底部按钮

    }

  }
}