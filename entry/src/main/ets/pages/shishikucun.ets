import Router from '@system.router';
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';

interface RealTimeInventoryItem {
  id: string;
  foodId: string;
  foodName: string;
  groupId: string;
  groupName: string;
  totalNum: number;//库存量
  unit: string;//单位
  supplyPricing: number;//供应价
  modifyPrice: number;//单价
  producedDate: string;//生产日期
  expirationDate: string;
  mealCategory: string;
  createTime:string//操作时间
  mealCategory_dictText: string;//餐别-早，午，晚
  mealType: string;
  mealType_dictText: string;//库存类型
  requirementType: string;
  requirementType_dictText: string;//用餐类型
  supplierId: string;
  supplierName: string;//供应商
  specification:  string;//规格——称重/计件

  // ... 你需要的其他字段
}

interface RealTimeInventoryPage {
  id: string;  // 添加可选id属性
  current: number;
  pages: number;
  records: RealTimeInventoryItem[];
  size: number;
  total: number;
}

interface RealTimeInventoryResponse {
  code: number;
  message: string;
  result: RealTimeInventoryPage;
  success: boolean;
  timestamp: number;
}

interface FoodGroup {
  id: string;
  groupName: string;
  groupCode: string;
  parentId: string;
  childNodes: FoodGroup[];
  sortNumber: number;
  createTime: string;
  updateTime: string;
  tenantId: string;
}

interface ApiResponse {
  code: number;
  message: string;
  result: FoodGroup[];
  success: boolean;
  timestamp: number;
}

interface StockItem {
  id: string;
  name: string;
  price?: number;
  inTime?: string;
  amount: number;
  num?:string;
  cTime?:string;
  needType?: string;
  mealCategory?: string;
  supplier?: string;
  productionDate?: string;
  groupName?: string;
  mealType?: string;
  mealType1?: string;
  documentNo?:  string;
}

interface StockResponse {
  code: number;
  message: string;
  result: StockItem[];
  success: boolean;
  timestamp: number;
}

interface kucun1 {
  name: string,
  price: number,
  inTime: string,
  amount?: number,
  needType: string,
  mealCategory: string,
  supplier: string,
  productionDate: string
}

interface RouteParamsItem {
  token?: string;
  relTenantIds?: number;
  inventoryId?: string;
}

interface RouteParams {
  params?: RouteParamsItem;
}

function convertToStockItem(item: RealTimeInventoryItem): StockItem {
  return {
    id: item.id ,
    name: item.foodName || '',
    price: item.modifyPrice ?? 0,
    inTime: item.producedDate || '',
    amount: item.totalNum ?? 0,
    cTime: item.createTime || '',
    needType: item.requirementType_dictText || '',
    mealCategory: item.mealCategory_dictText || '',
    supplier: item.supplierName || '',
    productionDate: item.producedDate || '',
    groupName: item.groupName || '',
    mealType: item.mealType_dictText || '',
    num:item.unit||''
  };
}

interface mingxi{
  id:  string;
  createBy:  string;
  createTime:  string;
  updateBy?:  string|null;
  updateTime?:  string|null;
  inventoryId: string;
  accountingDate: string;
  documentNo:  string;
  digest: string;
  num: string;
  createByName: string;
  modifyPrice: number;
  supplyPricing?: number|null;
}

interface MingxiResponse {
  success: boolean;
  message: string;
  code: number;
  result: mingxi[];
  timestamp: number;
}

interface GeneratedTypeLiteralInterface_1 {
  text: string;
}

interface StockTypeResult {
  success: boolean;
  result: GeneratedTypeLiteralInterface_1[];
}

@Entry
@Component
struct kucun {
  @State selectedCategory: string = '全部分类';
  @State selectedStockType: string = '库存类型';
  @State selectedMealType: string = '用餐类型';
  @State selectedMealCategory: string = '餐别';
  @State searchText: string = '';
  @State categoryOptions: string[] = ['全部分类'];
  @State stockTypeOptions: string[] = ['库存类型'];
  @State mealTypeOptions: string[] = ['用餐类型'];
  @State mealCategoryOptions: string[] = ['餐别'];
  @State isLoading: boolean = false;
  @State shishikucun: StockItem[] = [];
  @State shishikucun0: StockItem[] = [];
  @State token: string = '';
  @State tenantId: number = 0;

