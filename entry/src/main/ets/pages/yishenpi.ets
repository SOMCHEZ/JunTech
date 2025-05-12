import router from '@ohos.router';
import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import promptAction from '@ohos.promptAction';

// 食材明细接口
interface FoodDetail {
  id: string;
  foodName: string;
  unit: string;
  specification: string;
  brandLevel: string;
  supplyPricing: number;
  num: number;
  totalPrice: number;
  realSpecification: string;
  placeOrigin: string;
  producedDate: string;
  batch: string;
  images?: string;
  foodProveImages?: string;
}

// 出库单详情接口
interface OutboundOrderDetail {
  id: string;
  accountingDate: string;
  approvalTime: string;
  approvalUser: string;
  approvalUserName: string;
  createBy: string;
  createByName: string;
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
  totalPrice: number;
  foods: FoodDetail[];
  stockStatus?: string;
  managerSignature?: string;
  custodianSignature?: string;
  receiverSignature?: string;
}

interface ApiResponse {
  code: number;
  message: string;
  result: OutboundOrderDetail;
  success: boolean;
  timestamp: number;
}

interface RouterParams {
  orderId: string;
  token: string;
  relTenantIds: string | number;
}

@Entry
@Component
struct OutboundOrderDetailPage {
  @State loading: boolean = true;
  @State orderDetail: OutboundOrderDetail = {
    id: '',
    accountingDate: '',
    approvalTime: '',
    approvalUser: '',
    approvalUserName: '',
    createBy: '',
    createByName: '',
    createTime: '',
    demandUnit: '',
    demandUnitName: '',
    digest: '',
    documentNo: '',
    mealCategory: '',
    mealCategory_dictText: '',
    mealType: '',
    mealType_dictText: '',
    requirementType: '',
    requirementType_dictText: '',
    schoolId: '',
    totalPrice: 0,
    foods: []
  };

  @State message: string = '';
  private token: string = '';
  private tenantId: string | number = 0;
  private orderId: string = '';
  private httpRequest: http.HttpRequest | null = null;


  aboutToAppear() {
    try {
      const params = router.getParams() as RouterParams;
      console.info('Router params:', JSON.stringify(params));
      if (params) {
        this.token = params.token;
        this.tenantId = params.relTenantIds;
        this.orderId = params.orderId;
        this.queryOrderDetail();
      }
    } catch (error) {
      console.error('Router params error:', error.message);
      promptAction.showToast({
        message: '参数错误',
        duration: 2000
      });
    }
  }

  aboutToDisappear() {
    if (this.httpRequest) {
      this.httpRequest.destroy();
      this.httpRequest = null;
    }
  }

