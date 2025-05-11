import prompt from '@ohos.prompt';
import router from '@ohos.router';
import { Router } from '@kit.ArkUI';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import fs from '@ohos.file.fs';
import {BusinessError} from '@ohos.base';
import picker from '@ohos.file.picker';
import common from '@ohos.app.ability.common';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { JSON } from '@kit.ArkTS';


interface GeneratedObjectLiteralInterface_1 {
  date: string;
  recipeName: string;
  mealType: string;
  diningType: string;
  place: string;
  photoUri: string;
  from?: string;
}
const photoSelectOptions=new photoAccessHelper.PhotoSelectOptions();

@Entry
@Component
struct food_day_new {
  private selectDate: Date = new Date()
  @State date:string ='选择日期'
  @State selectedDate: string = '请选择筛选日期';
  @State recipeName: string = '请输入食谱名称';
  @State mealType: string = '';
  @State diningType: string = '';
  @State photoUri: string = '';
  @State message: string = ''
  private time =[]
  private photoCount: number = 0
  private unitOptions = [
    '早餐', '午餐', '晚餐','早点','午点','晚点','其他','营养改善计划'
  ]
  private classify=['不区分', '教师餐', '学生餐']
  private place=['实训第二学校餐厅']
  private photoPicker = new picker.PhotoViewPicker();
  @State placeValue: string = '实训第二学校餐厅';
  @State formDataList: GeneratedObjectLiteralInterface_1[] = [];
  @State editIndex: number = -1;

  aboutToAppear() {
    let params = router.getParams() as GeneratedObjectLiteralInterface_1;
    if (params && typeof params === 'object') {
      if (params.date) {
        this.selectedDate = params.date;
      }
      if (params.recipeName) {
        this.recipeName = params.recipeName;
      }
      if (params.mealType) {
        this.mealType = params.mealType;
      }
      if (params.diningType) {
        this.diningType = params.diningType;
      }
      if (params.place) {
        this.placeValue = params.place;
      }
      if (params.photoUri) {
        this.photoUri = params.photoUri;
      }
    }
  }

