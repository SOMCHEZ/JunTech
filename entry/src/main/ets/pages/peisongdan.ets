import router from '@ohos.router';
import http from '@ohos.net.http';
AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);
interface RouterParams {
  token?: string;
  relTenantIds?: number;
  demandUnit?: string;
}// 上个页面传进来的
interface records{//定义接口返回类型
  id: string,
  createBy: string,
  createTime: string,
  updateBy: string,
  updateTime: string,
  sysOrgCode: string,
  tenantId: string,
  supplierId: string,
  supplierName: string,
  distributionNo: string,
  stockNo: string,
  documentNo: string,
  supplyTime: string,
  supplyDate: string,
  schoolId: string,
  schoolName: string,
  status: string,
  unitId: string,
  unitName: string,
  proveImages: string,
  totalPrice: number,
  realTotalPrice: number,
  approvalOpinion: number,
  unitType: string,
  isDelivery: string,
  gysDistributionGoodsList?:string,
  requirementType:string,
  izReplenishment: string,
  stockId: string,
  distributionId: string,
  supplierRemark: string,
  summary: string,
  sumprice: number,
  printNum: number,
  auditTime: number,
  operateStatus: number,
  operateLogs: string,
  acceptorSignature: string,
  auditorSignature: string,
  shipperSignature: string,
  arrivalTime: string,
  deliveryMan: string,
  deliveryPhone: string,
  username: string,
  telephone: string,
  mealType: string,
  mealCategory: string,
  startDate: string,
  endDate: string,
  foodName: string,
  userSchoolIds: string,
  supplyTime_dictText:string,
  status_dictText: string,
  requirementType_dictText: string,
  mealType_dictText: string,
  mealCategory_dictText: string
}//内层
// 定义单个配送商品信息
// interface GysDistributionGoods {
//   id: string;
//   foodName: string;
//   specification: string;
//   deliveriesNum: number;
//   unit: string;
//   supplyPricing: number;
//   images: string; // 食材图片地址
// }
//
// // 定义配送记录主表
// interface DistributionRecord {
//   distributionNo: string;      // 配送单号
//   documentNo: string;          // 单据号（订单号）
//   schoolName: string;          // 学校名称
//   supplyDate: string;          // 供应日期
//   deliveryMan: string;         // 送货人
//   deliveryPhone: string;       // 电话
//   status: string;              // 状态：0未配送，1配送中，2已收货，3已拒收
//   summary:string;              //  摘要
//   gysDistributionGoodsList: GysDistributionGoods[];
// }
//
// // 分页结果结构
// interface PageResult {
//   current: number;
//   size: number;
//   total: number;
//   records: DistributionRecord[];
// }
interface apiResult {
  records: records[];
  total: number;
  size: number;
  current: number;
  orders: [],
  optimizeCountSql:boolean;
  searchCount: boolean;
  countId:  string;
  maxLimit: string,
  pages: number;
}//中层
// 接口统一返回结构
interface ApiResponse {
  success: boolean;
  message: string;
  code: number;
  result: apiResult;
}//外层

@Entry
@Component
struct peisongdan {
  @State editLogText: string = ''
  @State isEditMode: boolean = false
  @State showToast: boolean = false
  @State toastMessage: string = ''
  @State selectedStatus: string = '0'; // 默认为“未配送”
  @State distributionRecords: records[] = [];
  @State currentPage: number = 1;
  @State totalPages: number = 1;

  @State receivedToken: string ='';
  @State tenantId: number = 0;

