import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import filePicker from '@ohos.file.picker';

interface RouteParams {//接口传递参数定义
  token?: string;
  relTenantIds?: number;
}

interface SelectOption {
  value: string;
  label: string;
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
      Row({ space: 10}) {
        Text("所属单位 *")
          .fontSize(16)
          .width('30%')
        Select(this.units)
          .selected(this.selectedUnitIndex)
          .onSelect((index: number) => {
            this.selectedUnitIndex = index;
          })
          .backgroundColor(Color.White)
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
          .backgroundColor(Color.White)
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
          .backgroundColor(Color.White)
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
          .backgroundColor(Color.White)
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
          .backgroundColor(Color.White)
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
        Text(this.issueDate)
        Button(){
          if (this.issueDate == ""){
            Text("请选择")
          }
        }
          .onClick(() => {
            this.showIssueDateDialog()
          })
        .margin({left:175})
        .backgroundColor(Color.White)
      }
      .width("100%")
      .margin({left:0, top: 20, bottom: 20 })


      // 到期日期
      Row({ space: 10 }) {
        Text("到期日期 *")
          .fontSize(16)
          .width('30%')
        Text(this.expiryDate)
        Button(){
          if (this.expiryDate == ""){
            Text("请选择")
          }
        }
        .onClick(() => {
          this.showExpireDateDialog()
        })
        .margin({left:175})
        .backgroundColor(Color.White)
      }
      .width("100%")
      .margin({left:0, top: 20, bottom: 20 })


      // 健康证照片
      Row({ space: 10 }) {
        Text('健康证照片')
          .fontSize(16)
          .width('40%')
        Button({type:ButtonType.Normal})
          .margin({left: 125})
          .backgroundColor(Color.White)
          .backgroundImage($r("app.media.evidence_add"))
          .backgroundImageSize(1)
          .width(50)
          .height(50)
      }
      .margin({top: 10, bottom: 10})
      .height(50)
      .width('100%')
      // 人脸照片
      Row({ space: 10 }) {
        Text("人脸照片")
          .fontSize(16)
          .width('40%')
        Button({type:ButtonType.Normal})
          .margin({left: 125})
          .backgroundColor(Color.White)
          .backgroundImage($r("app.media.evidence_add"))
          .backgroundImageSize(1)
          .width(50)
          .height(50)
      }
      .margin({top:10, bottom: 10 })
      .width('100%')
      // 提交按钮
      Button({type:ButtonType.Normal}){
        Text("提交")
          .fontColor(Color.White)
          .fontSize(18)
      }
      .width('90%')
      .height(40)
      .backgroundColor('#4CAF50')
      .borderRadius(10)
      .onClick(() => {
        router.pushUrl({
          url: 'pages/kitchenStaff' })
      })
      .margin({top:120})
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .padding({ top: 0, left: 10, right: 10 })
  }

  private showIssueDateDialog() {
    let dialog: DatePickerDialogOptions = {
      selected: new Date(), // 默认当前日期
      lunar: false,         // 不需要农历
      onAccept: (value: DatePickerResult) => { // 使用系统内置类型
        if (value.year && value.month && value.day) {
          this.issueDate = `${value.year}-${value.month+1}-${value.day}`;
        }
      }
    };
    DatePickerDialog.show(dialog);
  }

  private showExpireDateDialog() {
    let dialog: DatePickerDialogOptions = {
      selected: new Date(), // 默认当前日期
      lunar: false,         // 不需要农历
      onAccept: (value: DatePickerResult) => { // 使用系统内置类型
        if (value.year && value.month && value.day) {
          this.expiryDate = `${value.year}-${value.month+1}-${value.day}`;
        }
      }
    };
    DatePickerDialog.show(dialog);
  }
}
