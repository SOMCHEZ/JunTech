import router from '@ohos.router';
import http from '@ohos.net.http';
import prompt from '@ohos.prompt';

AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);

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

interface SampleFormData {
  id?: string;
  unitName?: string;
  reservedSampleDate?: string; // 留样日期
  createTime?: string;
  sampleType?: string;
  sampleType_dictText?: string;
  mealType?: string;
  mealCategory_dictText?: string;
  cabinetTemperature?: string;
  dishName?: string;
  putWeight?: string;
  destroyPerson?: string;
  destroyTime?: string;
  sampleImages?: string[];
  fridgeImages?: string[];
  remark?: string;

  isRemote?: boolean;
}

interface everydayremain{
  records: SampleFormData[],
  total: number,
}

interface ApiResponse {
  code: number;
  message: string;
  result?: everydayremain;
}

interface RouterParams {
  formData?: SampleFormData;
  token?: string;         // 新增：允许 token 属性
  relTenantIds?: number;  // 新增：允许 relTenantIds 属性
}

@Entry
@Component
struct remain_day {
  @State private scrollOffset: number = 0;
  @State samples: SampleFormData[] = [];
  @State filteredSamples: SampleFormData[] = [];
  @State receivedToken: string = ''; // 接收 token
  @State tenantId: number = 0;       // 接收租户 ID

  // 当前显示的月份和年份（响应式状态变量）
  @State private currentDate: Date = new Date()
  // 当前选中的日期（响应式状态变量）
  @State private selectedDate: Date = new Date()
  // 星期显示文本
  private weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六']

  build() {
    Column() {
      // 渲染日历头部
      this.CalendarHeaderBuilder()

      // 日历内容绿色区域
      Column() {
        // 渲染星期标题行
        this.WeekDaysBuilder()

        // 渲染日期选择行
        Row() {
          ForEach(this.getDatesForWeek(), (date: number) => {
            Column() {
              Stack() {
                // 选中日期高亮背景
                if (date === this.selectedDate.getDate()) {
                  Circle()
                    .width(40)
                    .height(40)
                    .fill('#ffffffff')
                }
                // 日期文本
                Text(`${date < 10 ? '0' : ''}${date}`)
                  .fontSize(18)
                  .fontColor(date === this.selectedDate.getDate() ? '#00C853' : '#FFFFFF')
              }
            }
            .width('14.28%')
            .height(50)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              const newDate = new Date(this.selectedDate);
              newDate.setDate(date);
              this.selectedDate = newDate;
              this.filterSamplesBySelectedDate(); // 点击后立即筛选
              this.loadSamplesFromServer();
            })

          })
        }
        .width('100%')
        .padding({ bottom: 16 })
      }
      .width('100%')
      .backgroundColor('#00C853')