  @State inventoryId: string = ''; // 新增状态变量

  @State mingxi: StockItem[] = [];
  // 添加筛选后的数据状态
  @State detailData: mingxi[] = []; // 新增的状态变量
  @State filteredShishikucun: StockItem[] = [];
  @State filteredShishikucun0: StockItem[] = [];

  @State selectedTab: number = 0; // 添加这个状态变量来跟踪当前选中的标签页

  kucunmingxi(mingxi:StockItem){
    this.inventoryId  = mingxi.id;
  }

  collectNames(groups: FoodGroup[]): string[] {
    if (!groups || groups.length === 0) {
      return [];
    }
    let categories: string[] = [];
    groups.forEach(group => {
      if (group.groupName) {
        categories.push(group.groupName);
      }
      if (group.childNodes && group.childNodes.length > 0) {
        categories = categories.concat(this.collectNames(group.childNodes));
      }
    });
    return categories;
  }

  aboutToAppear() {
    const params = Router.getParams() as RouteParamsItem;
    if (params) {
      this.token = params.token ?? '';
      this.tenantId = params.relTenantIds ?? 0;
      this.inventoryId = params.inventoryId ?? ''; // 新增参数获取
      //console.info('路由参数:', JSON.stringify(params));

      AppStorage.set('token', this.token);
      AppStorage.set('tenantId', this.tenantId);
      AppStorage.set('inventoryId', this.inventoryId);
      console.info('已保存 token:', this.token, 'tenantId:', this.tenantId);
    }

    this.fetchFoodCategories();
    this.fetchDropdownOptions();
    this.fetchStockData();
  }

  async fetchDetail() {
    let httpRequest = http.createHttp();
    try {
      this.isLoading = true;

      // 带参数的请求URL
      const url =
        `https://api.suoeryun.com/ifood/school/xxRealTimeInventory/queryInventoryDetail?inventoryId=${this.inventoryId}`;

      let response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: {
          'Tenant-Id': this.tenantId.toString(),
          'X-Access-Token': this.token
        }
      });


