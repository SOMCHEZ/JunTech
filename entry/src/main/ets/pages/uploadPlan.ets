import router from '@ohos.router';
import http from '@ohos.net.http';
// 定义接收的参数类型

AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);
AppStorage.setOrCreate('unitId', '');

interface RecipeFormData {
  date?: string;
  recipeName?: string;
  mealType?: string;
  diningType?: string;
  place?: string;
  photoUri?: string;
}

interface  records{//定义接口返回类型
  id?: number;
  schoolId: string;
  schoolName:  string;
  unitId: string;
  unitName: string;
  userName: string;// 后端返回的姓名
  //realname: string;
  idCard?: string;
  portraitPhoto?:string;
  position:  string;//  后端返回的职位
  tel: string;// 后端返回的电话
  type: string;//  后端返回的职位类型
  type_dictText:string;// 后端返回的职位类型
  licenceIssuing: string;//  后端返回的营业执照有效期
  healthNumber: string;//  后端返回的健康证号
  healthUrl?: string;  // 后端返回的健康证图片
  healthStartTime: string;// 后端返回的营业执照有效期
  healthEndTime:  string;// 后端返回的营业执照有效期
  photoQualification: string;//  后端返回的营业执照图片
  remark: string;//  后端返回的备注
  inspectionType?:number//  后端返回的职位类型
  version: number;//  后端返回的版本
  canteenId:  string;// 后端返回的食堂id
  wxopenId: string;// 后端返回的微信openid
  tenantId:  number;//  后端返回的租户id
  demandUnitIds:string;// 后端返回的食堂id
  code?: number;// 后端返回的code

  // 其他字段根据实际API响应补充...
}

interface RouteParams {//接口传递参数定义
  token?: string;
  relTenantIds?: number;
  unitId?: string;
}

interface HouchuResult {
  records: records[];
  //token: string;
}

interface HouchuResponse {
  code: number;
  message: string;
  result: HouchuResult;
  timestamp: number;
}

interface HouchuHandlerResult {
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
  @State selectedText: RecipeFormData[] =[]
  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上
  @State unitId: string  ="";
  private unitOptions = [
    '选择需求单位',
    '实验第二学校（库房）',
    '实验第二学校餐厅'
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
    this.unitId = AppStorage.get('unitId') ?? '';
    console.log('rel',this.unitId);
    console.log('UID', params?.unitId);

    const result = await this.Houchuchaxun();
    //const result = await this.Houchuchaxun();// 调用Houchuchaxun方法这个函数是用来查数据的
    //console.log('houchu1', result); // 打印返回结果

    if (result.records && result.records.length > 0) {

      this.unitId = result.records?.find(item =>//存放uid
      item?.unitId && item.unitId.trim() !== '',
      )?.unitId ?? 'default_unit_id'

    } else {
      //console.error('未获取到有效数据');
      this.unitId = ''; // 设置默认值
    }

    //   let params = router.getParams()
    //   if (params && params.toString()) {
    //     this.selectedText.push(params as RecipeFormData)
    //   }
    // if (this.unitOptions.length > 0) {
    //   this.selectedUnit = this.unitOptions[0]
    // }
  }


  private async Houchuchaxun(): Promise<HouchuHandlerResult> { //这个请求是针对查询后厨人员列表的
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
      const jsonData = JSON.parse(response.result as string) as HouchuResponse;
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
            })
        }
        .width('100%')
        .margin({ bottom: 20 })


        Row({space:40}) {
          Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
            .value(this.unitOptions[0])
            .onSelect((index: number) => {
              this.selectedUnit = this.unitOptions[index]
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
          if (this.selectedText.length  >0) {
              List(){
                ForEach(this.selectedText, (formData: RecipeFormData) => {
                    ListItem()
                    {
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
                              Text('人')
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
                              Text('无')
                                .width('70%')
                                .fontSize(12)
                                .fontColor('#666666')
                            }



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
                                  router.pushUrl({
                                    url: 'pages/addPlan' })
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
                                  this.selectedText = this.selectedText.filter(item => item !== formData)
                                })
                            }
                          }
                          .backgroundColor(Color.White)
                          .width('100%')
                          .justifyContent(FlexAlign.Start)
                        }
                        //.padding({ left: 1, right: 10, top: 5, bottom: 10 })
                        .backgroundColor('#4CAF50')
                        .width('80%')
                        .height('auto')
                        .alignItems(HorizontalAlign.Center)
                        .border({
                          width: 2,
                          color: '#4CAF50',
                          radius: 8
                        })
                    }
                    .width('100%')
                    .margin({left:0,right: 10, bottom:10 })
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
        .backgroundColor('#f2dbdada')
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
            // this.selectedText.push(newForm);
            router.pushUrl({
              url: 'pages/addPlan',
              params: {
                token: this.receivedToken,
                tenantId: this.tenantId,
              }})
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
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()

        this.selectDate = new Date(year, month - 1, day)
        this.selectedDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

}