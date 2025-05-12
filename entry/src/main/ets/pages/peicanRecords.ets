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
  userInfo?: UserInfo;
  token?: string;
  message?: string;
  relTenantIds?:number;
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
  @State peicanRecord: peicanRecord[] = [];
  private weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六']

  async onPageShow() { //这是一个接收传递参数的方法
    // 使用接口类型断言
    const params = router.getParams() as RouteParams;
    console.log('peican', params?.token);// 打印接收到的参数
    // 安全取值如果返回值空，则使用appsetcreat中所预保存的token和id
    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
      //this.receivedToken = params.token;
    }
    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
      //this.tenantId = params.relTenantIds;
    }
    // 同步到组件状态
    this.receivedToken = AppStorage.get('token') ?? '';
    this.tenantId = AppStorage.get('tenantId') ?? 0;

    const result = await this.peicanQuest(); // 调用Houchuchaxun方法这个函数是用来查数据的


    if (result.success && result.records) {
      this.peicanRecord = result.records.map(item => ({
        mealDate: item.mealDate || '',          // 映射姓名
        mealCategory: item.mealCategory || '',     // 映射工作单位
        repastNum: item.repastNum || '未知状态',
        withNum: item.withNum || '未设置',
        xxMealRecordInfoList: item.xxMealRecordInfoList || '未设置',
        demandUnitName: item.demandUnitName || '未知单位'
      } as peicanRecord));
    }
  }

  private async peicanQuest(): Promise<peicanHandlerResult> {
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

      if (response.responseCode !== 200) {
        //console.error('Login Error:'+response.responseCode);
        return {
          success: false,
          message: `HTTP Error: ${response.responseCode}`
          // 添加其他错误处理逻辑
        };
      }
      console.log('slfj'+response.result.toString())
      const jsonData = JSON.parse(response.result as string) as peicanResponse;
      console.log('11',jsonData.result.records[1]);
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
      // 新增配餐记录标题
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
    //.padding({ vertical: 8 })
  }

  build() {
    Column() {
      // 头部区域
      this.CalendarHeaderBuilder()

      // 日历主体
      Column() {
        this.WeekDaysBuilder()

        // 日期行
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
            .width('14.28%')
            .height(50)
            .onClick(() => {
              const newDate = new Date(this.selectedDate)
              newDate.setDate(date)
              this.selectedDate = newDate
            })
          })
        }
      }
      .backgroundColor('#00C853')

      // 底部上传按钮
      Button('上传陪餐记录', { type: ButtonType.Capsule })
        .width('90%')
        .height(40)
        .backgroundColor('#00C853')
        .fontColor('#FFFFFF')
        .position({x:20 , y: '90%'})
        .onClick(() => {
                  router.pushUrl({
                     url: 'pages/reportRecords',
                    params: {
                      token: this.receivedToken,
                      relTenantIds: this.tenantId
                    }
                  });
        })

      // 暂无数据提示
      Text('~ 暂无相关数据 ~')
        .fontSize(15)
        .fontColor('#BBBBBB')
        .margin({ top: 30 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}