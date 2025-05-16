import { router } from '@kit.ArkUI'
import http from '@ohos.net.http';

AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);
AppStorage.setOrCreate('unitId', '');

interface RouteParams {
  token?: string;
  relTenantIds?: number;
}

interface  records{//定义接口返回类型
  id: string;
  mealDate: string;
  createBy:  string;
  mealCategory: string;
  repastNum: string;
  withNum: string;
  xxMealRecordInfoList: string;
  demandUnitName: string
}

interface UserInfo {
  id: string;
  username: string;
  clientType: string;
  realname: string;
  avatar: string | null;
  relTenantIds:number;
  // 其他字段根据实际API响应补充...
}

interface peicanResult {
  records: records[];
  //token: string;
}

interface peicanResponse {
  code: number;
  message: string;
  result: peicanResult;
  timestamp: number;
}

interface peicanHandlerResult{
  success: boolean;
  code?: number;
  message?: string;
  records?: records[];
}

interface peicanRecord extends records {
  mealDate: string;      // 对应原接口的realname
  mealCategory: string; // 对应原接口的unitName
  repastNum: string;    // 需确认来源字段
  withNum: string; // 对应healthStartTime
  xxMealRecordInfoList: string;// 对应healthEndTime
  demandUnit:string;//对应在职状态
  demandUnitName: string;// 对应原接口的position
}
interface RecordType {
  unit: string;
  meal: string;
  position: string;
  name: string;
  evaluation: string;
  date: string;
}

interface GeneratedTypeLiteralInterface_1 {
  record?: string;
}


interface PeiCanMessage{
  mealDate:string
  demandUnitName:string
  mealCategory_dictText:string
}
interface ResultData{
  total:number
  records:PeiCanMessage[]
}
interface ResponseData{
  success: boolean,
  message: string,
  code: number,
  result:ResultData|null
}



@Entry
@Component
struct CalendarPage {
  @State private currentDate: Date = new Date()
  @State private selectedDate: Date = new Date()
  @State selectedUnit: string = '所属单位';
  @State units: string[] = ['所属单位', '实训第二学校餐厅', '其他单位'];
  @State showDropdown: boolean = false;
  @State kitchenNumbers: number = 0;
  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上
  @State unitId: string ='';
  @State peicanRecord: records[] = []
  @State records: RecordType[] = [];

  @State DataList:PeiCanMessage[] = []
  private index:number = 0

  aboutToAppear() {
    const params = router.getParams() as GeneratedTypeLiteralInterface_1;
    if (params?.record) {
      this.records.unshift(JSON.parse(params.record));
    }
  }

  private weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六']

