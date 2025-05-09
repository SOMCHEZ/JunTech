import router from '@ohos.router';
import filePicker from '@ohos.file.picker';

interface RouteParams {//接口传递参数定义
  token?: string;
  relTenantIds?: number;
}

interface SelectOption {
  value: string;
  label: string;
}

// 可以尝试引入官方定义，如果没有则手动定义
interface DatePickerResult {
  year: number;
  month?: number; // 可选属性
  day?: number;   // 可选属性
}


@Entry
@Component
struct AddStaff {
  @State private selectedUnitIndex: number = 0; // 默认选中第一个单位
  @State private name: string = '';
  @State private jobPosition: string = '';
  @State private phone: string = '';
  @State private status: string = '在职';
  @State private issueDate: string = '';
  @State private expiryDate: string = '';


  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上

  onPageShow() {//这是一个接收传递参数的方法
    // 使用接口类型断言
    const params = router.getParams() as RouteParams;
    console.log('houchuadd', params?.token);// 打印接收到的参数
    console.log('houchuadd', params?.relTenantIds);//  打印接收到的参数

    // 安全取值
    if (params?.token) {
      this.receivedToken = params.token;
    }

    if (params?.relTenantIds) {
      this.tenantId = params.relTenantIds;
    }
  }

  private units: Array<SelectOption> = [
    { value: '实训第二学校餐厅', label: '实训第二学校餐厅' },
    { value: '其他单位', label: '其他单位' }
  ];
  private statuses: Array<SelectOption> = [
    { value: '在职', label: '在职' },
    { value: '离职', label: '离职' }
  ];
  build() {
    Column({ space: 0 }) {
      // 所属单位
      Row({ space: 10 }) {
        Text("所属单位 *")
          .fontSize(16)
          .width('30%')
        Select(this.units)
          .selected(this.selectedUnitIndex)
          .onSelect((index: number) => {
            this.selectedUnitIndex = index;
          })
          .width('70%')
          .height(50)
          .padding({ left: 10 })
      }
      .margin({ bottom: 10 })

      // 人员姓名
      Row({ space: 10 }) {
        Text("人员姓名 *")
          .fontSize(16)
          .width('30%')
        TextInput({ placeholder: '请输入人员姓名' })
          .onChange((value: string) => {
            this.name = value
          })
          .width('70%')
          .height(50)
          .padding({ left: 10 })
      }
      .margin({ bottom: 10 })

      // 人员岗位
      Row({ space: 10 }) {
        Text("人员岗位 *")
          .fontSize(16)
          .width('30%')
        TextInput({ placeholder: '请输入人员岗位' })
          .onChange((value: string) => {
            this.jobPosition = value
          })
          .width('70%')
          .height(50)
          .padding({ left: 10 })
      }
      .margin({ bottom: 10 })

      // 联系电话
      Row({ space: 10 }) {
        Text("联系电话 *")
          .fontSize(16)
          .width('30%')
        TextInput({ placeholder: '请输入员联系电话' })
          .onChange((value: string) => {
            this.phone = value
          })
          .width('70%')
          .height(50)
          .padding({ left: 10 })
      }
      .margin({ bottom: 10 })

      // 人员状态
      Row({ space: 10 }) {
        Text("人员状态 *")
          .fontSize(16)
          .width('30%')
        Select(this.statuses)
          .selected(this.statuses.findIndex(item => item.value === this.status))
          .onSelect((index: number) => {
            this.status = this.statuses[index].value;
          })
          .width('70%')
          .height(50)
          .padding({ left: 10 })
      }
      .margin({ bottom: 10 })

      // 发证日期
      Row({ space: 10 }) {
        Text("发证日期 *")
          .fontSize(16)
          .width('30%')
        DatePicker({
          start: new Date('1970-1-1'),
          end: new Date('2100-1-1'),
          selected: this.expiryDate ? new Date(this.expiryDate) : new Date()
        })
          .onChange((value: DatePickerResult) => {
            const year = value.year;
            const month = (value.month !== undefined ? value.month : 1).toString().padStart(2, '0');
            const day = (value.day !== undefined ? value.day : 1).toString().padStart(2, '0');
            this.expiryDate = `${year}-${month}-${day}`;
          })
          .width('70%')
          .height(50)
          .borderWidth(1)
          .borderColor('#ccc')
          .padding({ left: 10 })
          .borderRadius(10)
      }
      .margin({ bottom: 10 })

      // 到期日期
      Row({ space: 10 }) {
        Text("到期日期 *")
          .fontSize(16)
          .width('30%')
        DatePicker({
          start: new Date('1970-1-1'),
          end: new Date('2100-1-1'),
          selected: new Date(this.expiryDate || new Date())
        })
          .onChange((value: DatePickerResult) => {
            const month = (value.month ?? 1).toString().padStart(2, '0');
            const day = (value.day ?? 1).toString().padStart(2, '0');
            this.expiryDate = `${value.year}-${month}-${day}`;
          })
          .width('70%')
          .height(50)
          .borderWidth(1)
          .borderColor('#ccc')
          .borderRadius(10)
          .padding({ left: 10 })
          .borderRadius(10)
      }
      .margin({ bottom: 10 })

      // 健康证照片
      Row({ space: 10 }) {
        Text("健康证照片")
          .fontSize(16)
          .width('30%')
        Button("选择健康证照片")
          .width('70%')
          .height(50)
      }
      .margin({ bottom: 10 })

      // 人脸照片
      Row({ space: 10 }) {
        Text("人脸照片")
          .fontSize(16)
          .width('30%')
        Button("选择人脸照片")
          .width('70%')
          .height(50)
      }
      .margin({ bottom: 10 })

      // 提交按钮
      Button({type:ButtonType.Normal}){
        Text("提交")
          .fontColor(Color.White)
          .fontSize(20)
      }
      .width('90%')
      .height(50)
      .backgroundColor('#4CAF50')
      .borderRadius(10)
      .onClick(() => {
        router.pushUrl({
          url: 'pages/kitchenStaff' })
      })
      .margin({ top: 100 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .padding({ top: 20, left: 10, right: 10 })
  }
}
