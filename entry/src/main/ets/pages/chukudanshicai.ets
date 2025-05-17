import router from '@ohos.router';
import prompt from '@ohos.prompt';
import http from '@ohos.net.http';
// 定义一个菜品的数据结构
interface FoodItem {
  name: string;
  price: string;
  unit: string;
  stock: string;
  meal: string;
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
      meal:'早餐',
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
      meal:'早餐',
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
      meal:'早餐',
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
      meal:'早餐',
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
  @State life:boolean=false
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
    for (let index = 0; index < this.foodList.length; index++) {
      this.isFavorite[index] = false
      this.isBothClicked[index] = false
    }
  }
  build() {
    Column() {
      Column() {
        Row() {
          Select(this.categoryOptions.map<SelectOption>((item: string) => ({ value: item })))
            .value(this.selectedcategory)// 绑定到状态变量
            .onSelect((index) => {
              this.selectedcategory = this.categoryOptions[index]
              this.x2 = true
            })

            .width('40%')
            .margin({ top: 3 })
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
        } //选择分类
        .width('100%')
        .padding({ top: 2, bottom: 10 })
      }
      .height('10%')
      Column() {
        List({space:3}){
          ForEach(this.foodList, (item: FoodItem, index: number) => {
            ListItem() {
              Stack() {
                // 第一行：图片、名称和收藏按钮
                Row({ space: 10 }) {
                  Row(){
                    Image(item.imageResId)
                      .width(70)
                      .borderRadius(0)
                      .margin({ left: 5, top: -150 })
                  }.width('30%').margin({top:20})

                  Row(){
                    Text(item.name)
                      .fontSize(25)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(Color.Black)
                      .margin({  top: -100 })
                  }.width('50%')
                }
                .width('100%')
                .height(80)
                .padding({ left: 20 })
                // 分割线
                Row()
                  .width('86%')
                  .height(1)
                  .margin({ top: -60, left: 8 })
                  .linearGradient({
                    angle: 90,
                    colors: [['#FCE4CF', 0], ['#F5A35F', 0.5], ['#FCE4CF', 1]]
                  })
                  .zIndex(1)
                // 采购价、供应商、库存等信息
                Column() {
                  Row() {
                    Text('供  应  价：')
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
                    Text('库  存  量：')
                      .fontWeight(600)
                      .width(90)
                    Text(item.supplier)
                      .fontWeight(600)
                  }
                  .margin({ top: 10 })
                  // 库存信息
                  Row() {
                    Text('保  质  期：')
                      .fontWeight(600)
                      .width(90)
                    Text(item.stock)
                      .fontSize(21)
                      .fontWeight(FontWeight.Bold)
                    Text('天')
                      .fontWeight(600)
                  }
                  .margin({ top: 10 })
                  Row() {
                    Text('餐     别：')
                      .fontWeight(600)
                      .width(90)
                    Text(item.supplier)
                      .fontWeight(600)
                  }
                  .margin({ top: 10 })
                  if (this.life){
                    Row() {
                      Text('已过期')
                        .fontWeight(600)
                        .width(90)
                        .fontColor(Color.Red)
                    }
                    .margin({ top: 10 })
                  }
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
                  .margin({ left: -293, top: -245 })
                  .stroke('#FFA500')// 无边框
                  .shadow({ radius: 0 }) // 确保无阴影
                Text('称重')
                  .fontSize(15)
                  .fontColor(Color.White)
                  .rotate({ angle: -45 })
                  .margin({ left: -300, top: -245 })
                // 右下角三角形 (精确匹配)
                Path()
                  .width(60)
                  .height(30)
                  .commands('M230 0 L230 230 L0 230 Z')
                  .fill((this.isBothClicked[index] &&this.foodList[index].isSelected) ? '#16B76A' : '#CCCCCC')// 点击后绿色，默认灰色
                  .margin({ left: 240, top: 163 })
                  .stroke(Color.White)// 无边框
                  .shadow({ radius: 0 })// 确保无阴影s
              }
              .width('95%')
              .height(290)
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
              .backgroundColor(this.life ? '#80ffb9b9' : Color.White)
            }
          }, (item: FoodItem) => item.name.toString())
        }
        .margin({right:5})
      }
      .backgroundColor('#f2dbdada')
      .width('100%')
      .height('85%')

      Column() {
        Row() {
          Text('已选中*种食材')
            .fontSize(15)
            .fontWeight(50)
            .margin({ right: 140, left: 10, bottom: 10 })
          Button({ type: ButtonType.Normal }) {
            Text("确定")
              .margin({ bottom: 10, top: 10 })
          }
          .height(38)
          .width(110)
          .fontColor(Color.White)
          .backgroundColor('#16B76A')
          .borderRadius(5)
          .onClick(() => {
            router.back({
              url: 'pages/chukudan'
            });
          })
        }
        .height(45)
      }
      .width('100%')
      .height('10%')//底部按钮
    }
  }
}