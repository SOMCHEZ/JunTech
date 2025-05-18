import router from '@ohos.router';
import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import promptAction from '@ohos.promptAction';

AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);

// 接口响应数据类型定义
interface OutboundOrder {
  id: string;
  accountingDate: string;
  approvalTime: string;
  approvalUser: string;
  approvalUserName: string;
  createTime: string;
  demandUnit: string;
  demandUnitName: string;
  digest: string;
  documentNo: string;
  mealCategory: string;
  mealCategory_dictText: string;
  mealType: string;
  mealType_dictText: string;
  requirementType: string;
  requirementType_dictText: string;
  schoolId: string;
  schoolName: string;
  stockStatus: string;
  stockStatus_dictText: string;
  totalPrice: number;
}
// 领用单位接口响应类型
interface AuthUnitVo {
  id: string;
  unitName: string;
}
interface UnitResponse {
  code: number;
  message: string;
  result: AuthUnitVo[];
  success: boolean;
  timestamp: number;
}
interface GeneratedTypeLiteralInterface_1 {
  current: number;
  pages: number;
  records: OutboundOrder[];
  size: number;
  total: number;
}
interface ApiResponse {
  code: number;
  message: string;
  result: GeneratedTypeLiteralInterface_1;
  success: boolean;
  timestamp: number;
}
interface RouteParams {
  token?: string;
  relTenantIds?: number;
  id?: string;
  documentNo?: string;
  demandUnit?: string;
  demandUnitName?: string;
}
// 定义 SelectOption 接口
interface SelectOption {
  value: string;
}

@Entry
@Component
struct PurchaseInventory {
  @State activeTab: number = 0;
  @State message: string = '~暂无相关数据~';
  @State showSupplierPopup: boolean = false;
  @State showDatePopup: boolean = false;
  @State selectedValue: string = '领用单位';
  @State currentTabContent: string = '待审批';
  @State isPressed: boolean = false;
  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上
  @State unitId: string ='';
  @State outboundId: string = '';
  // 分页相关状态
  @State pageNo: number = 1;
  @State pageSize: number = 10;
  @State total: number = 0;
  @State loading: boolean = false;
  @State OutboundOrder: OutboundOrder[] = [];

  // 领用单位列表
  @State unitList: AuthUnitVo[] = [];
  @State options: SelectOption[] = [];

  @State accountingDate: string = ''
  @State mealType: string = ''
  @State requirementType: string = ''
  @State mealCategory: string = ''
  @State digest: string = ''

