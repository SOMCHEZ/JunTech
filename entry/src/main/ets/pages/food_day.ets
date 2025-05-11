import router from '@ohos.router';
import http from '@ohos.net.http';

//永久存储token和租户id
AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);

// 定义接收的参数类型
interface RecipeFormData {
  id?: string;
  formDataList: boolean;
  from: string;
  date?: string;
  recipeName?: string;
  mealType?: string;
  diningType?: string;
  place?: string;
  photoUri?: string;
}

interface RouteParams {
  token?: string;
  relTenantIds?: number;
  formDataList?: RecipeFormData[];
  from?: string;
  date?: string;
  recipeName?: string;
  mealType?: string;
  diningType?: string;
  place?: string;
  photoUri?: string;
}

interface RecipeListResult {
  records: RecipeFormData[];
  total: number;
  size: number;
  current: number;
}

interface RecipeListResponse {
  code: number;
  message: string;
  result: RecipeListResult;
  timestamp: number;
}

@Entry
@Component
struct food_day {
  private selectDate: Date = new Date()
  @State selectedMeal: string = '请选择餐别'
  @State selectedDate: string = '请选择筛选日期'
  private unitOptions = [
    '其他', '早餐', '午餐', '晚餐'
  ]
  @State formDataList: RecipeFormData[] = []
  @State receivedToken: string = ''
  @State tenantId: number = 0

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

    // 处理来自 food_day_new 的数据
    if (params?.from === 'food_day_new') {
      if (Array.isArray(params.formDataList)) {
        this.formDataList = params.formDataList;
      } else if (params.date || params.recipeName) {
        // 添加新条目到现有列表
        const newRecipe: RecipeFormData = {
          id: Date.now().toString(), // 生成唯一ID
          from: params.from,
          date: params.date,
          recipeName: params.recipeName,
          mealType: params.mealType,
          diningType: params.diningType,
          place: params.place,
          photoUri: params.photoUri,
          formDataList: false
        };
        this.formDataList = [...this.formDataList, newRecipe];
      }
    }
  }

  build() {
    Column() {
      // 顶部选择栏
      Row() {
        Select(this.unitOptions.map<SelectOption>((item: string) => ({ value: item })))
          .selected(0)
          .value(this.unitOptions[0])
          .onSelect((index: number) => {
            this.selectedMeal = this.unitOptions[index]
          })
          .margin(10)
          .width('40%')
          .height(40)
          .font({ size: 15 })

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
      }
      .width('100%')
      .margin({ bottom: 15 })

      // 数据展示区
      Column() {
        if (this.formDataList.length === 0) {
          Text('~ 暂无相关数据 ~')
            .fontSize(16)
            .fontColor(Color.Gray)
            .padding({ top: 200 })
            .textAlign(TextAlign.Center)
        } else {
          List() {
            ForEach(this.formDataList, (recipe: RecipeFormData) => {
              this.renderRecipeCard(recipe)
            }, (recipe: RecipeFormData) => recipe.id ?? recipe.recipeName ?? '')
          }
          .scrollBarWidth(0)
        }
      }
      .layoutWeight(1)
      // 新建食谱按钮 - 固定在底部
      Button('新建食谱', { type: ButtonType.Capsule })
        .width('90%')
        .height(50)
        .backgroundColor('#07C160')
        .fontColor('#FFFFFF')
        .fontSize(18)
        .borderRadius(12)
        .margin({ top: 10, bottom: 20 })
        .alignSelf(ItemAlign.Center)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/food_day_new',
            params: {
              token: this.receivedToken,
              relTenantIds: this.tenantId,
              formDataList: this.formDataList
            }
          })
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .padding({ left: 10, right: 10 })
  }

  @Builder
  renderRecipeCard(recipe: RecipeFormData) {
    Stack() {
      Column({ space: 5 }) {
        // 信息区
        Column() {
          Text(`食谱日期：${recipe.date}`)
            .fontSize(16)
            .fontColor('#222')
            .margin({ top: 8, bottom: 4 })
          Text(`食谱名称：${recipe.recipeName}`)
            .fontSize(16)
            .fontColor('#222')
            .margin({ bottom: 4 })
          Text(`餐    别：${recipe.mealType}`)
            .fontSize(16)
            .fontColor('#222')
            .margin({ bottom: 4 })
          Text(`用餐类型：${recipe.diningType}`)
            .fontSize(16)
            .fontColor('#222')
            .margin({ bottom: 4 })
          Text(`餐    厅：${recipe.place}`)
            .fontSize(16)
            .fontColor('#222')
            .margin({ bottom: 8 })
        }
        .alignItems(HorizontalAlign.Start)

        // 图片区
        if (recipe.photoUri) {
          Image(recipe.photoUri)
            .width(120)
            .height(90)
            .margin({ top: 8, bottom: 8 })
            .borderRadius(8)
        }

        Divider()
          .width('85%')
          .height(2)
          .color(Color.Gray)
          .margin({ left: 'auto', right: 'auto' })

        // 按钮区
        Row({ space: 16 }) {
          Button('重新编辑')
            .width(120)
            .height(36)
            .fontColor('#07C160')
            .fontSize(15)
            .borderRadius(18)
            .borderWidth(1)
            .borderColor('#07C160')
            .backgroundColor('#fff')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/food_day_new',
                params: {
                  token: this.receivedToken,
                  relTenantIds: this.tenantId,
                  date: recipe.date,
                  recipeName: recipe.recipeName,
                  mealType: recipe.mealType,
                  diningType: recipe.diningType,
                  place: recipe.place,
                  photoUri: recipe.photoUri
                }
              })
            })

          Button('删除单据')
            .width(120)
            .height(36)
            .fontColor('#07C160')
            .fontSize(15)
            .borderRadius(18)
            .borderWidth(1)
            .borderColor('#07C160')
            .backgroundColor('#fff')
            .onClick(() => {
              AlertDialog.show({
                title: "删除单据",
                message: "确定要删除吗？",
                alignment: DialogAlignment.Center,
                confirm: {
                  value: "确定",
                  fontColor: Color.Red,
                  backgroundColor: "#aabbcc",
                  action: () => {
                    this.formDataList = this.formDataList.filter(item => item !== recipe)
                  }
                }
              })
            })
        }
        .margin({ top: 16, bottom: 16 })
        .justifyContent(FlexAlign.Center)
      }
      .padding({ top: 16, bottom: 16 })
    }
    .width('90%')
    .margin({ top: 16, left: 'auto', right: 'auto' })
    .backgroundColor(Color.White)
    .border({ width: 2, color: Color.Green, radius: 8 })
  }

  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth() + 1
        const day = value.day ?? new Date().getDate()

        this.selectDate = new Date(year, month - 1, day)
        this.selectedDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }
}