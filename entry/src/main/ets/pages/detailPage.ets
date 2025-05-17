import router from '@ohos.router';
import http from '@ohos.net.http';

interface PageParams {
  id?: string;
  schoolName?: string;
  mealDate?: string;
  mealCategory?: string;
  dutposition?: string;
}

interface XXMealRecordInfo {
  position: string;
  images: string;
}

interface XXMealRecordDetail {
  id: string;
  mealDate: string;
  mealCategory: string;
  xxMealRecordInfoList: Array<XXMealRecordInfo>;
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
    const params = router.getParams() as PageParams;
    this._id = params.id ?? '';
    this.schoolName = params.schoolName ?? '';
    this.mealDate = params.mealDate ?? '';
    this.mealCategory = params.mealCategory ?? '';
    this.dutposition = params.dutposition ?? '';
  }

  build() {
    Column() {
      Text('陪餐记录详情')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      Row() {
        Text('学校：')
        TextInput({ placeholder: this.schoolName })
          .onChange((value: string) => {
            this.schoolName = value;
          })
          .layoutWeight(1)
      }

      Row() {
        Text('时间：')
        TextInput({ placeholder: this.mealDate })
          .onChange((value: string) => {
            this.mealDate = value;
          })
          .layoutWeight(1)
      }

      Row() {
        Text('餐别：')
        TextInput({ placeholder: this.mealCategory })
          .onChange((value: string) => {
            this.mealCategory = value;
          })
          .layoutWeight(1)
      }

      Row() {
        Text('陪餐人职务：')
        TextInput({ placeholder: this.dutposition })
          .onChange((value: string) => {
            this.dutposition = value;
          })
          .layoutWeight(1)
      }

      Button('提交')
        .margin({ top: 20 })
        .onClick(async () => {
          await this.submitData();
        })

    }
    .width('100%')
    .padding(20)
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
            id: this._id,
            schoolName: this.schoolName,
            mealDate: this.mealDate,
            mealCategory: this.mealCategory,
            xxMealRecordInfoList: [{
              position: this.dutposition,
              images: "https://admin.suoeryun.com/pcUpload/32-32-0430180520.png"
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