      // 数据卡片区域（占满中间部分）
      Column() {
        if (this.filteredSamples.length == 0) {
          Text('~ 暂无相关数据 ~')
            .fontSize(16)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Center)
            .padding({ top: 50 });
        } else {
          this.renderSampleCards();
        }
      }
      .width('100%')
      // .padding({ top: 16, bottom: 6 })
      .layoutWeight(1)// 占据剩余空间
      .margin({ left: 5, right: 5 })
      .justifyContent(FlexAlign.Start)     // 关键：让卡片内容靠上排列
      .backgroundColor('#F5F5F5')        // 可选背景色
      // 【关键】新增留样按钮固定在底部
      Column() {
        Button('新增留样')
          .width('100%')
          .height(50)
          .fontSize(18)
          .fontColor('#ffffffff')
          .backgroundColor('#00C853')
          .onClick(() => {
            router.push({
              url: 'pages/remain_day_new',
              params: {
                date: this.formatDate(this.selectedDate),
                token: this.receivedToken,
                relTenantIds: this.tenantId
              },
            })
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16 }) // 可选：添加内边距
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 日期列表制作
  private getDatesForWeek(): number[] {
    // 计算当月第一天
    const firstDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), 1)
    // 计算当月最后一天
    const lastDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 0)

    // 获取当前选中日期的星期几（0-6，0表示星期日）
    const currentDayOfWeek = this.selectedDate.getDay()

    // 计算当前选中日期所在周的第一天（星期日）
    const startDate = new Date(this.selectedDate)
    startDate.setDate(this.selectedDate.getDate() - currentDayOfWeek)

    // 生成当前周的日期数组
    const dates: number[] = []
    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate)
      currentDate.setDate(startDate.getDate() + i)
      dates.push(currentDate.getDate())
    }
    return dates;
  }
  private changeWeek(increment: number) {
    const newDate = new Date(this.selectedDate);
    newDate.setDate(this.selectedDate.getDate() + increment * 7);

    this.currentDate = new Date(newDate);
    this.selectedDate = newDate;

    // 切换周后重新加载数据
    void this.loadSamplesFromServer().then(()=>{
      this.filterSamplesBySelectedDate();
    });
  }
  @Builder
  private CalendarHeaderBuilder() {
    Row() {
      // 显示当前年月
      Text(`${this.currentDate.getFullYear()}年${this.currentDate.getMonth() + 1}月`)
        .fontSize(24)
        .fontWeight(FontWeight.Medium)
        .fontColor('#ffffffff')
      Blank()
      // 周切换按钮
      Row() {
        Text('<') // 上一周按钮
          .fontSize(24)
          .fontColor('#ffffffff')
          .margin({ right: 20 })
          .onClick(() => this.changeWeek(-1))
        Text('>') // 下一周按钮
          .fontSize(24)
          .fontColor('#ffffffff')
          .onClick(() => this.changeWeek(1))
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor('#00C853')
  }
  @Builder
  private WeekDaysBuilder() {
    Row() {
      // 渲染星期文本（一至日）
      ForEach(this.weekDays, (day: string) => {
        Text(day)
          .fontSize(15)
          .width('14.28%') // 平均分配宽度（100%/7）
          .textAlign(TextAlign.Center)
          .fontColor('#ffffffff')
      })
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }

  // 接收id和token
  async onPageShow() {
    const params = router.getParams() as RouterParams;

    if (params?.formData) {
      const exists = this.samples.some(s => s.id === params.formData?.id);
      if (!exists) {
        this.samples.push(params.formData);
      }
    }

    // const cachedData = await AppStorage.get('newSampleData') as SampleFormData;
    // if (cachedData) {
    //   try {
    //     const formDataJsonString = JSON.stringify(cachedData);
    //     const formData:SampleFormData = JSON.parse(formDataJsonString);
    //     const exists = this.samples.some(s => s.id === formData.id);
    //     if (!exists) {
    //       this.samples.push(formData);
    //     }
    //   }catch (error) {
    //     console.error('解析缓存数据失败:', error);
    //   }
    // }
    //
    // 接收 token 和租户 ID
    if (params?.token) {
      this.receivedToken = params.token;
      AppStorage.set('token', params.token); // 同步保存到 AppStorage
    } else {
      this.receivedToken = AppStorage.get('token') ?? ''; // 从本地恢复 token
    }

    if (params?.relTenantIds !== undefined) {
      this.tenantId = params.relTenantIds;
      AppStorage.set('tenantId', params.relTenantIds); // 同步保存 tenantId
    } else {
      this.tenantId = AppStorage.get('tenantId') ?? 0; // 从本地恢复 tenantId
    }
    // 可选：根据当前选中日期加载数据
    // await this.loadSamplesFromServer(this.formatDate(this.selectedDate));
    await this.loadSamplesFromServer();
    this.filterSamplesBySelectedDate();

  }

  // 筛选
  private formatDate(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  }
  private filterSamplesBySelectedDate() {
    const selectedDateString = this.formatDate(this.selectedDate);
    this.filteredSamples = this.samples.filter(sample =>
    sample.reservedSampleDate && sample.reservedSampleDate.startsWith(selectedDateString)
    );
  }

  // 制作卡片
  @Builder
  renderSampleCards() {
    Scroll() {
      Column() {
        ForEach(this.filteredSamples, (sample: SampleFormData) => {
          this.renderSampleCard(sample);
        }, (item: SampleFormData) => item.id || Math.random().toString())
      }
      .width('100%')
      .height('100%')
    }
    .zIndex(0)
    .scrollBarWidth(0) // 隐藏滚动条
    .edgeEffect(EdgeEffect.Spring) // 添加下拉回弹效果
    .height('100%');
  }
  @Builder
  renderSampCard() {
    if (this.samples.length > 0) {
      this.renderSampleCard(this.samples[0]);
    }
  }
  @Builder
  renderSampleCard(sample: SampleFormData) {
    Stack() {
      Column({ space: 10 }) {
        // 菜品名称
        Text(`${sample.reservedSampleDate} ${sample.mealCategory_dictText} `)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
          .width('100%')
        // 制单日期
        Text(`制单日期: ${sample.createTime || '无'}`)
          .fontSize(16)
          .fontColor('#666')
          .margin({ left: 16 })
          .width('100%');

        // 提交人
        Text(`销毁人员: ${sample.destroyPerson || '无'}`)
          .fontSize(16)
          .fontColor('#666')
          .margin({ left: 16 })
          .width('100%');

        // 销毁日期
        Text(`销毁日期: ${sample.destroyTime || '无'}`)
          .fontSize(16)
          .fontColor('#666')
          .margin({ left: 16 })
          .width('100%');

        Row({ space: 10 }) {
          Button('重新编辑')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/remain_day_new',
                params: {
                  formData: {
                    id: sample.id,
                    unitName: sample.unitName,
                    reservedSampleDate: sample.reservedSampleDate,
                    createTime: sample.createTime,
                    sampleType: sample.sampleType,
                    sampleType_dictText: sample.sampleType_dictText,
                    mealType: sample.mealType,
                    mealCategory_dictText: sample.mealCategory_dictText,
                    cabinetTemperature: sample.cabinetTemperature,
                    dishName: sample.dishName,
                    putWeight: sample.putWeight,
                    destroyPerson: sample.destroyPerson,
                    destroyTime: sample.destroyTime,
                    sampleImages: sample.sampleImages,
                    fridgeImages: sample.fridgeImages,
                    remark: sample.remark
                  },
                  token: this.receivedToken,
                  relTenantIds: this.tenantId
                }

              });
              console.log( 'AaAAaAAAAAAAAAAAAAAAAAAA',JSON.stringify(sample))

            })
            .margin({left:'35%'})
            .backgroundColor(Color.White)
            .fontColor('#00C853')
            .border({ color: '#00C853', width: 2 })
            .width('30%')

          Button('删除单据')
            .onClick(() => {
              AlertDialog.show({
                title: '确认删除',
                message: '确定要删除这条留样记录吗？',
                confirm: {
                  value: '确定',
                  action: () => this.deleteSample(sample.id ?? '')
                },
                cancel:()=> {
                }
              });

            })
            .backgroundColor(Color.White)
            .fontColor('#00C853')
            .border({ color: '#00C853', width: 2 })
            .margin({ left: 10})
            .width('30%')
        }
        .justifyContent(FlexAlign.SpaceEvenly)
      }
      .width('95%')
      .padding(16)
      .backgroundColor('#fff')
      .borderRadius(8)
      .border({ color: '#00C853', width: 2 })
      .margin({ top: 10, left: 10, right: 10 })
      .shadow({ color: '#888', radius: 6, offsetX: 4, offsetY: 4 }) //  添加偏移量增强阴影立体感
    }
  }

  // 查询接口
  private async loadSamplesFromServer() {
    try {
      const httpRequest = http.createHttp();

      console.info('Request Headers:', {
        'X-Access-Token': this.receivedToken,
        'Tenant-Id': this.tenantId
      });
      console.info('Token value:', this.receivedToken);
      console.info('TenantId value:', this.tenantId);

      const response = await httpRequest.request(
        `https://api.suoeryun.com/ifood/jeecg-school/school/xxReservedSample/list`, // 示例接口地址
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'X-Access-Token': this.receivedToken,
            'Tenant-Id': this.tenantId.toString()
          }
        }
      );
      if (response.responseCode === 200) {
        const jsonData = JSON.parse(response.result as string) as ApiResponse;
        if (jsonData.code === 200 && jsonData.result) {
          // this.samples = jsonData.result || [];
          this.samples = [...(jsonData.result.records || []), ...this.samples.filter(s => !s.isRemote)];
          this.samples.forEach(sample => sample.isRemote = true); // 标记远程数据

          if (this.samples.length > 0) {
            console.log('this.samples[0].id:', this.samples[0].id)
          } else {
            console.log('this.samples is empty');
          }
        } else {
          console.error('获取数据失败:', jsonData.message);
        }
      } else {
        console.error('HTTP 请求失败:', response.responseCode);
      }
    } catch (error) {
      console.error('请求异常:', error);
    }
  }
  // 删除
  private async deleteSample(id: string) {
    if (!id) {
      console.warn('无效的留样ID');
      return;
    }

    try {
      const httpRequest = http.createHttp();
      const url = `https://api.suoeryun.com/ifood/jeecg-school/school/xxReservedSample/delete?id=${encodeURIComponent(id)}`;

      const response = await httpRequest.request(url, {
        method: http.RequestMethod.DELETE,
        header: {
          'Content-Type': 'application/json',
          'X-Access-Token': this.receivedToken,
          'Tenant-Id': this.tenantId.toString()
        },
        connectTimeout: 60000,
        readTimeout: 60000
      }
      );

      if (response.responseCode === 200) {
        const result = JSON.parse(response.result as string) as ApiResponse;
        if (result.code === 200) {
          prompt.showToast({ message: '删除成功' });
          // 从本地状态中移除该记录
          this.samples = this.samples.filter(s => s.id !== id);
          this.filterSamplesBySelectedDate(); // 更新视图
        } else {
          console.error('删除失败:', result.message);
          prompt.showToast({ message: '删除失败: ' + result.message });
        }
      } else {
        console.error('HTTP 请求失败:', response.responseCode);
        prompt.showToast({ message: '网络请求失败' });
      }
    } catch (error) {
      console.error('删除异常:', error);
      prompt.showToast({ message: '删除时发生错误' });
    }
  }

}