import { router } from '@kit.ArkUI';
import http from '@ohos.net.http';

AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);
AppStorage.setOrCreate('unitId', '');

interface RouteParams {
  token?: string;
  relTenantIds?: number;
}

interface PeiCanMessage {
  mealDate: string;
  schoolName: string;
  mealCategory_dictText: string;
  dutposition: string;
}

interface ResultData {
  total: number;
  records: PeiCanMessage[];
}

interface ResponseData {
  success: boolean;
  message: string;
  code: number;
  result: ResultData | null;
}
interface PageParams {
  record?: string;
}
@Entry
@Component
struct CalendarPage {
  @State private currentDate: Date = new Date();
  @State private selectedDate: Date = new Date();
  @State private receivedToken: string = '';
  @State private tenantId: number = 0;
  @State private unitId: string = '';
  @State private DataList: PeiCanMessage[] = [];
  @State private TempDataList: PeiCanMessage[] = [];

  aboutToAppear() {
    const params = router.getParams() as PageParams; // 使用接口进行类型断言
    if (params?.record) {
      this.DataList.unshift(JSON.parse(params.record));
    }
  }

  async onPageShow() {
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
      this.DataList = result.result.records;
      this.TempDataList = this.DataList.filter((item) => item.mealDate === this.formatDate(this.selectedDate));
    }
  }

  private weekDays: string[] = ['一', '二', '三', '四', '五', '六', '日'];

  private async peicanQuest(): Promise<ResponseData> {
    try {
      const httpRequest = http.createHttp();

      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxMealRecord/list',
        {
          method: http.RequestMethod.GET,
          header: {
            'Tenant-Id': this.tenantId.toString(),
            'X-Access-Token': this.receivedToken,
          },
        }
      );

      if (response.responseCode !== 200) {
        console.error('Login Error8:' + response.responseCode);
        return {
          success: false,
          message: `HTTP Error: ${response.responseCode}`,
          code: response.responseCode,
          result: null,
        };
      }

      const jsonData = JSON.parse(response.result as string) as ResponseData;
      return jsonData;
    } catch (error) {
      console.error(error);
      return {
        success: false,
        message: '服务器繁忙',
        code: 500,
        result: null,
      };
    }
  }

  private getDatesForWeek(): number[] {
    const firstDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), 1);
    const lastDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 0);
    const currentDayOfWeek = this.selectedDate.getDay();
    const startDate = new Date(this.selectedDate);
    startDate.setDate(this.selectedDate.getDate() - currentDayOfWeek);

    const dates: number[] = [];
    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate);
      currentDate.setDate(startDate.getDate() + i);
      dates.push(currentDate.getDate());
    }
    return dates;
  }

  private changeWeek(increment: number) {
    const newDate = new Date(this.selectedDate);
    newDate.setDate(this.selectedDate.getDate() + increment * 7);
    this.currentDate = new Date(newDate);
    this.selectedDate = newDate;
  }

  private formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  @Builder
  private CalendarHeaderBuilder() {
    Column() {
      Text('陪餐记录')
        .fontSize(24)
        .fontColor('#FFFFFF')
        .margin({ bottom: 8 });

      Row() {
        Text(`${this.currentDate.getFullYear()}年${this.currentDate.getMonth() + 1}月`)
          .fontSize(20)
          .fontColor('#FFFFFF');

        Blank();

        Row() {
          Text('<')
            .font({ size: 24 })
            .onClick(() => this.changeWeek(-1))
            .fontColor(Color.White);

          Text('>')
            .fontSize(24)
            .margin({ left: 20 })
            .onClick(() => this.changeWeek(1))
            .fontColor(Color.White);
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween);
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#00C853');
  }

  @Builder
  private WeekDaysBuilder() {
    Row() {
      ForEach(this.weekDays, (day: string) => {
        Text(day)
          .width('14.28%')
          .textAlign(TextAlign.Center)
          .fontColor('#FFFFFF');
      });
    }
  }
//卡片区域
  @Builder
  private RecordCardBuilder(record: PeiCanMessage) {
    Column() {
      Row() {
        Text(`${record.mealDate} ${record.mealCategory_dictText}陪餐记录`)
          .fontSize(30)
          .fontColor('#333');
      }
      .justifyContent(FlexAlign.Start);
    }
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .margin({ top: 15, bottom: 10 })
    .width('95%')
    .height(80)
    .shadow({ radius: 6, color: '#30000000', offsetX: 2, offsetY: 4 })
    .border({ width: 1, color: '#00C853' })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/detailPage',
        params: {
          schoolName: record.schoolName,
          mealDate: record.mealDate,
          mealCategory: record.mealCategory_dictText,
          dutposition: record.dutposition,
        },
      });
    });
  }

  build() {
    Column() {
      this.CalendarHeaderBuilder();

      Column() {
        this.WeekDaysBuilder();

        Row() {
          ForEach(this.getDatesForWeek(), (date: number) => {
            Column() {
              Stack() {
                if (date === this.selectedDate.getDate()) {
                  Circle()
                    .size({ width: 20, height: 20 })
                    .fill('#FFFFFF');
                }
                Text(`${date.toString().padStart(2, '0')}`)
                  .fontColor(date === this.selectedDate.getDate() ? '#00C853' : '#FFFFFF');
              }
            }
            .width('14.282039094572344908579867648657%')
            .height(50)
            .onClick(() => {
              const newDate = new Date(this.selectedDate);
              newDate.setDate(date);
              this.selectedDate = newDate;
              this.TempDataList = this.DataList.filter((item) => item.mealDate === this.formatDate(this.selectedDate));
            });
          });
        }
      }
      .backgroundColor('#00C853');

      if (this.TempDataList.length === 0) {
        Text('~ 暂无相关数据 ~')
          .fontSize(15)
          .fontColor('#BBBBBB')
          .margin({ top: 10 });
      } else {
        Scroll() {
          Column() {
            ForEach(this.TempDataList, (record: PeiCanMessage) => {
              this.RecordCardBuilder(record);
            });
          }
        }
        .height('60%')
        .margin({ top: 20});
      }

      Button('上传陪餐记录', { type: ButtonType.Capsule })
        .width('90%')
        .height(40)
        .backgroundColor('#00C853')
        .fontColor('#FFFFFF')
        .position({ x: 20, y: '90%' })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/reportRecords',
            params: {
              token: this.receivedToken,
              relTenantIds: this.tenantId,
            },
          });
        });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5');
  }
}