  async queryOrderDetail() {
    if (!this.orderId) {
      this.message = '订单ID不能为空';
      console.error('Order ID is empty');
      promptAction.showToast({
        message: this.message,
        duration: 2000
      });
      return;
    }

    try {
      this.httpRequest = http.createHttp();
      let url = 'https://api.suoeryun.com/ifood/jeecg-school/school/xxSupplyOutManagement/queryById';

      console.info('Requesting URL:', url);
      console.info('Request params:', {
        id: this.orderId,
        token: this.token,
        tenantId: this.tenantId
      });

      let response = await this.httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'tenant-id': this.tenantId.toString(),
            'X-Access-Token': this.token
          },
          extraData: {
            id: this.orderId
          },
          connectTimeout: 60000,
          readTimeout: 60000,
          expectDataType: http.HttpDataType.STRING
        }
      );

      console.info('Response code:', response.responseCode);
      console.info('Response result:', response.result);

      if (response.responseCode === http.ResponseCode.OK) {
        const responseData = JSON.parse(response.result.toString()) as ApiResponse;
        console.info('Parsed response:', JSON.stringify(responseData));

        if (responseData.code === 200 && responseData.success) {
          this.orderDetail = responseData.result;
          if (!this.orderDetail || !this.orderDetail.foods || this.orderDetail.foods.length === 0) {
            this.message = '暂无相关数据';
            console.info('No data found in response');
          }
        } else {
          this.message = responseData.message || '获取订单详情失败';
          console.error('API error:', this.message);
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
      this.message = '网络请求失败: ' + err.message;
      console.error('Request failed:', err.message);
      promptAction.showToast({
        message: this.message,
        duration: 2000
      });
    } finally {
      this.loading = false;
      if (this.httpRequest) {
        this.httpRequest.destroy();
        this.httpRequest = null;
      }
    }
  }

  @Builder
  FoodItemBuilder(item: FoodDetail) {
    Stack() {
      Column() {
        Row() {
          Text(item.foodName)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#222')
            .margin({ left: 8, top: 12, bottom: 8 });
        }
        .width('100%');

        Row() {
          Text('单位: ' + item.unit)
            .fontSize(16)
            .fontColor('#666')
            .margin({ right: 12 });
          Text('规格: ' + item.realSpecification)
            .fontSize(16)
            .fontColor('#666');
        }
        .margin({ left: 16, right: 16, bottom: 4 });

        Row() {
          Text('品牌等级: ' + item.brandLevel)
            .fontSize(16)
            .fontColor('#666')
            .margin({ right: 12 });
          Text('批次: ' + item.batch)
            .fontSize(16)
            .fontColor('#666');
        }
        .margin({ left: 16, right: 16, bottom: 4 });

        if (item.producedDate) {
          Row() {
            Text('生产日期: ' + item.producedDate)
              .fontSize(16)
              .fontColor('#666');
          }
          .margin({ left: 16, right: 16, bottom: 4 });
        }

        Row() {
          Text('供应价: ')
            .fontSize(16)
            .fontColor('#666');
          Text(item.supplyPricing.toFixed(2) + '元/' + item.unit)
            .fontSize(16)
            .fontColor('#FF4040')
            .fontWeight(FontWeight.Bold)
            .margin({ right: 12 });
          Text('出库数量: ' + item.num + item.unit)
            .fontSize(16)
            .fontColor('#666');
        }
        .margin({ left: 16, right: 16, bottom: 4 });

        Row() {
          Text('合计: ')
            .fontSize(16)
            .fontColor('#666');
          Text(item.totalPrice.toFixed(2) + '元')
            .fontSize(18)
            .fontColor('#FF4040')
            .fontWeight(FontWeight.Bold);
        }
        .margin({ left: 16, right: 16, bottom: 12 });

        if (item.foodProveImages) {
          Row() {
            Column() {
              Image(item.foodProveImages.split(',')[0])
                .width(120)
                .height(120)
                .objectFit(ImageFit.Cover)
                .borderRadius(8);
              Text('上样图')
                .fontSize(14)
                .fontColor('#666')
                .margin({ top: 4 });
            }
            .margin({ right: 16 });

            if (item.foodProveImages.split(',')[1]) {
              Column() {
                Image(item.foodProveImages.split(',')[1])
                  .width(120)
                  .height(120)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(8);
                Text('下样图')
                  .fontSize(14)
                  .fontColor('#666')
                  .margin({ top: 4 });
              }
            }
          }
          .margin({ left: 16, right: 16, bottom: 12 });
        }
      }
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .width('95%')
      .shadow({ radius: 8, color: '#07C160', offsetX: 0, offsetY: 4 })
      .margin({ top: 20, bottom: 12 });

      if (item.specification === '称重') {
        Text('称重')
          .fontSize(14)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#FFA726')
          .padding(4)
          .borderRadius({ topLeft: 12, bottomRight: 12 })
          .position({ x: 0, y: 0 });
      }
    }
  }

  build() {
    Column() {
      // 返回按钮和标题
      Row() {
        Image($r('app.media.left_icon'))
          .width(32)
          .height(32)
          .margin({ left: 16 })
          .onClick(() => router.back());
        Text('出库单详情')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 });
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF');

      // 顶部条纹图片
      Image($r('app.media.info_bord'))
        .width('100%')
        .height(24)
        .objectFit(ImageFit.Fill);

      if (this.loading) {
        LoadingProgress()
          .width(50)
          .height(50)
          .margin(20);
      } else if (!this.orderDetail || !this.orderDetail.foods || this.orderDetail.foods.length === 0) {
        Text(this.message || '暂无相关数据')
          .fontSize(16)
          .fontColor('#666')
          .margin(20);
      } else {
        // 头部信息
        Column() {
          Text(this.orderDetail.demandUnitName)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 });
          Text('单据号：' + this.orderDetail.documentNo)
            .fontSize(16)
            .fontColor('#666')
            .margin({ bottom: 2 });
          Text('出库日期：' + this.orderDetail.accountingDate)
            .fontSize(16)
            .fontColor('#666')
            .margin({ bottom: 2 });
          Text('出库类型：' + this.orderDetail.mealType_dictText)
            .fontSize(16)
            .fontColor('#666')
            .margin({ bottom: 2 });
          Text('用餐类型：' + this.orderDetail.requirementType_dictText)
            .fontSize(16)
            .fontColor('#666')
            .margin({ bottom: 2 });
          Text('餐别：' + this.orderDetail.mealCategory_dictText)
            .fontSize(16)
            .fontColor('#666')
            .margin({ bottom: 2 });
          Text('制单时间：' + this.orderDetail.createTime)
            .fontSize(16)
            .fontColor('#666');
          if (this.orderDetail.approvalTime) {
            Text('审核时间：' + this.orderDetail.approvalTime)
              .fontSize(16)
              .fontColor('#666')
              .margin({ top: 2 });
            Text('审核人：' + this.orderDetail.approvalUserName)
              .fontSize(16)
              .fontColor('#666')
              .margin({ top: 2 });
          }
        }
        .padding(20)
        .backgroundColor('#FFFFFF')
        .borderRadius(18)
        .width('95%')
        .shadow({ radius: 8, color: '#07C160', offsetX: 0, offsetY: 4 })
        .margin({ bottom: 18, top: 8 });

        // 食材列表
        List({ space: 8 }) {
          ForEach(this.orderDetail.foods, (item: FoodDetail) => {
            ListItem() {
              this.FoodItemBuilder(item);
            }
          }, (item: FoodDetail) => item.id);
        }
        .layoutWeight(1)
        .width('100%');

        // 底部合计与按钮
        Row() {
          Column() {
            Text('总计：' + this.orderDetail.totalPrice.toFixed(2) + '元')
              .fontSize(24)
              .fontColor('#FF4040')
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 2 });
            Text('共' + this.orderDetail.foods.length + '种')
              .fontSize(18)
              .fontColor('#222');
          }
          .layoutWeight(1);

          Button('电子签')
            .type(ButtonType.Capsule)
            .backgroundColor('#07C160')
            .fontColor('#FFFFFF')
            .fontSize(20)
            .width(120)
            .height(48)
            .borderRadius(24)
            .shadow({ radius: 8, color: '#B2DFDB', offsetX: 0, offsetY: 4 })
            .margin({ right: 16 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/signature',
                params: {
                  orderId: this.orderId,
                  token: this.token,
                  relTenantIds: this.tenantId
                }
              });
            });
        }
        .width('95%')
        .padding({ left: 16, right: 16, top: 24, bottom: 24 })
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .shadow({ radius: 8, color: '#07C160', offsetX: 0, offsetY: 4 })
        .margin({ top: 32, bottom: 12 });
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F8F8');
  }
}