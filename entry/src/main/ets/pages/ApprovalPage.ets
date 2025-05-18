import router from '@ohos.router';
import http from '@ohos.net.http';

AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);
AppStorage.setOrCreate('unitId', '');

interface RecipeFormData extends records{
  photoUri: string;//卡片名对应地点
  id?: string;
  date: string;// 供应时间
  recipeName: string;//制单时间
  mealType: string;//需求类型
  human: string;
  diningType: string;//用餐类型
  summary:  string;
  place: string;//餐别
  planningStatus:string;

}

interface records{//定义接口返回类型
  id?: string;
  createBy: string;
  createTime:  string;
  updateBy: string;
  updateTime: string;// 后端返回的姓名
  schoolId?: string;
  unitId: string;
  schoolName?:string;
  unitName:  string;
  unitType:  string;
  documentNo:string;// 后端返回的code
  supplyDate: string;
  supplyTime: string
  reportUserPhone: string
  auditTime: string
  supplyTime_dictText: string
  planningStatus: string
  rejectOpinion: string
  summary: string
  preparedBy: string
  reportUserName: string
  reportUserId: string
  reportDate: string
  tenantId: string
  requirementType: string
  requirementType_dictText: string
  planningFoodList: string
  izReplenishment: string
  stockId: string
  distributionId: string
  supplierRemark: string
  totalPrice: string
  izPastDue: string
  mealType: string
  mealType_dictText: string
  mealCategory: string
  mealCategory_dictText: string
  planningStatus_dictText: string
  // 其他字段根据实际API响应补充...
}

interface RouteParams {//接口传递参数定义
  token?: string;
  relTenantIds?: number;
  //unitId?: string;
}

interface XuqiuResult {
  records: records[];
  //token: string;
}

interface XuqiuResponse {
  code: number;
  message: string;
  result: XuqiuResult;
  timestamp: number;
}

interface XuqiuHandlerResult {
  success: boolean;
  code?: number;
  records?: records[];
  message?: string;
}


@Entry
@Component
struct ReportPlanPage {

  @State x: number = 0
  @State s: number = 0
  @State name: string = ''
  @State selectedUnit: string = '请选择需求单位'
  @State selectedDate: string = '请选择供应日期'
  @State selectDate: Date = new Date()
  @State RecipeFormData: RecipeFormData[] =[]
  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上
  @State unitId: string  ="";

  private unitOptions = [
    '选择需求单位',
    '实验第二学校（库房）',
    '实验第二学校餐厅'
  ]
  private days = [

  ]


