import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import preferences from '@ohos.data.preferences';


// 在文件顶部添加全局接口定义
interface GlobalThis extends Object {
  authToken: string;
  tenantId: string;
}

// 类型断言语法确保类型正确
declare let globalThis: GlobalThis;


type StringToNumberMap = Record<string, number>;

interface ErrorResponse {
  code: number;
  message: string;
  timestamp?: number;
}

interface UserInfo {
  demandUnit: string;
  cabinetTemperature: string;
  dishName: string;
  putWeight: string;
  destroyPerson: string;
  remark: string;
  demandUnitName: string;
  reservedSampleDate: string;
  sampleType: string;
  mealCategory: string;
  destroyTime: string;
}

interface SubmitResult {
  demandUnit: string;
  cabinetTemperature: number;
  dishName: string;
  putWeight: number;
  destroyPerson: string;
  remark: string;
  demandUnitName: string;
  reservedSampleDate: string;
  sampleType: number;
  mealCategory: number;
  destroyTime: string;
}
interface LoginResult {
  token: string;
  relTenantIds:number;
  //tenantId?: string; // 可选字段
  //tenantList: string; // 根据实际需求定义
 UserInfo: UserInfo;     // 根据实际需求定义
}

interface LoginResponse {
  success: boolean;
  message: string;
  code: number;
  result: LoginResult;

}


interface SubmitResponse {
  code: number;
  message: string;
  result: SubmitResult;
}

interface UnitMapping {
  name: string;
  id: string;
}

// 拆分 padding 和 margin 成独立接口
interface Padding {
  left: number;
  right: number;
}
@Entry
@Component
struct xinjian {
  @State cabinetTemperature: string = '';
  @State dishName: string = '';
  @State putWeight: string = '';
  @State destroyPerson: string = '';
  @State remark: string = '';
  @State userUsername: string = '15502933673';
  @State userPassword: string = '123456';

  @State demandUnitName: string = '提交单位 *';
  @State reservedSampleDate: string = '留样时间 *';
  @State sampleType: string = '留样类型 *';
  @State mealCategory: string = '餐别 *';
  @State destroyTime: string = '销毁时间 *';
@State TenantIds: number = 0;
  @State isLoading: boolean = false;

  private sampleTypeMap: StringToNumberMap = {
    '教师餐': 1,
    '学生餐': 2
  };

  private mealCategoryMap: StringToNumberMap = {
    '早餐': 1,
    '午餐': 2,
    '晚餐': 3,
    '早点': 4,
    '午点': 5,
    '晚点': 6,
    '其他': 7,
    '营养改善计划': 8
  };