  @State selectedUnit: string = '请选择需求单位'
  @State selectedDate: string = '请选择供应日期'
  @State selectDate: Date = new Date() // 默认显示当前日期
  @State upload:number  = 0;//审核栏的状态量
  @State showPopup: boolean = false//判断单据日志打印不是我写的
  @State selectedStatusIndex :  number = 0//根据读到数据加载卡片，现在没接仅测试使用
  private unitOptions = [
    '选择需求单位',
    '实验第二学校（库房）',
    '实验第二学校餐厅'
  ]
  private static readonly statusButtonTitles: string[] = ['未配送', '配送中', '已收货', '已拒收', '已取消'];
  async onPageShow() {
    const params = router.getParams() as RouterParams;
    if (params?.token) {
      AppStorage.set('token', params.token);
    }
    if (params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
    }
    // 同步到组件状态
    this.receivedToken = AppStorage.get('token') ?? '';
    this.tenantId = AppStorage.get('tenantId') ?? 0;
    console.log('Received Token:', this.receivedToken);
    console.log('Received TenantId:', this.tenantId);
    const result = await this.Liuyangchaxun();
    if (result.success && result.result?.records) {
      this.distributionRecords = result.result.records;
    } else {
      this.distributionRecords = [];
    }
  }
  aboutToAppear() {
    if (this.unitOptions.length > 0) {
      this.selectedUnit = this.unitOptions[0]
    }
  }

  private async loadDistributionData(status: string){
    const result = await this.Liuyangchaxun(status);
    if (result.success && result.result) {
      this.distributionRecords = result.result.records || [];
      this.totalPages = result.result.total;
    } else {
      this.distributionRecords = [];
    }
  }

  // private async fetchDistributionList(status: string, pageNo: number = 1, pageSize: number = 10): Promise<ApiResponse> {
  //   const httpRequest = http.createHttp();
  //   try {
  //     const response = await httpRequest.request(
  //       'https://api.suoeryun.com/ifood/jeecg-supplier/supplier/gysDistributionManagement/list',
  //       {
  //         method: http.RequestMethod.GET,
  //         header: {
  //           'Content-Type': 'application/x-www-form-urlencoded'
  //         },
  //         extraData: {
  //           status,
  //           pageNo,
  //           pageSize
  //         }
  //       }
  //     );
  //
  //     if (response.responseCode === 200) {
  //       return JSON.parse(response.result as string);
  //     } else {
  //       console.error('请求失败:', response.responseCode);
  //       return {
  //         success: false,
  //         message: `HTTP Error: ${response.responseCode}`,
  //         code: response.responseCode,
  //         result: null
  //       };
  //     }
  //   } catch (error) {
  //     console.error('请求异常:', error);
  //     return {
  //       success: false,
  //       message: '网络请求失败',
  //       code: 500,
  //       result: null
  //     };
  //   }
  // }

