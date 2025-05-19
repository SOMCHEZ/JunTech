import router from '@ohos.router';
import prompt from '@ohos.prompt';
import http from '@ohos.net.http';
// 定义一个菜品的数据结构
AppStorage.setOrCreate('token', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwd2QiOiIyZjg5NWM4NDI2MWFlNzJiYmUyMjVkMjllOWJhZjVjZCIsImV4cCI6MTc0NzM1NjI1NywidXNlcm5hbWUiOiIxNTUwMjkzMzY3MyJ9.iSwsSTRgMclL_ZHLy0NUNvyQ-DJukzsOPhBxbQWxdsc');
AppStorage.setOrCreate('tenantId', 10021011);
AppStorage.setOrCreate('unitId', '');



// interface FoodItem {
//   foodName: string;
//   price: string;
//   unit: string;
//   expirationDay: string;
//   meal: string;
//   supplier: string;
//   imageResId: Resource ; // 图片资源 ID，例如 $r('app.media.food')

//
// }
interface RouteParams {//接口传递参数定义
  token?: string;
  relTenantIds?: number;
  unitId?: string;
}
interface FoodResponse{
  success: boolean;
  code: number;
  result:FoodResult;
  message: string;
}//  接口返回外层
interface FoodResult{
  records:  records[];
  total:number;
  size: number;
  current: number;
  orders: [];
  optimizeCountSql: boolean;
  searchCount: boolean;
  countId: string;
  maxLimit: string;
  pages: number;
}//接口返回中层
interface records{
  id: string,
  createBy: string,
  createTime: string,
  updateBy: string,
  updateTime: string,
  schoolId: string,
  demandUnit: string,
  demandUnitName?: string,
  foodId: string,
  foodName: string,
  encoding: string,
  groupId: string,
  groupName: string,
  unit: string,
  specification: string,
  brandLevel: string,
  modifyPrice: number,
  supplyPricing: number,
  totalNum: number,
  totalWeight?: number,
  storageLocation?: string,
  supplyWay: string,
  supplierId: string,
  supplierName: string,
  producedDate: string,
  batch: string,
  izRemind: string,
  images: string,
  detailList?: string,
  expirationDay: number,
  izConvert: string,
  failureTime: string,
  tenantId: string,
  requirementType: string,
  realSpecification?: string,
  placeOrigin: string,
  izExpired: string,
  internationalCode: string,
  residueDay: string,
  expirationDate: string,
  mealType: string,
  mealCategory: string,
  accountingDate: string,
  requirementType_dictText: string,
  mealType_dictText: string,
  mealCategory_dictText: string
}//列表数据
interface FoodItem extends records {
  id: string,
  createBy: string,
  createTime: string,
  updateBy: string,
  updateTime: string,
  schoolId: string,
  demandUnit: string,
  demandUnitName?: string,
  foodId: string,
  foodName: string,
  encoding: string,
  groupId: string,
  groupName: string,
  unit: string,
  specification: string,
  brandLevel: string,
  modifyPrice: number,
  supplyPricing: number,
  totalNum: number,
  totalWeight?: number,
  storageLocation?: string,
  supplyWay: string,
  supplierId: string,
  supplierName: string,
  producedDate: string,
  batch: string,
  izRemind: string,
  images: string,
  detailList?: string,
  expirationDay: number,
  izConvert: string,
  failureTime: string,
  tenantId: string,
  requirementType: string,
  realSpecification?: string,
  placeOrigin: string,
  izExpired: string,
  internationalCode: string,
  residueDay: string,
  expirationDate: string,
  mealType: string,
  mealCategory: string,
  accountingDate: string,
  requirementType_dictText: string,
  mealType_dictText: string,
  mealCategory_dictText: string
}//继承records的数据


@Entry
@Component
struct shicai {
  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上
  @State originalFoodList: FoodItem[] = []
  async onPageShow() {

    const params = router.getParams() as RouteParams;//接收传参
    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
      //this.receivedToken = params.token;
    }
    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
      //this.tenantId = params.relTenantIds;
    }
    this.receivedToken = AppStorage.get('token')??'';
    this.tenantId = AppStorage.get('tenantId')??0;
    //console.log('tokena:', this.receivedToken);
    const result = await this. Foodchaxun();
    this.originalFoodList = result.result.records;  // 保存原始数据
    this.foodList = [...this.originalFoodList];     // 初始化显示数据
  }

  @State foodList: FoodItem[] = [];

  @State x: number = 0
  @State s: number = 0
  @State foodName: string = ''
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
                    Image(item.images)
                      .width(70)
                      .borderRadius(0)
                      .margin({ left: 5, top: -150 })
                  }.width('30%').margin({top:20})

                  Row(){
                    Text(item.foodName)
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
                    Text(item.modifyPrice.toString())
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
                    Text(item.supplierName)
                      .fontWeight(600)
                  }
                  .margin({ top: 10 })
                  // 库存信息
                  Row() {
                    Text('保  质  期：')
                      .fontWeight(600)
                      .width(90)
                    Text(item.expirationDay.toString())
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
                    Text(item.supplierName)
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
                  .fill((this.isBothClicked[index]) ? '#16B76A' : '#CCCCCC')// 点击后绿色，默认灰色
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
                this.showAlert(this.isBothClicked[index] ? '已选择' : '取消选择')
              })
              .backgroundColor(this.life ? '#80ffb9b9' : Color.White)
            }
          }, (item: FoodItem) => item.foodName.toString())
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
          .onClick(() => {  let SelectFoodList:FoodItem[] = []
            for(let i = 0; i < this.isBothClicked.length; i++){
              if(this.isBothClicked[i]){
                SelectFoodList.push(this.foodList[i])
              }
            }
            console.log('ses:',JSON.stringify(SelectFoodList))
            router.back({
              url:'pages/chukudan',
              params:{
                SelectFoodList:SelectFoodList
              }
            })
          })
        }
        .height(45)
      }
      .width('100%')
      .height('10%')//底部按钮
    }
  }


  private async Foodchaxun(): Promise<FoodResponse> { //这个请求是针对查询后厨人员列表的
    try {
      const httpRequest = http.createHttp();

      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/school/xxRealTimeInventory/listRealTimeInventoryPage',
        {
          method: http.RequestMethod.GET,
          header: {
            //'Content-Type': 'application/json',
            'Tenant-Id': this.tenantId.toString(),
            'X-Access-Token': this.receivedToken
          },
        }
      );
      const emptyResult: FoodResult = {
        records: [],
        total: 0,
        size: 0,
        current: 0,
        orders: [],
        optimizeCountSql: false,
        searchCount: false,
        countId: '',
        maxLimit: '',
        pages: 0
      };

      if (response.responseCode !== 200) {
        //console.error('Login Error:'+response.responseCode);
        return {
          success: false,
          code: response.responseCode,
          result: emptyResult,
          message: `HTTP Error: ${response.responseCode}`
          // 添加其他错误处理逻辑
        };
      }
      console.log('没有报错奥' + response.result.toString())
      const jsonData = JSON.parse(response.result as string) as FoodResponse;
      console.log('好耶', jsonData.result.records[1].id);
      return {
        success: jsonData.code === 200,
        code: jsonData.code,
        result: jsonData.result,
        message: jsonData.message,
        //relTenantIds:jsonData.result.userInfo.relTenantIds
      };

    } catch (error) {
      //console.error('Login Error:', JSON.stringify(error));
      return {
        success: false,
        code: 500,
        result: { // 符合 liuyangResult 的空结构
          records: [],
          total: 0,
          size: 0,
          current: 0,
          orders: [],
          optimizeCountSql: false,
          searchCount: false,
          countId: '',
          maxLimit: '',
          pages: 0
        },
        message: '服务器繁忙'
      }
    }
  }//接口函数
}