  @State unitMappings: UnitMapping[] = [
    { name: '实训第二学校餐厅', id: '1651892693627330562' },
    { name: '浐灞一小餐厅', id: '1651892693627330561' },
    { name: '其他', id: '1003' }
  ];
  private async login() {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-system/sys/login',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({
            username: this.userUsername,
            password: this.userPassword
          })
        }
      );

      if (response.responseCode === 200) {
        const responseText = response.result?.toString() || '{}';
        console.info('原始响应字符串:', responseText);
        const result = JSON.parse(responseText) as LoginResponse;
        console.info('解析后的登录结果:', result);

        // 设置全局 token 和 tenantId
        globalThis.authToken = result.result.token;
        //globalThis.tenantId = result.result.UserInfo.relTenantIds??0; // 如果 tenantId 不存在则设为空字符串
      this.TenantIds= result.result.relTenantIds;
        console.log('',this.TenantIds);
        promptAction.showToast({ message: '登录成功' });

        // 可选：跳转到提交页或其他页面
      } else {
        promptAction.showToast({ message: '登录失败，请检查账号密码' });
      }
    } catch (error) {
      console.error('登录出错:', error);
      promptAction.showToast({ message: '登录请求失败' });
    }
  }



  private async submitData() {
    console.info('authToken:', globalThis.authToken); // 添加在此处
    console.info('tenantId:', globalThis.tenantId);
    if (!this.isFormValid()) {
      promptAction.showToast({ message: '请填写所有必填项（标记*的字段）' });
      return;
    }

    const numericSampleType = this.sampleTypeMap[this.sampleType];
    const numericMealCategory = this.mealCategoryMap[this.mealCategory];

    if (typeof numericSampleType === 'undefined' || typeof numericMealCategory === 'undefined') {
      promptAction.showToast({ message: '请选择有效的餐别和留样类型' });
      return;
    }

    const unitMapping = this.unitMappings.find(unit => unit.name === this.demandUnitName);
    if (!unitMapping) {
      promptAction.showToast({ message: '无效的提交单位' });
      return;
    }

    this.isLoading = true;

    try {
      let httpRequest = http.createHttp();
      let response = await httpRequest.request(
        "https://api.suoeryun.com/ifood/jeecg-school/school/xxReservedSample/add",
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'X-Access-Token': globalThis.authToken,
            'Tenant-Id': "10021011"
          },
          extraData: JSON.stringify({
            cabinetTemperature: Number(this.cabinetTemperature),
            dishName: this.dishName,
            putWeight: Number(this.putWeight),
            destroyPerson: this.destroyPerson,
            remark: this.remark,
            demandUnit: unitMapping.id,
            reservedSampleDate: this.reservedSampleDate + ' 00:00:00',
            sampleType: numericSampleType,
            mealCategory: numericMealCategory,
            destroyTime: this.destroyTime + ' 00:00:00'
          })
        }
      );

      if (response.responseCode === 200) {
        const responseText = response.result?.toString() || '{}';
        const result = JSON.parse(responseText) as SubmitResponse;
        promptAction.showToast({ message: `提交成功，记录ID：${result.result.demandUnit}` });

      } else {
        const errorText = response.result?.toString() || '{}';
        try {
          const errorData = JSON.parse(errorText) as ErrorResponse;
          promptAction.showToast({ message: errorData.message || '未知错误' });
        } catch (e) {
          promptAction.showToast({ message: '无法解析错误信息' });
        }
      }
    } catch (error) {
      console.error('网络请求错误:', error);
      promptAction.showToast({ message: '请检查网络连接' });
    } finally {
      this.isLoading = false;
    }
  }

  private resetForm() {
    this.cabinetTemperature = '';
    this.dishName = '';
    this.putWeight = '';
    this.destroyPerson = '';
    this.remark = '';
    this.demandUnitName = '提交单位 *';
    this.reservedSampleDate = '留样时间 *';
    this.sampleType = '留样类型 *';
    this.mealCategory = '餐别 *';
    this.destroyTime = '销毁时间 *';
  }

  private isFormValid(): boolean {
    return this.demandUnitName !== '提交单位 *' &&
      this.reservedSampleDate !== '留样时间 *' &&
      this.sampleType !== '留样类型 *' &&
      this.mealCategory !== '餐别 *' &&
      this.destroyTime !== '销毁时间 *' &&
      !!this.cabinetTemperature.trim() &&
      !!this.putWeight.trim() &&
      typeof this.sampleTypeMap[this.sampleType] === 'number' &&
      typeof this.mealCategoryMap[this.mealCategory] === 'number'
  }

  build() {
    Column({space:10}) {
      Column() {
        Text('上传每日留样')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)

      Text('样本重量≥125克，留样时间≥48小时')
        .fontColor(Color.Orange)
        .margin({ top: 12, bottom: 12 })
      // 定义通用样式函数


      ExpandableSelector({
        options: ['实训第二学校餐厅', '浐灞一小餐厅', '其他'],
        defaultValue: '提交单位 *',
        selectedValue: $demandUnitName
      })
        .width('100%')
      ExpandableSelector({
        mode: 'time',
        defaultValue: '留样时间 *',
        selectedValue: $reservedSampleDate
      })
        .width('100%')

      ExpandableSelector({
        options: ['教师餐', '学生餐'],
        defaultValue: '留样类型 *',
        selectedValue: $sampleType
      })
        .width('100%')

      ExpandableSelector({
        options: ['早餐', '午餐', '晚餐', '早点', '午点', '晚点', '其他', '营养改善计划'],
        defaultValue: '餐别 *',
        selectedValue: $mealCategory
      })
        .width('100%')

      ExpandableSelector({
        mode: 'time',
        defaultValue: '销毁时间 *',
        selectedValue: $destroyTime
      })
        .width('100%')

      TextInput({ text: this.cabinetTemperature, placeholder: '留样柜温度 *' })
        .onChange((value: string) => this.cabinetTemperature = value)

      TextInput({ text: this.dishName, placeholder: '菜品名称' })
        .onChange((value: string) => this.dishName = value)

      TextInput({ text: this.putWeight, placeholder: '留样重量 *' })
        .onChange((value: string) => this.putWeight = value)

      TextInput({ text: this.destroyPerson, placeholder: '销毁人员' })
        .onChange((value: string) => this.destroyPerson = value)

      TextInput({ text: this.remark, placeholder: '备注' })
        .onChange((value: string) => this.remark = value)
      Button('调试登录')
        .onClick(() => this.login())
        .backgroundColor('#18b76b')
        .fontColor('#FFFFFF')
        .margin({ top: 20 })
      Button(this.isLoading ? '提交中...' : '提交')
        .onClick(() => this.login())
        .onClick(() => this.submitData())
        .backgroundColor(this.isFormValid() ? '#18b76b' : '#CCCCCC')
    }
    .width('100%')
    .backgroundColor('#F5F5F5')
    .margin({left:0,right:0})
  }
}
@Component
struct ExpandableSelector {
  @Prop options: string[]
  @Prop defaultValue: string
  @Prop mode: string = 'default'
  @Link selectedValue: string
  @State isExpanded: boolean = false
  @State tempDate: Date = new Date()

  build() {
    Column() {
      Row() {
        Text(this.selectedValue)
        Text('▼')
          .rotate({ angle: this.isExpanded ? 180 : 0 })
      }
      .onClick(() => this.isExpanded = !this.isExpanded)

      if (this.isExpanded) {
        Column() {
          if (this.mode === 'time') {
            DatePicker({
              start: new Date('2000-1-1'),
              end: new Date('2050-1-1'),
              selected: this.tempDate,
            })
              .onChange((value) => {
                const date = new Date(
                  value.year ?? this.tempDate.getFullYear(),
                  value.month ?? this.tempDate.getMonth(),
                  value.day ?? this.tempDate.getDate()
                )
                this.selectedValue =
                  `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate()
                    .toString()
                    .padStart(2, '0')}`

              })
          } else {
            ForEach(this.options, (item: string) => {
              Text(item)
                .onClick(() => {
                  this.selectedValue = item
                  this.isExpanded = false
                })
            })
          }
        }
      }
    }
  }
}