  async onPageShow(){
    // 使用接口类型断言
    const params = router.getParams() as RouteParams;
    //console.log('houch11u', params?.token);// 打印接收到的参数
    // 安全取值如果返回值空，则使用appsetcreat中所预保存的token和id
    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
      //console.log('houchu', AppStorage.get('token'));
      //this.receivedToken = params.token;
    }
    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
      //this.tenantId = params.relTenantIds;
    }

    // 同步到组件状态
    this.receivedToken = AppStorage.get('token')??'';
    this.tenantId = AppStorage.get('tenantId')??0;
    // console.log('houchu1', this.receivedToken);
    // console.log('houchu2', this.tenantId);
    const result=await this.queryUnitList();
    if (this.OutboundOrder && this.OutboundOrder.length > 0) {

      this.outboundId = this.OutboundOrder?.find(item =>//存放uid
      item?.id && item.id.trim() !== '',
      )?.id ?? 'default_unit_Name'

    } else {
      //console.error('未获取到有效数据');
      this.outboundId = ''; // 设置默认值
    }

  }

  // 查询领用单位列表
  async queryUnitList() {
    try {
      let httpRequest = http.createHttp();
      let url = 'https://api.suoeryun.com/ifood/school/xxDemandPlanning/queryUnit';

      let response = await httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'tenant-id': this.tenantId.toString(),
            'X-Access-Token': this.receivedToken
          },
          extraData: {
            unitType: '1' // 固定传参：1-餐厅类型
          }
        }
      );

      if (response.responseCode === http.ResponseCode.OK) {
        const responseData = JSON.parse(response.result as string) as UnitResponse;
        if (responseData.code === 200) {
          this.unitList = responseData.result;
          // 转换为Select组件需要的格式
          this.options = (this.unitList || []).reduce((acc, unit) => {
            acc.push({ value: unit.unitName });
            return acc;
          }, [{ value: '领用单位' }] as SelectOption[]);

          // 获取完单位列表后加载订单数据
          const result1=await this.loadData();
          console.log('houchu', result1);
        } else {
          promptAction.showToast({
            message: responseData.message || '获取领用单位列表失败',
            duration: 2000
          });
        }
      }
    } catch (error) {
      const err = error as BusinessError;
      console.error('Query unit list failed:', err.message);
      promptAction.showToast({
        message: '获取领用单位列表失败',
        duration: 2000
      });
    } finally {
      let httpRequest: http.HttpRequest | undefined;
      httpRequest?.destroy();
    }
  }

  // 加载数据
  async loadData() {
    if (this.loading) return;
    this.loading = true;

    try {
      let httpRequest = http.createHttp();
      let url = 'https://api.suoeryun.com/ifood/school/xxSupplyOutManagement/list';

      // 获取选中单位的id
      let selectedUnit = this.unitList.find(unit => unit.unitName === this.selectedValue);

      let response = await httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Accept': 'application/json, text/plain, */*',
            'tenant-id': this.tenantId.toString(),
            'X-Access-Token': this.receivedToken
          },
          extraData: {
            pageNo: this.pageNo,
            pageSize: this.pageSize,
            stockStatus: this.activeTab === 0 ? '0' : '1',
            demandUnit: selectedUnit?.id // 如果选择了具体单位，则传入单位id
          }
        }
      );

      if (response.responseCode === http.ResponseCode.OK) {
        const responseData = JSON.parse(response.result as string) as ApiResponse;
        if (responseData.code === 200) {
          this.OutboundOrder = responseData.result.records;
          this.total = responseData.result.total;
          if (this.OutboundOrder.length === 0) {
            this.message = '暂无数据';
          }
        } else {
          this.message = responseData.message || '请求失败';
          promptAction.showToast({
            message: this.message,
            duration: 2000
          });
        }
      } else {
        this.message = '网络请求失败';
        promptAction.showToast({
          message: this.message,
          duration: 2000
        });
      }
    } catch (error) {
      const err = error as BusinessError;
      this.message = '网络请求失败';
      console.error('Request failed:', err.message);
      promptAction.showToast({
        message: this.message,
        duration: 2000
      });
    } finally {
      this.loading = false;
      let httpRequest: http.HttpRequest | undefined;
      httpRequest?.destroy();
    }
  }

  build() {
    Column() {


          // 标题栏
          Row() {
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
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: 15, right: 15 })

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
                this.pageNo = 1;
                this.loadData();
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
                this.pageNo = 1;
                this.loadData();
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
                this.pageNo = 1; // 切换单位时重置页码
                this.loadData();
              })
              .alignSelf(ItemAlign.Start)
              .width("100%")
              .fontColor('#333')
              .backgroundColor('#FFF')
              .borderRadius(8)
              .border({ width: 0, color: '#DDD' });
          }
          .margin({ bottom: 10, left: 10, right: 10 });
          // 内容展示区
          Scroll() {
            Column() {
              if (this.loading) {
                LoadingProgress()
                  .width(50)
                  .height(50)
                  .margin(20);
              } else if (this.OutboundOrder.length === 0) {
                Text(this.message)
                  .fontSize(16)
                  .fontWeight(FontWeight.Normal)
                  .alignSelf(ItemAlign.Center);
              } else {
                ForEach(this.OutboundOrder, (item: OutboundOrder, index: number) => {
                  Column() {
                    // 添加一个 Row 来包含标题和删除按钮
                    Row() {
                      Text(item.demandUnitName || '实训第一学校餐厅')
                        .fontSize(20)
                        .fontWeight(FontWeight.Bold)
                        .layoutWeight(1) // 让文本占据剩余空间io

                      if (this.activeTab === 0) { // 只在待审批状态显示删除按钮
                        Image($r('app.media.del')) // 确保有删除图标资源
                          .width(24)
                          .height(24)
                          .margin({ left: 8 })
                          .onClick((event: ClickEvent) => {
                            // 阻止事件冒泡，避免触发卡片点击
                            promptAction.showDialog({
                              title: '确认删除',
                              message: '是否确认删除该出库单？',
                              buttons: [
                                {
                                  text: '取消',
                                  color: '#666666'
                                },
                                {
                                  text: '确认',
                                  color: '#E84335'
                                }
                              ]
                            }).then(result => {
                              if (result.index === 1) {
                                //TODO: 调用删除接口
                                promptAction.showToast({
                                  message: '删除成功',
                                  duration: 2000
                                })
                              }
                            })
                          })
                      }
                    }
                    .width('100%')
                    .margin({ bottom: 8 })

                    // 其他信息保持不变
                    Text(`单据号：${item.documentNo}`).fontSize(16).margin({ bottom: 2 })
                    Text(`出库日期：${item.accountingDate}`).fontSize(16).margin({ bottom: 2 })
                    Text(`出库类型：${item.mealType_dictText}`).fontSize(16).margin({ bottom: 2 })
                    Text(`用餐类型：${item.requirementType_dictText}`).fontSize(16).margin({ bottom: 2 })
                    Text(`餐    别：${item.mealCategory_dictText}`).fontSize(16).margin({ bottom: 2 })
                    Text(`制单时间：${item.createTime}`).fontSize(16).margin({ bottom: 2 })
                  }
                  .key(index.toString()) // 确保每个项有唯一的 key
                  .padding(16)
                  .backgroundColor('#fff')
                  .borderRadius(16)
                  .border({ width: 2, color: '#07C160' })
                  .width('95%')
                  .margin({ top: 20, bottom: 20 })
                  .shadow({ radius: 8, color: '#07C160', offsetX: 0, offsetY: 4 })
                  .onClick(() => {
                    if (this.activeTab === 0) { // 待审批b
                      router.pushUrl({
                        url: 'pages/editChuku',
                        params: {
                          token: this.receivedToken,
                          relTenantIds: this.tenantId,
                          unitId: this.unitId,
                          id: item.id,
                          documentNo: item.documentNo,
                          accountingDate: item.accountingDate,
                          mealType: item.mealType,
                          requirementType: item.requirementType,
                          mealCategory: item.mealCategory,
                          digest: item.digest,
                          demandUnit: item.demandUnit,
                          demandUnitName: item.demandUnitName,
                          outboundId:  this.outboundId
                        }
                      });
                      console.log('idwww',item.id);
                      console.log('token',this.receivedToken);
                      console.log('relTenantIds',this.tenantId);
                      // console.log('unitId',this.unitId);
                      // console.log('accountingDate',this.accountingDate);
                      // console.log('mealType',this.mealType);
                      // console.log('requirementType',this.requirementType);
                      // console.log('mealCategory',this.mealCategory);
                      // console.log('digest',this.digest)
                    } else { // 已审批
                      router.replaceUrl({
                        url: 'pages/yishenpi',
                        params: {
                          orderId: item.id,
                          token: this.receivedToken,
                          relTenantIds: this.tenantId
                        }
                      });
                    }
                    console.log('IDDDDD',item.id);
                  });
                });

                // 加载更多
                if (this.OutboundOrder.length < this.total) {
                  Text('加载更多')
                    .fontSize(14)
                    .fontColor('#666')
                    .padding(10)
                    .onClick(() => {
                      this.pageNo++;
                      this.loadData();
                    });
                }
              }
            }
            .width('100%')
            // .height('80%')
            //.justifyContent(FlexAlign.Center)
            //.alignItems(HorizontalAlign.Center);
          }
          .height('80%')
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .zIndex(2)
          // 底部按钮
      Column(){
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
              url: 'pages/chukudan',
              params: {
                token: this.receivedToken,
                relTenantIds: this.tenantId
              }
            });
          });
      }
      .position({ x: 19, y: 675 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F8F8F8');
  }
}