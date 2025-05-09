import prompt from '@ohos.prompt';
import router from '@ohos.router';
import { Router } from '@kit.ArkUI';
import picker from '@ohos.file.picker';

interface GeneratedObjectLiteralInterface_1 {
  date: string;
  recipeName: string;
  mealType: string;
  diningType: string;
  place: string;
  photoUri: string;
}

@Entry
@Component
struct food_day_new {


  private selectDate: Date = new Date()
  @State date:string ='选择日期'
  @State selectedDate: string = '请选择筛选日期';
  @State recipeName: string = '';
  @State mealType: string = '';
  @State diningType: string = '';
  @State photoUri: string = '';
  private time =[]
  private photoCount: number = 0
  private unitOptions = [
     '早餐', '午餐', '晚餐','早点','午点','晚点','其他','营养改善计划'
  ]
  private classify=['不区分', '教师餐', '学生餐']
  private place=['实训第二学校餐厅']
  private photoPicker = new picker.PhotoViewPicker();
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
            TextInput({ placeholder: '请输入食谱名称' })
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
              .selected(0)
              .value('请选择餐别')
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
              .selected(0)
              .value('请选择用餐类型')
              .onSelect((index: number) => {
                this.diningType = this.unitOptions[index]
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
              .selected(0)
              .value(this.place[0])
              .onSelect((index: number) => {
                this.mealType = this.place[index]
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

          Image($r('app.media.evidence_add'))
            .width(100)
            .height(100)
            .objectFit(ImageFit.Contain)
            .margin({right:222})
            .onClick(() => {
              this.selectPhoto();
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
  private async selectPhoto() {
    try {
      let photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 20 - this.photoCount;
      
      let photoPickerResult = await this.photoPicker.select(photoSelectOptions);
      if (photoPickerResult && photoPickerResult.photoUris && photoPickerResult.photoUris.length > 0) {
        this.photoCount += photoPickerResult.photoUris.length;
        // Store the first photo URI for display
        this.photoUri = photoPickerResult.photoUris[0];
        prompt.showToast({
          message: `已选择 ${photoPickerResult.photoUris.length} 张图片`,
          duration: 2000
        });
      }
    } catch (err) {
      prompt.showToast({
        message: '选择图片失败',
        duration: 2000
      });
      console.error(`选择图片失败: ${err}`);
    }
  }

  // 表单提交逻辑
  private submitForm() {
    if (!this.selectedDate ||
      !this.recipeName ||
      !this.mealType ||
      !this.diningType
      // ||
      // !this.photoUri
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
    place: this.place[0],
      photoUri: this.photoUri
  };
    router.replaceUrl({
    url: 'pages/food_day',
    params: formData
  });
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