  build() {
    Column() {
      // 表单容器
      Text("新建食谱")
        .fontSize(16)
        .margin({ bottom: 5 })
      Column() {
        Column() {
          // 食谱日期
          Row({ space: 10 }) {
            Text('食谱日期 *')
              .fontSize(16)
              .width('30%')
            Text(this.selectedDate)
              .width('60%')
              .height(40)
              .textAlign(TextAlign.Center)
              .borderRadius(4)
              .borderWidth(1)
              .borderColor('#CCCCCC')
              .onClick(() => {
                this.showDateDialog()
              })
              .width('70%')
            FormItem('食谱日期', true)

          }
          .margin({top: 5, bottom: 5 })
          // 食谱名称
          Row({ space: 10 }) {
            Text('食谱名称 *')
              .fontSize(16)
              .width('30%')
            TextInput({placeholder: this.recipeName })
              .width('60%')
              .height(40)
              .textAlign(TextAlign.Start)
              .borderRadius(4)
              .borderWidth(1)
              .borderColor('#CCCCCC')
              .onChange(value => this.recipeName = value)
              .width('70%')
            FormItem('食谱名称', true)
          }
          .margin({top: 5, bottom: 5 })
          // 餐别
          Row({ space: 10 }) {
            Text('餐 别 *')
              .fontSize(16)
              .width('30%')
            Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
              .selected(this.unitOptions.indexOf(this.mealType) >= 0 ? this.unitOptions.indexOf(this.mealType) : 0)
              .value(this.mealType || '请选择餐别')
              .onSelect((index: number) => {
                this.mealType = this.unitOptions[index]
              })
              .width('70%')
            FormItem('餐别', true)
          }
          .margin({top: 5, bottom: 5 })
          // 用餐类型
          Row({ space: 10 }) {
            Text('用餐类型 *')
              .fontSize(16)
              .width('30%')
            Select(this.classify.map<SelectOption>((item: string) => ({ value: item })))
              .selected(this.classify.indexOf(this.diningType) >= 0 ? this.classify.indexOf(this.diningType) : 0)
              .value(this.diningType || '请选择用餐类型')
              .onSelect((index: number) => {
                this.diningType = this.classify[index]
              })
              .width('70%')
            FormItem('用餐类型', true)
          }
          .margin({top: 5, bottom: 5 })
          // 提交单位
          Row({ space: 10 }) {
            Text('提交单位 *')
              .fontSize(16)
              .width('30%')
            Select(this.place.map<SelectOption>((item: string) => ({ value: item })))
              .selected(this.place.indexOf(this.placeValue) >= 0 ? this.place.indexOf(this.placeValue) : 0)
              .value(this.placeValue)
              .onSelect((index: number) => {
                this.placeValue = this.place[index]
              })
              .width('70%')
            FormItem('提交单位',true)
          }
          .margin({top: 5, bottom: 5 })

          Row({ space: 10 }) {
            Text('上传食谱照片 *')
              .fontSize(16)
              .width('40%')
              .margin({right:110})
            Text(`${this.photoCount}/20`)
              .width('60%')
              .height(40)
          }
          .margin({top: 5, bottom: 5 })

          // 上传图片按钮
          Image($r('app.media.evidence_add'))
            .width(100)
            .height(100)
            .margin({ right: 222 })
            .onClick(() => {
              this.openGallery();
            })
        }
        .layoutWeight(1)
        // 保存按钮
        Button('保存')
          .type(ButtonType.Capsule)
          .width('90%')
          .margin(20)
          .onClick(() => {
            this.submitForm();
          })
      }
      .width('100%')
    }
    .padding(20)
    .width('100%')
  }
  // 媒体权限申请
  private requestMediaPermission() {
    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(context, ["ohos.permission.READ_MEDIA"], (error, result) => {
      if (result) {
        console.log("result: " + JSON.stringify(result));
      } else {
        console.log("error: " + JSON.stringify(error));
      }
    });
  }
  // 日期选择对话框
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
  // 图片选择
  private openGallery() {
    const photoViewPicker =new photoAccessHelper.PhotoViewPicker();
    photoViewPicker.select()
      .then((photoSelectResult)=>{
        AlertDialog.show({message:JSON.stringify(photoSelectResult,null,2)})
      })
  }

  // 表单提交逻辑
  private submitForm() {
    if (!this.selectedDate
    // ||
    // !this.recipeName ||
    // !this.mealType ||
    // !this.diningType||
    // !this.placeValue
    ) {
      prompt.showToast({
        message: '请填写所有必填项',
        duration: 2000
      });
      return;
    }

    prompt.showToast({
      message: '保存成功',
      duration: 2000
    });
    let formData: GeneratedObjectLiteralInterface_1 = {
      date: this.selectedDate,
      recipeName: this.recipeName,
      mealType: this.mealType,
      diningType: this.diningType,
      place: this.placeValue,
      photoUri: this.photoUri,
      from: 'food_day_new'
    };
    if (this.editIndex >= 0) {
      this.formDataList[this.editIndex] = formData;
    } else {
      this.formDataList.push(formData);
    }
    router.replaceUrl({
      url: 'pages/food_day',
      params: {
        formDataList: this.formDataList,
        from: 'food_day_new'
      }
    });
  }

}

// 用于存储和初始化全局context
export class GlobalContext {
  private static context: common.UIAbilityContext;

  public static initContext(context: common.UIAbilityContext): void {
    GlobalContext.context = context;
  }

  public static getContext(): common.UIAbilityContext {
    return GlobalContext.context;
  }
}

@Component
struct FormItem {
  private label: string = '';
  private required: boolean = false;

  constructor(label: string, required?: boolean) {
    super();
    this.label = label;
    this.required = required ?? false;
  }

  build() {
    Row() {
      Text(this.label)
        .fontSize(16);
      if (this.required) {
        Text('*')
          .fontColor('#ff0000')
          .margin({ left: 4 });
      }
    }
    .margin({ top: 15, bottom: 8 })
    .width('100%')
    .justifyContent(FlexAlign.Start)
  }
}