  build() {
    Column() {
      Row() {
        ForEach(peisongdan.statusButtonTitles, (item: string, index: number) => {
          Button(item)
            .width('20%')
            .height(40)
            .backgroundColor(this.selectedStatusIndex === index ? '#E8F5E9' : '#F5F5F5')
            .fontColor(this.selectedStatusIndex === index ? '#07C160' : '#666666')
            .fontWeight(this.selectedStatusIndex === index ? FontWeight.Bold : FontWeight.Normal)
            .borderRadius(0)
            .borderWidth(0)
            .onClick(() => {
              this.selectedStatusIndex = index;
              this.selectedStatus = index.toString(); // 如果你还需要传递状态给接口
             // this.currentPage = 1;
              this.Liuyangchaxun(index.toString());
            });
        });
      }
      .width('100%')
      .margin({ bottom: 20 })


      Row() {
        Column() {Text(this.selectedDate)
          .font({ size: 12 })
          .width('60%')
          .height(40)
          .textAlign(TextAlign.Center)
          .borderRadius(4)
          .borderWidth(1)
          .borderColor('#CCCCCC')
          .onClick(() => {
            this.showDateDialog()
          })
          .borderWidth(0) // 去除边框
        }
        .width('50%')
        Column() {
          Text('批量设置')
          .font({ size: 15 })
          .width('25%')
          .height(40)
          .fontColor('#ff3bca1c')
          .textAlign(TextAlign.Center)
          .borderRadius(4)
          .borderWidth(1)
          .borderColor('#ff3bca1c')
          .onClick(() => {
            this.showPopup = true
          })
          .borderWidth(2)
        }
        .width('50%')
      }
      .width('100%')
      .margin({ bottom: 15 })

      Scroll() {
        Column() {
          if (this.distributionRecords.length > 0) {
            ForEach(this.distributionRecords, (record: records) => {
              this.DistributionCardBuilder(record);
            });
          } else {
            Text('- 暂无相关数据 -')
              .position({ x: 110, y: 180 });
          }
        }
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding({top:20})
    // .backgroundColor('#F5F5F5')

  }

  @Builder
  private DistributionCardBuilder(record: records) {
    Column() {
      Text(record.schoolName)
        .fontSize(20)
        .fontColor('#333333')
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 });

      Column({ space: 8 }) {
        Row() {
          Text('单据号:')
            .width('30%')
            .fontSize(14)
            .fontColor('#666666');
          Text(record.documentNo)
            .width('70%')
            .fontSize(14)
            .fontColor('#333333');
        }

        Row() {
          Text('供应时间:')
            .width('30%')
            .fontSize(14)
            .fontColor('#666666');
          Text(`${record.supplyDate} 上午`)
            .width('70%')
            .fontSize(14)
            .fontColor('#333333');
        }

        Row() {
          Text('需求单位:')
            .width('30%')
            .fontSize(14)
            .fontColor('#666666');
          Text(record.schoolName + '(库房)')
            .width('70%')
            .fontSize(14)
            .fontColor('#333333');
        }

        Row() {
          Text('下单人:')
            .width('30%')
            .fontSize(14)
            .fontColor('#666666');
          Text('系统用户')
            .width('70%')
            .fontSize(14)
            .fontColor('#333333');
        }

        Row() {
          Text('下单电话:')
            .width('30%')
            .fontSize(14)
            .fontColor('#666666');
          Text(record.deliveryPhone || '无')
            .width('70%')
            .fontSize(14)
            .fontColor('#333333');
        }

        Row() {
          Text('摘要:')
            .width('30%')
            .fontSize(14)
            .fontColor('#666666');
          Text(record.summary || '无')
            .width('70%')
            .fontSize(14)
            .fontColor('#333333');
        }
      }
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .onClick(() => {
        // 跳转到详情页
        // router.push({
        //    uri: 'pages/peisongyemian',
        //    params: { record: JSON.stringify(record) } // 传递配送记录数据
        // });
      });
    }
    .backgroundColor(Color.White)
    .border({ width: 2, color: '#00C853', radius: 8 })
    .shadow({ radius: 6, color: '#CCCCCC', offsetX: 2, offsetY: 4 })
    .padding({ left: 16, right: 16, top: 16, bottom: 16 });
  }

  // 时间选择
  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        // 使用可选链和默认值保证安全性
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()

        this.selectDate = new Date(year, month - 1, day)
        this.selectedDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

  private async Liuyangchaxun(status?: string): Promise<ApiResponse> { //这个请求是针对查询列表的
    try {
      const httpRequest = http.createHttp();

      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-supplier/supplier/gysDistributionManagement/list',
        {
          method: http.RequestMethod.GET,
          header: {
            //'Content-Type': 'application/json',
            'Tenant-Id': this.tenantId.toString(),
            'X-Access-Token': this.receivedToken
          },
          extraData:
          `status=${status?.toString() ?? ''}`
        }
      );
      const emptyResult: apiResult = {
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
      const jsonData = JSON.parse(response.result as string) as ApiResponse;
      console.log('好耶', jsonData.result.records[1].createBy );
      return {
        success: jsonData.code === 200,
        code: jsonData.code,
        result: jsonData.result,
        message: jsonData.message,
        //relTenantIds:jsonData.result.userInfo.relTenantIds
      };

    } catch (error) {
      console.error('Login Error:', JSON.stringify(error));
      return {
        success: false,
        code: 500,
        result: {
          // 符合 liuyangResult 的空结构
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
  } //接口函数
}