  // 修改生命周期函数
  async onPageShow() {

    // 使用接口类型断言
    const params = router.getParams() as RouteParams;
    //console.log('houchu', params?.token);// 打印接收到的参数
    //console.log('houchu', params?.relTenantIds);//  打印接收到的参数

    // 安全取值如果返回值空，则使用appsetcreat中所预保存的token和id
    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
    }

    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
    }
    // 同步到组件状态
    this.receivedToken = AppStorage.get('token')??'';
    this.tenantId = AppStorage.get('tenantId')??0;

    const result = await this.Xuqiuchaxun();
    this.unitId = result?.records?.[0]?.unitId ?? '';
    console.log('牢莩不是男娘', this.unitId);
    //const result = await this.Houchuchaxun();// 调用Houchuchaxun方法这个函数是用来查数据的
    //console.log('houchu1', result); // 打印返回结果

    if (result.success && result.records) {
      this.RecipeFormData = result.records?.map((item: records) => ({
        id: item.id,
        date: item.supplyDate,
        recipeName: item.createTime,
        mealType: item.mealType_dictText,
        diningType: item.requirementType_dictText,
        human:item.reportUserName,
        summary: item.summary,
        place: item.mealType_dictText,
        photoUri:  item.unitName,
        planningStatus: item.planningStatus
      } as RecipeFormData));

    }else {
      console.error('数据加载失败:', result.message);
    }






    // const filteredRecords = result.records?.filter(item =>
    // this.selectedUnit === '选择需求单位' ||  // 显示全部
    //   item.unitName === this.selectedUnit // 按选中单位过滤
    // ) ?? [];
    //
    // if (result.success && filteredRecords) {
    //   this.RecipeFormData = filteredRecords.map((item: records) => ({
    //     id: item.id,
    //     date: item.supplyDate,
    //     recipeName: item.createTime,
    //     mealType: item.mealType_dictText,
    //     diningType: item.requirementType_dictText,
    //   } as RecipeFormData));
    //   console.log('444',this.RecipeFormData[1].id);
    //
    //
    //   const unitNames = result.records?.map(item => item.unitName) ?? [];
    //   const filteredUnitNames = unitNames.filter(Boolean);
    //   const uniqueUnits = Array.from(new Set(filteredUnitNames));
    //   this.unitOptions = ['所属单位', ...uniqueUnits];
    // }
  }


  private async Xuqiuchaxun(): Promise<XuqiuHandlerResult> { //这个请求是针对查询后厨人员列表的
    try {
      const httpRequest = http.createHttp();

      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxDemandPlanning/list',
        {
          method: http.RequestMethod.GET,
          header: {
            //'Content-Type': 'application/json',
            'Tenant-Id': this.tenantId.toString(),
            'X-Access-Token': this.receivedToken
          },
        }
      );

      if (response.responseCode !== 200) {
        //console.error('Login Error:'+response.responseCode);
        return {
          success: false,
          message: `HTTP Error: ${response.responseCode}`
          // 添加其他错误处理逻辑
        };
      }
      console.log('slfj' + response.result.toString())
      const jsonData = JSON.parse(response.result as string) as XuqiuResponse;
      console.log('11', jsonData.result.records[1]);
      return {
        success: jsonData.code === 200,
        code: jsonData.code,
        records: jsonData.result.records,
        message: jsonData.message,
        //relTenantIds:jsonData.result.userInfo.relTenantIds
      };

    } catch (error) {
      console.error('Login Error:', JSON.stringify(error));
      return {
        success: false,
        message: '服务器繁忙'
      }
    }
  }



  aboutToAppear() {
    if (this.unitOptions.length > 0) {
      this.selectedUnit = this.unitOptions[0]
    }
  }

  build() {

    Column() {

      Row() {
        Button('待审核')
          .width('35%')
          .height(40)
          // .backgroundColor(this.x === 0 ? '#E8F5E9' : '#F5F5F5')
          .backgroundColor(Color.White)
          .fontColor(this.x === 0 ? '#07C160' : '#666666')
          .fontWeight(this.x ===0?FontWeight.Bold : FontWeight.Normal)
          .borderRadius(0)// 去除圆角
          .borderWidth(0)// 去除边框
          .onClick(() => {
            this.x = 0
          })
        Button('已审批')
          .width('35%')
          .height(40)
          .backgroundColor(Color.White)
          // .backgroundColor(this.x === 1 ? '#E8F5E9' : '#F5F5F5')
          .fontColor(this.x === 1 ? '#07C160' : '#666666')
          .fontWeight(this.x ===1?FontWeight.Bold : FontWeight.Normal)
          .borderRadius(0)// 去除圆角
          .borderWidth(0)// 去除边框
          .onClick(() => {
            this.x = 1
          })

        Button('已驳回')
          .width('35%')
          .height(40)
          // .backgroundColor(this.x === 2 ? '#E8F5E9' : '#F5F5F5')
          .backgroundColor(Color.White)
          .fontColor(this.x === 2 ? '#07C160' : '#666666')
          .fontWeight(this.x ===2?FontWeight.Bold : FontWeight.Normal)
          .borderRadius(0)
          .borderWidth(0)
          .onClick(() => {
            this.x = 2
          })
      }
      .width('100%')
      .margin({ bottom: 20 })


      Row() {
        Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
          .value(this.unitOptions[0])
          .onSelect((index: number) => {
            this.selectedUnit = this.unitOptions[index]
          })

          .margin(10)
          .width('40%')
          .height(40)
          .font({ size: 12 })

        Text(this.selectedDate)
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
      .width('100%')
      .margin({ bottom: 15 })


      Column() {
        Column() {
          Text('- 暂无相关数据 -')
            .position({
              x: 120,
              y: 180
            })
        }
      }
      .width(360)
      .backgroundColor('#f2dbdada')
      .layoutWeight(1)


    }

    .width('100%')
    .height('100%')
    .padding({top:20})
    // .backgroundColor('#F5F5F5')



  }


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

}