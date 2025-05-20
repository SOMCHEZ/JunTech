import router from '@ohos.router';
import http from '@ohos.net.http';
// 定义接收的参数类型

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
  @State selectedUnit: string = '选择需求单位'
  @State selectedDate: string = '请选择供应日期'
  @State selectDate: Date = new Date()
  @State RecipeFormData: RecipeFormData[] =[]
  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上
  @State unitId: string  ="";
  @State upload:boolean  = false;
  private unitOptions = [
    '选择需求单位',
    '实验第二学校（库房）',
    '实训第二学校餐厅'
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
    console.log('laofushinanniang', this.unitId);
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



  build() {
    Column() {
      Row() {
        Button('未上报')
          .width('50%')
          .height(40)
          .backgroundColor(this.x === 0 ? '#E8F5E9' : '#F5F5F5')
          .fontColor(this.x === 0 ? '#07C160' : '#666666')
          .fontWeight(this.x ===0?FontWeight.Bold : FontWeight.Normal)
          .borderRadius(0)// 去除圆角
          .borderWidth(0)// 去除边框
          .onClick(() => {
            this.x = 0
            this.upload=false
            this.onPageShow() // 重新加载数据
          })

        Button('已上报')
          .width('50%')
          .height(40)
          .backgroundColor(this.x === 1 ? '#E8F5E9' : '#F5F5F5')
          .fontColor(this.x === 1 ? '#07C160' : '#666666')
          .fontWeight(this.x ===1?FontWeight.Bold : FontWeight.Normal)
          .borderRadius(0)
          .borderWidth(0)
          .onClick(() => {
            this.x = 1
            this.upload=true
            this.onPageShow() // 重新加载数据
          })
      }
      .width('100%')
      .margin({ bottom: 20 })


      Row({space:40}) {
        Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
          .value(this.unitOptions[0])
          .onSelect((index: number) => {
            this.selectedUnit = this.unitOptions[index]
            this.onPageShow() // 选择单位后自动刷新
          })

          .margin(10)
          .width('40%')
          .height(40)
          .font({ size: 10 })

        Select([])
          .value(this.selectedDate)
          .onClick(() => {
            this.showDateDialog()
          })
          .margin(10)
          .width('40%')
          .height(40)
          .font({ size: 10 })

      }
      .width('100%')
      .margin({ bottom: 15 })


      Column() {

        if (this.RecipeFormData.filter(item => {
          const statusMatch = this.x === 0 ?
            item.planningStatus === '1' :
            item.planningStatus === '5';
          const unitMatch = this.selectedUnit === '选择需求单位' ||
            item.photoUri === this.selectedUnit;
          const dateMatch = this.selectedDate === '请选择供应日期' ||
            item.date === this.selectedDate;
          return statusMatch && unitMatch && dateMatch;
        }).length > 0) {
          List(){
            ForEach(this.RecipeFormData.filter(item => {
              // 核心筛选逻辑
              const statusMatch = this.x === 0 ?
                item.planningStatus === '1' :
                item.planningStatus === '5';

              // 添加单位筛选（默认选项时显示全部）
              const unitMatch = this.selectedUnit === '选择需求单位' ||
                item.photoUri === this.selectedUnit;

              // 添加日期筛选（默认选项时显示全部）
              const dateMatch = this.selectedDate === '请选择供应日期' ||
                item.date === this.selectedDate;

              return statusMatch && unitMatch && dateMatch;
            }), (formData: RecipeFormData) => {
              ListItem()
              {
                //中间卡片部分神中神
                Column() {
                  Text(formData.photoUri?? 'N/A')
                    .width('100%')
                    .height(30)
                    .padding({ left: 10 })
                    .backgroundColor('#E8F5E9') // 背景色区分标题
                    .fontColor('#2E7D32') // 深绿色字体
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)

                  Column({ space: 10 }) {
                    Row() {
                      Text('供应时间：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      Text(formData.date ?? 'N/A')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                      if (this.upload) {
                        Image($r('app.media.approved'))
                          .width('30%')
                          .position({ top: -20, right: 1})
                      }else  {
                        Image($r('app.media.notReported'))
                          .width('30%')
                          .position({ top: -20, right: 1})
                        //.visible(formData.status === '已上报')
                      }
                    }

                    .justifyContent(FlexAlign.Start)

                    Row() {
                      Text('需求单号：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      Text('XQ20250510006')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')

                    }
                    .justifyContent(FlexAlign.Start)

                    Row() {
                      Text('需求类型：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      Text(formData.mealType ?? 'N/A')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')

                    }
                    .justifyContent(FlexAlign.Start)
                    Row() {
                      Text('用餐类型：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      Text(formData.diningType ?? 'N/A')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    .justifyContent(FlexAlign.Start)
                    Row() {
                      Text('餐别：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      Text(formData.place ?? 'N/A')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    .justifyContent(FlexAlign.Start)
                    Row() {
                      Text('制单人：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      Text(formData.human??'人')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    Row() {
                      Text('制单时间：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      Text(formData.recipeName ?? 'N/A')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    Row() {
                      Text('摘要：')
                        .width('30%')
                        .fontSize(12)
                        .fontColor('#333333')
                      Text(formData.summary??'无')
                        .width('70%')
                        .fontSize(12)
                        .fontColor('#666666')
                    }
                    //以上报按钮
                    if (this.upload){
                      Row({space:83}){
                        Button('复制订单')
                          .backgroundColor('#ffffffff')
                          .fontColor('#4CAF50')
                          .fontSize(10)
                          .borderRadius(12)
                          .border({
                            color: '#4CAF50',
                            width: 1
                          })
                          .onClick(() => {
                          })
                        Button('单据日志')
                          .backgroundColor('#ffffffff')
                          .fontColor('#4CAF50')
                          .fontSize(10)
                          .borderRadius(12)
                          .border({
                            color: '#4CAF50',
                            width: 1
                          })
                          .onClick(() => {
                          })
                      }
                    }
                    else {
                      // 操作按钮
                      Row({ space: 5 }) {
                        Button('重新编辑')
                          .backgroundColor('#ffffffff')
                          .fontColor('#4CAF50')
                          .fontSize(10)
                          .borderRadius(12)
                          .border({
                            color: '#4CAF50',
                            width: 1
                          })
                          .onClick(() => {
                            console.log('CACACACCACACACAC',this.unitId);
                            router.pushUrl({
                              url: 'pages/addPlan',  params: {
                                unitId:this.unitId
                              } })

                          })
                        Button('单据日志')
                          .backgroundColor('#ffffffff')
                          .fontColor('#4CAF50')
                          .fontSize(10)
                          .borderRadius(12)
                          .border({
                            color: '#4CAF50',
                            width: 1
                          })
                        Button('删除单据')
                          .backgroundColor('#ffffffff')
                          .fontColor('#4CAF50')
                          .fontSize(10)
                          .borderRadius(12)
                          .border({
                            color: '#4CAF50',
                            width: 1
                          })
                          .onClick(() => {
                            this.RecipeFormData = this.RecipeFormData.filter(item => item !== formData)
                          })
                      }
                    }
                  }
                  .padding({ left: 10, right: 10, top: 5, bottom: 10 })
                  .backgroundColor(Color.White)
                  .width('100%')
                  .justifyContent(FlexAlign.Start)
                }
                //.padding({ left: 1, right: 10, top: 5, bottom: 10 })
                .backgroundColor('#4CAF50')
                .width('90%')
                .height('auto')
                .alignItems(HorizontalAlign.Center)
                .border({
                  width: 2,
                  color: '#4CAF50',
                  radius: 8
                })
                .shadow({
                  radius: 5,
                  color: '#4CAF50',
                  offsetX: 10,
                  offsetY: 10
                })
                .onClick(() => {
                  if (this.upload) {
                    router.pushUrl({
                      url: 'pages/uploadcase' })

                  }

                })
              }
              .width('100%')
              .margin({left:10,right: 10, bottom:10 })
            })
          }

          .width('100%')
          .borderRadius(8)
        } else {
          Column() {
            Text('- 暂无相关数据 -')
              .position({
                x: 110,
                y: 180
              })
          }
        }

      }
      .width('100%')
      //.backgroundColor('#f2dbdada')
      .layoutWeight(1)

      Button('新建上报计划', { type: ButtonType.Capsule })
        .width('100%')
        .height(50)
        .backgroundColor('#02BC65')
        .fontColor('#FFFFFF')
        .margin({ top: 20 })
        .onClick(() => {
          // 手动构造一个新的单据对象并添加进数组
          // const newForm: RecipeFormData = {
          //   date: '2025-04-05',
          //   recipeName: '新菜谱',
          //   mealType: '早餐',
          //   diningType: '堂食',
          //   place: '食堂A'
          // };
          // this.RecipeFormData.push(newForm);
          router.pushUrl({
            url: 'pages/addPlan',
            params: {
              token: this.receivedToken,
              tenantId: this.tenantId,
              unitId: this.unitId,
            }})
          console.log('rel111',this.unitId);
        })
    }

    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#F5F5F5')

  }

  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        // 使用可选链和默认值保证安全性
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth()+1
        const day = value.day ?? new Date().getDate()

        this.selectDate = new Date(year, month , day)
        this.selectedDate = `${year}-${(month+1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;

      }

    })
  }

}