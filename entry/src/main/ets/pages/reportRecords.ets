import router from '@ohos.router';
import http from '@ohos.net.http';


AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);

interface UserInfo {
  id: string;
  username: string;
  clientType: string;
  realname: string;
  avatar: string | null;
  relTenantIds:number;
  // 其他字段根据实际API响应补充...
}

interface MealRecordInfo {
  position: string;
  images: string;
}

interface reportResponse {
  code: number;
  message: string;
  result: reportResult;
  timestamp: number;
}

interface reportResult {
  userInfo: UserInfo;
  token: string;
}

interface reportHandlerResult{
  success: boolean;
  code?: number;
  userInfo?: UserInfo;
  token?: string;
  message?: string;
  relTenantIds?:number;
}

interface RouteParams {//接口传递参数定义
  token?: string;
  relTenantIds?: number;
  unitId?: string;
}

interface SelectOption{
  value: string;
  label: string;
}

// Page1.ets
@Entry
@Component
struct Page1 {
  @State selectedPosition: string = ''
  @State private selectedUnitIndex:string = '实训第二学校餐厅';
  @State private selectedMealIndex:string = '其他';
  @State selectedUnit: string = ''
  @State selectedMeal: string = '' // 新增：选中的餐别
  @State name: string = ''
  @State evaluation: string = ''
  @State charCount: number = 0
  @State date: string = '选择日期'
  @State selectedDate: string = '请选择供应日期'
  @State selectDate: Date = new Date()
  @State dates: string = '请选择'
  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上
  @State UnitId: string  ="";

  private unitOptions: Array<SelectOption> = [
    { value: '实训第二学校餐厅', label: '实训第二学校餐厅' },
    { value: '其他单位', label: '其他单位' }
  ];

  // 新增：餐别选项列表
  private mealOptions: Array<SelectOption> = [
    { value: '0', label: '其他' },
    { value: '1', label: '早餐' }
  ];
  async onPageShow() {//这是一个接收传递参数的方法
    // 使用接口类型断言
    const params = router.getParams() as RouteParams;
    console.log('report', params?.token);// 打印接收到的参数
    console.log('report', params?.relTenantIds);//  打印接收到的参数

    // 安全取值如果返回值空，则使用appsetcreat中所预保存的token和id
    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
      //this.receivedToken = params.token;
    }

    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
      //this.tenantId = params.relTenantIds;
    }

    if (!AppStorage.get('unitId') && params?.unitId) {
      AppStorage.set('unitId', params.unitId);
      //this.UnitId = params.unitId;
    }

    // 同步到组件状态
    this.receivedToken = AppStorage.get('token')??'';
    this.tenantId = AppStorage.get('tenantId')??0;
    this.UnitId = AppStorage.get('unitId') ?? '';
    console.log('rel',this.UnitId);
    console.log('UID', params?.unitId);
    //const result = await this.Houchuchaxun();// 调用Houchuchaxun方法这个函数是用来查数据的
    //console.log('houchu1', result); // 打印返回结果
  }

  build() {
    Column() {

      Text('陪餐记录')
        .fontSize(24)
        .margin(20)
      Row(){
        Text("选择日期")
   //   .fontColor(Color.Black)
   //   .fontSize(16)
   //   Text(this.dates)
          Select([])
            .onClick(() => {
              this.showDateDialog()
            })
            .value(this.dates)
            .margin(10)
            .width('70%')
            .margin({left:20,right:0,bottom:10})
}

      Row(){
        Text("提交单位")
          .fontColor(Color.Black)
          .fontSize(16)
        Select(this.unitOptions)
          .value('请选择')
          .selected(this.unitOptions.findIndex(item => item.label === this.selectedUnitIndex))
          .onSelect((index: number) => {
            //this.selectedUnitIndex = index;
            this.selectedUnitIndex = this.unitOptions[index].value;
          })
          .margin(10)
          .width('70%')
          .margin({left:20,right:0,bottom:10})
      }

      Row(){
        Text("餐别选择")
          .fontColor(Color.Black)
          .fontSize(16)

        Select(this.mealOptions)
          .value('请选择')
          .selected(this.mealOptions.findIndex(item => item.label === this.selectedMealIndex))
          .onSelect((index: number) => {
            this.selectedMealIndex = this.mealOptions[index].value;
          })
          .margin(10)
          .width('70%')
          .margin({left:20,right:0,bottom:10})

      }

      Button({type: ButtonType.Normal})
      {
        Text("提交")
          .margin({top: 1,bottom: 1})
          .fontColor(Color.White)
          .width('90%')
          .height(40)
          .textAlign(TextAlign.Center)
      }
      .width('90%')
      .height(40)
      .margin({top: 250})
      .borderRadius(5)
      .backgroundColor(Color.Green)
      .onClick(async() => {
        router.pushUrl({
          url: 'pages/peicanRecords',  params: {
            token: this.receivedToken,
            tenantId: this.tenantId
          } })
        const result = await this.report();
        // this.unitId = result.token!;
      })


    }
    .width('100%')
    .height('100%')
  }
  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => { // 使用系统内置类型
        if (value.year && value.month && value.day) {
          this.dates = `${value.year}-${value.month+1}-${value.day}`;
        }
      }
    })
  }

  private async report(): Promise<reportHandlerResult> {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxMealRecord/add',
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json',
            'Tenant-Id':this.tenantId.toString(),
            'X-Access-Token':this.receivedToken
          },
          extraData: JSON.stringify({
            "mealDate": this.dates,
            "mealCategory": "0",
            "repastNum": "",
            "withNum": "",
            "xxMealRecordInfoList": [
              {
                "position": "测试",
                "images": "https://admin.suoeryun.com/pcUpload/32-32-0430180520.png"
              },
              {
                "position": "测试",
                "images": "https://admin.suoeryun.com/pcUpload/32-32-0430180526.png"
              }
            ] as Array<MealRecordInfo>,
            "demandUnit": "1910528462460329985",
            "demandUnitName": this.selectedUnitIndex
          }
          )
        }
      );

      if (response.responseCode !== 200) {
        return {
          success: false,
          message: `HTTP Error: ${response.responseCode}`
          // 添加其他错误处理逻辑
        };
      }

      const jsonData = JSON.parse(response.result as string) as reportResponse;
      //console.log('', response.responseCode);
      //console.log('',jsonData.code);
      return {
        success: jsonData.code === 200,
        code: jsonData.code,
        //userInfo: jsonData.result.userInfo,
        // token: jsonData.result.token,
        message: jsonData.message,
        relTenantIds:jsonData.result.userInfo.relTenantIds
      };
    } catch (error) {
      //console.error('Login Error:', JSON.stringify(error));
      return {
        success: false,
        message: 'error!'
      };
    }
  }
}