      const rawResult = response.result as string;
      console.info('原始响应数据:', rawResult);
      const parsedResult = JSON.parse(rawResult) as MingxiResponse
      this.detailData = parsedResult.result || [];
      console.info('响应数据:', this.detailData);
    } catch (error) {
      console.error('请求失败:', error);
    } finally {
      this.isLoading = false;
    }
  }
  async fetchFoodCategories() {
    let httpRequest = http.createHttp();
    try {
      this.isLoading = true;

      const token = this.token;
      const tenantId = this.tenantId;

      if (!token || !tenantId) {
        console.error('token 或 tenantId 缺失');
        return;
      }

      const baseUrl = "https://api.suoeryun.com/ifood/education/jyjFoodGroup/queryFoodGroupByGroupId"
      const url = baseUrl

     /* console.info('请求URL:', url);
      console.info('请求Headers:', {
        'Tenant-Id': tenantId.toString(),
        'X-Access-Token': token
      });*/

      let response = await httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: {
            'Tenant-Id': tenantId.toString(),
            'X-Access-Token': token
          }
        }
      );

      const rawResult = response.result as string;
      console.info('库存接口原始响应:', rawResult);
      if (rawResult.trim().startsWith('<!DOCTYPE') || rawResult.trim().startsWith('<html>')) {
        console.error('服务器返回 HTML 页面，可能是未登录或接口错误');
        promptAction.showToast({
          message: '登录失效，请重新登录',
          duration: 3000
        });
        return;
      }

      const result = JSON.parse(rawResult) as ApiResponse;
      //console.info('库存接口原始响应:', result);

      if (response.responseCode === 200 && result.success && result.result) {
        // 打印完整的 API 响应数据
        //console.info('API 返回的完整数据:', JSON.stringify(result, null, 2));
        // Update categoryOptions with API data
        this.categoryOptions = ['全部分类'].concat(this.collectNames(result.result));
        //console.info('更新后的分类选项:', this.categoryOptions);
      } else {
        console.error('接口返回 success=false:', result.message);
      }
    } catch (error) {
      console.error('获取食品分类失败:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
      httpRequest.destroy();
    }
  }

  async fetchDropdownOptions() {

    let httpRequest = http.createHttp();
    try {
      this.isLoading = true;
      const token = this.token;
      const tenantId = this.tenantId;
      if (!token || !tenantId) return;

      // 库存类型
      const stockTypeUrl = "https://api.suoeryun.com/ifood/jeecg-system/sys/dictItem/getDictItemsByCode/meal_type";
      let stockTypeResponse = await httpRequest.request(stockTypeUrl, {
        method: http.RequestMethod.GET,
        header: {
          'Tenant-Id': tenantId.toString(),
          'X-Access-Token': token
        }
      });

      if (stockTypeResponse.responseCode === 200) {
        const stockTypeResult: StockTypeResult = JSON.parse(stockTypeResponse.result as string);
        if (stockTypeResult.result) {
          this.stockTypeOptions = ['库存类型'].concat(stockTypeResult.result.map(item => item.text));
          console.log('stockTypeOptions:', this.stockTypeOptions)
        }
      }

      // 用餐类型
      const mealTypeUrl = "https://api.suoeryun.com/ifood/jeecg-system/sys/dictItem/getDictItemsByCode/requirement_type";
      let mealTypeResponse = await httpRequest.request(mealTypeUrl, {
        method: http.RequestMethod.GET,
        header: {
          'Tenant-Id': tenantId.toString(),
          'X-Access-Token': token
        }
      });
      if (mealTypeResponse.responseCode === 200) {
        const mealTypeResult: StockTypeResult = JSON.parse(mealTypeResponse.result as string);
        if (mealTypeResult.result) {
          this.mealTypeOptions = ['用餐类型'].concat(mealTypeResult.result.map(item => item.text));
        }
      }

      // 餐别
      const mealCategoryUrl = "https://api.suoeryun.com/ifood/jeecg-system/sys/dictItem/getDictItemsByCode/nutritional_Category_Settings";
      let mealCategoryResponse = await httpRequest.request(mealCategoryUrl, {
        method: http.RequestMethod.GET,
        header: {
          'Tenant-Id': tenantId.toString(),
          'X-Access-Token': token
        }
      });
      if (mealCategoryResponse.responseCode === 200) {
        const mealCategoryResult: StockTypeResult = JSON.parse(mealCategoryResponse.result as string);
        if (mealCategoryResult.result) {
          this.mealCategoryOptions = ['餐别'].concat(mealCategoryResult.result.map(item => item.text));
        }
      }
    } finally {
      this.isLoading = false;
      httpRequest.destroy();
    }
  }

  async fetchStockData(pageNo: number = 1, pageSize: number = 20) {
    let httpRequest = http.createHttp();
    try {
      this.isLoading = true;

      const token = this.token;
      const tenantId = this.tenantId;

      if (!token || !tenantId) {
        console.error('token 或 tenantId 缺失');
        return;
      }

      // 构建查询参数
      const params = [
        `pageNo=${pageNo}`,
        `pageSize=${pageSize}`,
        this.searchText ? `foodName=${encodeURIComponent(this.searchText)}` : '',
        this.selectedCategory !== '全部分类' ? `groupId=${encodeURIComponent(this.selectedCategory)}` : '',
        this.selectedMealCategory !== '餐别' ? `mealCategory=${encodeURIComponent(this.selectedMealCategory)}` : '',
        this.selectedMealType !== '用餐类型' ? `mealType=${encodeURIComponent(this.selectedMealType)}` : '',
        this.selectedStockType !== '库存类型' ? `requirementType=${encodeURIComponent(this.selectedStockType)}` : '',
        // izZero=1 非零库存, izZero=0 零库存, 可根据你的tab切换传递
        this.selectedTab === 0 ? 'izZero=0' : 'izZero=1'
      ].filter(Boolean).join('&');

      const stockUrl = `https://api.suoeryun.com/ifood/school/xxRealTimeInventory/list?${params}`;
      //console.info('请求库存URL:', stockUrl);

      let response = await httpRequest.request(stockUrl, {
        method: http.RequestMethod.GET,
        header: {
          'Tenant-Id': tenantId.toString(),
          'X-Access-Token': token
        }
      });

      const rawResult = response.result as string;
      console.info('库存接口原始响应:', rawResult);

      if (rawResult.trim().startsWith('<!DOCTYPE') || rawResult.trim().startsWith('<html>')) {
        promptAction.showToast({ message: '登录失效，请重新登录', duration: 3000 });
        Router.push({ uri: 'pages/login_test' });
        return;
      }

      let result: RealTimeInventoryResponse;
      try {
        result = JSON.parse(rawResult) as RealTimeInventoryResponse;

      } catch (parseError) {
        promptAction.showToast({ message: '服务器返回数据格式错误', duration: 3000 });
        return;
      }

      if (response.responseCode === 200 && result && result.success && result.result) {
        // 处理分页数据
        const records = result.result.records || [];

        //const allStock: StockItem[] = records.map(convertToStockItem);
        this.shishikucun = records.filter(item => item.totalNum > 0).map(item => convertToStockItem(item));
        this.shishikucun0 = records.filter(item => item.totalNum === 0).map(item => convertToStockItem(item));




        // 你可以根据 records 里的字段，更新筛选项
        // 例如 groupName、mealCategory_dictText、mealType_dictText、requirementType_dictText

        // ... 其余筛选项更新逻辑

        this.filterData();
      } else {
        promptAction.showToast({ message: result?.message || '服务器返回数据异常', duration: 3000 });
      }
    } catch (error) {
      promptAction.showToast({ message: '获取库存数据失败，请稍后重试', duration: 3000 });
    } finally {
      this.isLoading = false;
      httpRequest.destroy();
    }
  }

  // 修改筛选方法
  filterData() {
    const filterItems = (items: StockItem[]) => {
      return items.filter(item => {
        // 分类筛选（支持模糊匹配）
        if (this.selectedCategory !== '全部分类') {
          const category = this.selectedCategory.toLowerCase();
          if (!item.groupName?.toLowerCase().includes(category)) {
            return false;
          }
        }

        // 库存类型筛选
        if (this.selectedStockType !== '库存类型') {
          const stockType = this.selectedStockType.toLowerCase();
          if (!item.mealType?.toLowerCase().includes(stockType)) {
            return false;
          }
        }

        // 用餐类型筛选
        if (this.selectedMealType !== '用餐类型') {
          const mealType = this.selectedMealType.toLowerCase();
          if (!item.needType?.toLowerCase().includes(mealType)) {
            return false;
          }
        }

        // 餐别筛选
        if (this.selectedMealCategory !== '餐别') {
          const mealCategory = this.selectedMealCategory.toLowerCase();
          if (!item.mealCategory?.toLowerCase().includes(mealCategory)) {
            return false;
          }
        }

        // 原有名称搜索保持不变
        if (this.searchText?.trim() &&
          !item.name.toLowerCase().includes(this.searchText.toLowerCase().trim())) {
          return false;
        }

        return true;
      });
    };

    this.filteredShishikucun = filterItems(this.shishikucun);
    this.filteredShishikucun0 = filterItems(this.shishikucun0);
  }


  categoryController: CustomDialogController = new CustomDialogController({
    builder: () => this.renderDialogContent(this.categoryOptions, (value: string) => {
      this.selectedCategory = value;
      this.categoryController.close();
      this.filterData(); // 添加筛选调用
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
      this.filterData(); // 添加筛选调用
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
      this.filterData(); // 添加筛选调用
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
      this.filterData(); // 添加筛选调用
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });

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
      .height(200)
      .backgroundColor(Color.White)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius({ topLeft: 16, topRight: 16 })
  }
  build(): void {
    Tabs() {
      TabContent() {
        Column() {
          Row() {
            Column() {
              if (this.isLoading) {
                LoadingProgress()
                  .width(20)
                  .height(20)
              } else {
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
            }
            .width(75)
            .margin({ right: 8 })

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

          Search({ placeholder: '搜索商品名称' as ResourceStr, value: this.searchText })
            .onChange((value: string) => {
              this.searchText = value;
              this.filterData(); // 添加筛选调用
            })
            .onSubmit(() => {
              if (this.searchText.trim()) {
                console.log('搜索文本:' + this.searchText);
                this.filterData(); // 添加筛选调用
              } else {
                console.warn('搜索内容为空');
              }
            })
            .margin({ bottom: 8 })
          Scroll() {
            Column() {
              ForEach(this.filteredShishikucun, (item: StockItem) => {
                Column() {
                  Row() {
                    Text(item.name)
                      .fontSize(20)
                      .layoutWeight(2)
                      .fontWeight(FontWeight.Bold)
                      .margin({ right: 10,  left: 10 })
                    Text('生产日期: ' + item.productionDate)
                      .fontSize(14)
                      .layoutWeight(4)
                      .textAlign(TextAlign.End)
                      .fontColor('#888')
                  }
                  .margin({ bottom: 4 })

                  Divider()
                    .color('#ddd')
                    .margin({ bottom: 8 })
                  Text('供应价：   ' + item.price + '元/Kg ')
                    .fontSize(16)
                    .width('100%')
                    .fontColor('#e57373')
                    .margin({ bottom: 2 })
                  Text('入库时间：   ' + item.cTime)
                    .width('100%')
                    .fontSize(14)
                  Text('库  存  量：   ' + (item.amount*2)+'斤(' + (item.amount) + 'Kg)')
                    .width('100%')
                    .fontSize(14)
                  Text('需求类型：   ' + item.mealType+'  '+item.needType)
                    .width('100%')
                    .fontSize(14)
                  Text('餐       别：   ' + item.mealCategory)
                    .width('100%')
                    .fontSize(14)
                  Text('供  应  商：   ' + item.supplier)
                    .width('100%')
                    .fontSize(14)
                }
                .margin({ left: 12, right: 12})
                .onClick(async() => {
                  this.kucunmingxi(item)
                  try {
                    await this.fetchDetail(); // 等待数据加载完成

                    // 添加安全校验
                    if (!this.detailData || this.detailData.length === 0) {
                      promptAction.showToast({ message: '暂无明细数据', duration: 2000 });
                      return;
                    }
                    Router.push({
                      uri: 'pages/dingdanxiangqing',
                      params: {
                        productName: item.name,
                        stockAmount: (item.amount*2)+'斤 ('+item.amount+'kg)',
                        orderNo: this.detailData[0].documentNo,
                        operateTime: item.cTime,
                        operateAmount: item.amount,
                        operator: this.detailData[0].createByName,
                        supplier: this.detailData[0].digest
                      }
                    })
                  }  catch (error) {
                    console.error('Error fetching detail data:', error);
                  }
                })
                .padding(12)
                .width('100%')
                .margin({ bottom: 12 })
                .backgroundColor('#fff8f0')
                .borderRadius(12)
                .shadow({
                  radius: 4,
                  color: '#eee',
                  offsetX: 0,
                  offsetY: 2
                })
              })
            }
            .height('100%')
          }
          .height('100%')
          .margin({ bottom: 8 })

          Button('去出库')
            .height(40)
            .width(100)
            .position({ x: 270, y: 500 })
            .onClick(() => {
              Router.push({
                uri: 'pages/kucun',
              });
            })
            .fontColor('#a3000000')
            .backgroundColor('#6ff8f2f2')
        }
        .padding(0)
        .height('100%')
        .width('100%')
      }
      .tabBar('非零库存')

      TabContent() {
        Column() {
          Row() {
            Column() {
              if (this.isLoading) {
                LoadingProgress()
                  .width(20)
                  .height(20)
              } else {
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
            }
            .width(75)
            .margin({ right: 8 })

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

          Search({ placeholder: '搜索商品名称' as ResourceStr, value: this.searchText })
            .onChange((value: string) => {
              this.searchText = value;
              this.filterData(); // 添加筛选调用
            })
            .onSubmit(() => {
              if (this.searchText.trim()) {
                console.log('搜索文本:' + this.searchText);
                this.filterData(); // 添加筛选调用
              } else {
                console.warn('搜索内容为空');
              }
            })
            .margin({ bottom: 8 })
          Scroll() {
            Column() {
              ForEach(this.filteredShishikucun0, (item: StockItem) => {
                Column() {
                  Row() {
                    Text(item.name)
                      .fontSize(20)
                      .layoutWeight(2)
                      .fontWeight(FontWeight.Bold)
                      .margin({ right: 10,  left: 10 })
                    Text('生产日期: ' + item.productionDate)
                      .fontSize(14)
                      .layoutWeight(4)
                      .textAlign(TextAlign.End)
                      .fontColor('#888')
                  }
                  .margin({ bottom: 4 })

                  Divider()
                    .color('#ddd')
                    .margin({ bottom: 8 })
                  Text('供应价：   ' + item.price + '元/Kg ')
                    .fontSize(16)
                    .width('100%')
                    .fontColor('#e57373')
                    .margin({ bottom: 2 })
                  Text('入库时间：   ' + item.cTime)
                    .width('100%')
                    .fontSize(14)
                  Text('库  存  量：   ' + (item.amount*2)+'斤(' + (item.amount) + 'Kg)')
                    .width('100%')
                    .fontSize(14)
                  Text('需求类型：   ' + item.mealType+'  '+item.needType)
                    .width('100%')
                    .fontSize(14)
                  Text('餐       别：   ' + item.mealCategory)
                    .width('100%')
                    .fontSize(14)
                  Text('供  应  商：   ' + item.supplier)
                    .width('100%')
                    .fontSize(14)
                }
                .margin({ left: 12, right: 12})
                .onClick(async () => {
                  this.kucunmingxi(item)
                  try {
                    await this.fetchDetail(); // 等待数据加载完成

                    // 添加安全校验
                    if (!this.detailData || this.detailData.length === 0) {
                      promptAction.showToast({ message: '暂无明细数据', duration: 2000 });
                      return;
                    }
                    Router.push({
                      uri: 'pages/dingdanxiangqing0',
                      params: {
                        productName: item.name,
                        stockAmount: item.amount,
                        orderNo: this.detailData[0].documentNo,
                        orderNo1:this.detailData[1].documentNo,
                        operateTime: item.cTime,
                        operateAmount: this.detailData[0].num,
                        operateAmount1: this.detailData[1].num,
                        operator: this.detailData[0].createByName,
                        supplier: this.detailData[0].digest,
                        supplier1: this.detailData[1].digest
                      }
                    })
                  } catch (error) {
                    console.error('Error fetching detail data:', error);
                  }
                })
                .padding(12)
                .width('100%')
                .margin({ bottom: 12 })
                .backgroundColor('#fff8f0')
                .borderRadius(12)
                .shadow({
                  radius: 4,
                  color: '#eee',
                  offsetX: 0,
                  offsetY: 2
                })
              })
            }
            .height('100%')
          }
          .height('100%')
          .margin({ bottom: 8 })

          Button('去出库')
            .height(40)
            .width(100)
            .position({ x: 270, y: 500 })
            .onClick(() => {
              Router.push({
                uri: 'pages/chuku',
              });
            })
            .fontColor('#a3000000')
            .backgroundColor('#6ff8f2f2')
        }
        .padding(0)
        .height('100%')
        .width('100%')
      }
      .tabBar('零库存')
    }
    .onChange((index: number) => {
      this.selectedTab = index; // 更新选中的标签页索引
      this.fetchStockData(); // 切换标签页时重新获取数据
    })
  }
}