  async onPageShow() {
    this.index = 0
    const params = router.getParams() as RouteParams;
    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
    }
    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
    }
    this.receivedToken = AppStorage.get('token') ?? '';
    this.tenantId = AppStorage.get('tenantId') ?? 0;


    const result = await this.peicanQuest();
    if (result.success && result.result) {
      this.DataList = result.result.records
    }
  }

  private async peicanQuest(): Promise<ResponseData> {
    try {
      const httpRequest = http.createHttp();

      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxMealRecord/list',
        {
          method: http.RequestMethod.GET,
          header: { //'Content-Type': 'application/json',
            'Tenant-Id':this.tenantId.toString(),
            'X-Access-Token':this.receivedToken
          },
        }
      );
      console.log('response:',response.result)
      console.log('response:',response.responseCode)
      if (response.responseCode !== 200) {
        console.error('Login Error8:'+response.responseCode);
        return {
          success: false,
          message: `HTTP Error: ${response.responseCode}`,
          code: response.responseCode,
          result:null
        };
      }
      const jsonData = JSON.parse(response.result as string) as ResponseData;
      return jsonData

    } catch (error) {
      console.error( error);
      return {
        success: false,
        message: '服务器繁忙',
        code: 500,
        result: null
      };
    }
  }

  // 获取当前周的日期数组
  private getDatesForWeek(): number[] {
    const firstDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), 1)
    const lastDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 0)
    const currentDayOfWeek = this.selectedDate.getDay()
    const startDate = new Date(this.selectedDate)
    startDate.setDate(this.selectedDate.getDate() - currentDayOfWeek)

    const dates: number[] = []
    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate)
      currentDate.setDate(startDate.getDate() + i)
      dates.push(currentDate.getDate())
    }
    return dates
  }

  // 周切换功能
  private changeWeek(increment: number) {
    const newDate = new Date(this.selectedDate)
    newDate.setDate(this.selectedDate.getDate() + (increment * 7))
    this.currentDate = new Date(newDate)
    this.selectedDate = newDate
  }

  // 日历头部
  @Builder
  private CalendarHeaderBuilder() {
    Column() {
      Text('陪餐记录')
        .fontSize(24)
        .fontColor('#FFFFFF')
        .margin({ bottom: 8 })

      Row() {
        Text(`${this.currentDate.getFullYear()}年${this.currentDate.getMonth() + 1}月`)
          .fontSize(20)
          .fontColor('#FFFFFF')
        Blank()
        Row() {
          Text('<')
            .font({size: 24})
            .onClick(() => this.changeWeek(-1))
            .fontColor(Color.White)
          Text('>')
            .fontSize(24)
            .margin({ left: 20 })
            .onClick(() => this.changeWeek(1))
            .fontColor(Color.White)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#00C853')
  }


  // 星期标题行
  @Builder
  private WeekDaysBuilder() {
    Row() {
      ForEach(this.weekDays, (day: string) => {
        Text(day)
          .width('14.28%')
          .textAlign(TextAlign.Center)
          .fontColor('#FFFFFF')
      })
    }
  }

  // ... (其他代码保持不变)

  @Builder
  private RecordCardBuilder(record: PeiCanMessage,index:number) {
    Column() {
      Row() {
        Text(record.mealDate).fontColor('#666').fontSize(14)
        Text(record.demandUnitName).fontColor('#333').fontSize(16).margin({ left: 10 })
      }
      .justifyContent(FlexAlign.Start)

      Row() {
        Text(`餐别：${record.mealCategory_dictText}`).fontSize(14)
        Text('身份：教师').margin({ left: 15 }) // 确保这里显示的是字符串值
      }
      .margin({ top: 8 })

    }
    .padding(10)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ top: 10 })
    .width('90%')
    .shadow({ radius: 4, color: '#30000000', offsetX: 1, offsetY: 1 })
  }

  // ... (其他代码保持不变)


  build() {
    Column() {
      this.CalendarHeaderBuilder()

      Column() {
        this.WeekDaysBuilder()

        Row() {
          ForEach(this.getDatesForWeek(), (date: number) => {
            Column() {
              Stack() {
                if (date === this.selectedDate.getDate()) {
                  Circle()
                    .size({width:20 , height:20 })
                    .fill('#FFFFFF')
                }
                Text(`${date.toString().padStart(2, '0')}`)
                  .fontColor(date === this.selectedDate.getDate() ? '#00C853' : '#FFFFFF')
              }
            }
            .width('14.282039094572344908579867648657%')
            .height(50)
            .onClick(() => {
              const newDate = new Date(this.selectedDate)
              newDate.setDate(date)
              this.selectedDate = newDate
              console.log('selectedDate',this.selectedDate)
            })
          })
        }
      }
      .backgroundColor('#00C853')

      Button('上传陪餐记录', { type: ButtonType.Capsule })
        .width('90%')
        .height(40)
        .backgroundColor('#00C853')
        .fontColor('#FFFFFF')
        .position({x:20 , y: '90%'})
        .onClick(() => {
          router.pushUrl({
            url: 'pages/reportRecords',
            params:{
              token:this.receivedToken,
              relTenantIds:this.tenantId

            }
          });
          console.log('jinitaimei'+this.records);
        })

      if (this.DataList.length === 0) {
        Text('~ 暂无相关数据 ~')
          .fontSize(15)
          .fontColor('#BBBBBB')
          .margin({ top: 30 })
      } else {
        Scroll() {
          Column() {
            ForEach(this.DataList, (record: PeiCanMessage) => {
              this.RecordCardBuilder(record,this.index++)
            })
          }
        }
        .height('60%')
        .margin({ top: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}