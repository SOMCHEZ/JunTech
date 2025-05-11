
import router from '@ohos.router';
@Entry
@Component
struct shicai {
  @State x: number = 0
  @State s: number = 0
  @State name: string = ''
  @State x2: boolean = false //分类判断
  @State x3: boolean = false //分类判断
  @State selectedcategory: string = '全部分类'
  @State selectedUnit: string = '请选择供应商'
  @State searchText: string = ''
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

  aboutToAppear() {
    if (this.categoryOptions.length > 0) {
      this.selectedcategory = this.categoryOptions[0] // '全部分类'
    }
    if (this.unitOptions.length > 0) {
      this.selectedUnit = this.unitOptions[0]
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

        }
        .width('100%')
        .padding({ left: 20, right: 20 })

        Divider()
          .color('#cccccc')// 分界线颜色
          .strokeWidth(1)// 分界线粗细
          .margin({ top: 10, bottom: 10 }) // 上下边距


        Row() {
          //选择分类
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

        }


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


        }
        .width('100%')
        .padding({ top: 20, bottom: 10 })

      }

      // .layoutWeight(1)

      Column() {


          Scroll() {
            Column() {
              Text('- 暂无相关数据 -')
                .fontSize(16)
                .fontColor('#666666')
                .margin({ top: 20, bottom: 20 }) // 改用margin而不是position
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center) // 垂直居中
            .alignItems(HorizontalAlign.Center) // 水平居中
            .backgroundColor('#f2dbdada') // 使用更明显的背景色

          }
          .edgeEffect(EdgeEffect.Spring)
        }

        .layoutWeight(1) // 确保占据剩余空间
        .padding({ bottom: 10 })


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
                  // 跳转到 chuku 页面
                  router.pushUrl({
                    url: 'pages/addPlan'
                  });

                });
            }
            .height(38)
            .width(110)
            .fontColor(Color.White)
            .backgroundColor('#16B76A')
            .borderRadius(5)

          }
          .height(23)
          .padding({ bottom: 0, top: 10 })
        }
      }
    }
  }