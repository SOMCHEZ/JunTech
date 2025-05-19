import router from '@ohos.router';
import http from '@ohos.net.http';

interface PageParams {
  id?: string;
  schoolName?: string;
  mealDate?: string;
  mealCategory?: string;
  position?: string;
}

interface XXMealRecordInfo {
  position: string;
  images: string[];
}

interface XXMealRecordDetail {
  id: string;
  mealDate: string;
  mealCategory: string;
  xxMealRecordInfoList: Array<XXMealRecordInfo>;
}
interface DetailParams {
  schoolName?: string;
  mealDate?: string;
  mealCategory?: string;
  dutposition?: string;
  photoUrl?: string;
}
@Entry
@Component
struct DetailPage {
  @State private _id: string = '';
  @State private schoolName: string = '';
  @State private mealDate: string = '';
  @State private mealCategory: string = '';
  @State private dutposition: string = '';
  @State private receivedToken: string = '';

  aboutToAppear() {
    const params = router.getParams() as DetailParams;
    if (params) {
      this.schoolName = params.schoolName ?? '未知学校';
      this.mealDate = params.mealDate ?? '未知日期';
      this.mealCategory = params.mealCategory ?? '未知餐别';
      this.dutposition = params.dutposition ?? '未知职位';
    }
    // const params = router.getParams() as PageParams;
    // this._id = params.id ?? '';
    // this.schoolName = params.schoolName ?? '';
    // this.mealDate = params.mealDate ?? '';
    // this.mealCategory = params.mealCategory ?? '';
    // this.dutposition = params.position ?? '';
    console.log('1111:', params.schoolName)
    console.log('1111:', this.schoolName)
  }

  build() {
    Column() {
      Text('陪餐记录详情')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 30 })
        .textAlign(TextAlign.Center)
        .width('100%')

      Row() {
        Text('学校：')
          .width(80)
          .fontSize(16)
          .fontColor('#333')
        TextInput({ placeholder: this.schoolName })
          .onChange((value: string) => {
            this.schoolName = value;
          })
          .width('100%')
          .padding({ left: 10 })
          .borderWidth(1)
          .borderColor('#ccc')
          .layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: 15 })

      Row() {
        Text('时间：')
          .width(80)
          .fontSize(16)
          .fontColor('#333')
        TextInput({ placeholder: this.mealDate })
          .onChange((value: string) => {
            this.mealDate = value;
          })
          .width('100%')
          .padding({ left: 10 })
          .borderWidth(1)
          .borderColor('#ccc')
          .layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: 15 })

      Row() {
        Text('餐别：')
          .width(80)
          .fontSize(16)
          .fontColor('#333')
        TextInput({ placeholder: this.mealCategory })
          .onChange((value: string) => {
            this.mealCategory = value;
          })
          .width('100%')
          .padding({ left: 10 })
          .borderWidth(1)
          .borderColor('#ccc')
          .layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: 15 })

      Row() {
        Text('陪餐人职务：')
          .width(100)
          .fontSize(16)
          .fontColor('#333')
        TextInput({ placeholder: this.dutposition })
          .onChange((value: string) => {
            this.dutposition = value;
          })
          .width('100%')
          .padding({ left: 10 })
          .borderWidth(1)
          .borderColor('#ccc')
          .layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: 15 })

      Button('提交')
        .width('100%')
        .height(45)
        .backgroundColor('#FF0CE730')
        .fontColor('#fff')
        .fontSize(16)
        .margin({ top: 360})
        .onClick(async () => {
          await this.submitData();
        })

    }
    .width('100%')
    .padding(20)
    .backgroundColor('#f9f9f9') // 背景色
  }

  private async submitData(): Promise<void> {
    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxMealRecord/edit',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'X-Access-Token': this.receivedToken
          },
          extraData: JSON.stringify({
            id: this.id,
            schoolName: this.schoolName,
            mealDate: this.mealDate,
            mealCategory: this.mealCategory,
            xxMealRecordInfoList: [{
              position: this.dutposition,
              images: ["https://admin.suoeryun.com/pcUpload/32-32-0430180520.png"]
            }] satisfies Array<XXMealRecordInfo>
          })
        }
      );

      if (response.responseCode === 200) {
        console.log('更新成功');
        router.back();
      } else {
        console.error('更新失败:', response.responseCode);
      }
    } catch (error) {
      console.error('更新异常:', error);
    }
  }
}