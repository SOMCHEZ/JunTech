import { promptAction } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import prompt from '@ohos.prompt';
import router from '@ohos.router';
import http from '@ohos.net.http';


//永久存储token和租户id
AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);
AppStorage.setOrCreate('unitId', '');

interface PlanningFoodItem {
  id: string;
  storehouseId: number | null;
  foodAndSupplierId: string;
  foodId: string;
  supplyWay: string;
  superiorLimit: number | null;
  lowerLimit: number | null;
  storageLocation: number | null;
  stock: number | null;
  storehouseStatus: number | null;
  izCollect: string;
  encoding: string;
  groupId: string;
  groupName: string;
  foodName: string;
  forShort: string;
  internationalCode: number | null;
  pinyinCode: string;
  specification: string;
  expirationDay: number | null;
  brandLevel: string;
  minDeclare: number | null;
  unit: string;
  packageQuantity: number | null;
  procurementPricing: number | null;
  supplyPricing: number | null;
  marketPrice: number | null;
  modifyPrice: number | null;
  supplyNames: string;
  supplyName: string;
  supplierId: string;
  aggregatePurchasePrice: number | null;
  images: string;
  izConvert: number | null;
  realSpecification: string;
  placeOrigin: string;
  remarks: number | null;
  remark: number | null;
  testReport: number | null;
  supplyWay_dictText: string;
  quantitySupplied: string;
  marketWeight: number | null;
}
interface addHandlerResult {
  success: boolean;
  code?: number;
  userInfo?: UserInfo;
  token?: string;
  message?: string;
  relTenantIds?:number;
}
interface addResult {
  userInfo: UserInfo;
  token: string;
}
interface addResponse {
  code: number;
  message: string;
  result: addResult;
  timestamp: number;
}
interface RouteParams {//接口传递参数定义
  token?: string;
  relTenantIds?: number;
  unitId?: string;
}
interface UserInfo {
  id: string;
  username: string;
  clientType: string;
  realname: string;
  avatar: string | null;
  relTenantIds:number;
  // 其他字段根据实际API响应补充...
}
interface SelectOption{
  value: string;
  label: string;
}
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
struct DatePickerExample {

  @State selectedDate: string = ''
  @State selectDate: Date = new Date()
  @State showDialog: boolean = false
  @State opacityValue: number = 0
  @State scaleValue: number = 0.8
  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上
  @State displayTime: string = ''
  @State unitId: string  ="";
  @State summary: string = ''// 摘要内容
  @State selectedText: string[] = ['请选择','请选择','请选择','请选择','请选择','请选择','请输入摘要']
  @State private showMealType: boolean = false // 控制是否显示用餐类型
  private unitOptions = ['实验第二学校（库房）', '实验第二学校餐厅']
  private selectedTime = ['forenoon', 'afternoon']
  private demandOptions = ['学生餐', '老师餐']
  private mealTypeOptions = ['其他','营养餐']
  private mealOptions = ['其他', '早餐', '午餐', '晚餐']

/*
  为了满足你的需求，可以将 [selectedText](file://D:\DevEcoStudioProjects\MyApplication3\entry\.preview\default\cache\default\default@PreviewArkTS\esmodule\debug\entry\src\main\ets\pages\c.ts#L154-L156) 中的文本选项（如“请选择”、“请输入摘要”）和最终选择值（如“实验第二学校（库房）”）映射为对应的数组类型字符串 `1,2,3`。以下是实现步骤：

### 1. 定义映射关系
首先定义一个映射对象，将每个选项的标签对应到其实际值。

```ts
private mapping = {
  '实验第二学校（库房）': '1',
  '实验第二学校餐厅': '2',
  'forenoon': '1',
  'afternoon': '2',
  '学生餐': '1',
  '老师餐': '2',
  '其他': '1',
  '营养餐': '2',
  '早餐': '1',
  '午餐': '2',
  '晚餐': '3'
};
```


### 2. 获取映射后的数据
在需要获取数组类型的字符串时，可以通过遍历 [selectedText](file://D:\DevEcoStudioProjects\MyApplication3\entry\.preview\default\cache\default\default@PreviewArkTS\esmodule\debug\entry\src\main\ets\pages\c.ts#L154-L156) 数组并使用映射对象进行转换。

```ts
private getMappedValues(): string[] {
  return this.selectedText.map(text => this.mapping[text] || text); // 如果没有匹配项，则保留原值
}
```


### 3. 使用映射后的数据
当需要提交表单或执行其他操作时，调用 `getMappedValues()` 方法来获取映射后的数据。

```ts
let mappedValues = this.getMappedValues();
console.log('Mapped Values:', mappedValues); // 输出：["1", "2", ...]
```


### 4. 显示原始选项
在 UI 显示时，仍然使用 [selectedText](file://D:\DevEcoStudioProjects\MyApplication3\entry\.preview\default\cache\default\default@PreviewArkTS\esmodule\debug\entry\src\main\ets\pages\c.ts#L154-L156) 数组中的原始值，以确保用户看到的是可读性更强的文本。

### 5. 示例代码整合
以下是如何整合到代码中的示例：

```ts
@Entry
@Component
struct DatePickerExample {
  @State selectedText: string[] = ['请选择', '请选择', '请选择', '请选择', '请选择', '请选择', '请输入摘要'];
  @State private showMealType: boolean = false;
  private unitOptions = ['实验第二学校（库房）', '实验第二学校餐厅'];
  private selectedTime = ['forenoon', 'afternoon'];
  private demandOptions = ['学生餐', '老师餐'];
  private mealTypeOptions = ['其他', '营养餐'];
  private mealOptions = ['其他', '早餐', '午餐', '晚餐'];

  // 映射关系
  private mapping = {
    '实验第二学校（库房）': '1',
    '实验第二学校餐厅': '2',
    'forenoon': '1',
    'afternoon': '2',
    '学生餐': '1',
    '老师餐': '2',
    '其他': '1',
    '营养餐': '2',
    '早餐': '1',
    '午餐': '2',
    '晚餐': '3'
  };

  // 获取映射后的值
  private getMappedValues(): string[] {
    return this.selectedText.map(text => this.mapping[text] || text);
  }

  build() {
    Column() {
      Button('显示映射值') {
        let mappedValues = this.getMappedValues();
        console.log('Mapped Values:', mappedValues);
      }
    }
  }
}
```


### 总结
- **保持 UI 可读性**：`selectedText` 仍使用原始文本（如“请选择”、“实验第二学校（库房）”），以便用户理解。
- **数据处理**：通过 `mapping` 对象将文本映射为数字字符串（如 `1`, `2`, `3`），方便后续逻辑处理或提交给后端。
- **灵活性**：如果某些值不需要映射，可以直接保留在 `selectedText` 中。
 */
  async onPageShow() {
    const params = router.getParams() as RouteParams;
    //console.log('houchu', params?.token);// 打印接收到的参数
    //console.log('houchu', params?.relTenantIds);//  打印接收到的参数

    // 安全取值如果返回值空，则使用appsetcreat中所预保存的token和id
    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
      //this.receivedToken = params.token;
    }

    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
      //this.tenantId = params.relTenantIds;
    }

    if (!AppStorage.get('unitId') && params?.unitId) {
      AppStorage.set('unitId', params.unitId);
      //this.UnitId = params.unitId;
    }

    // 同步到组件状态
    this.receivedToken = AppStorage.get('token')??'';
    this.tenantId = AppStorage.get('tenantId')??0;
    this.unitId = AppStorage.get('unitId') ?? '';
    console.log('rel',this.unitId);
    console.log('UID', params?.unitId);
    //const result = await this.Houchuchaxun();// 调用Houchuchaxun方法这个函数是用来查数据的
    //console.log('houchu1', result); // 打印返回结果
  }

  private async addStaff(): Promise<addHandlerResult> {
    try {
      const httpRequest = http.createHttp();
     // let a:string = '1'
      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxDemandPlanning/addOrUpdate',
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json',
            'Tenant-Id':this.tenantId.toString(),
            'X-Access-Token':this.receivedToken
          },
          extraData: JSON.stringify({
            "unitId": this.unitId,
            "supplyDate": this.selectedText[1],
            "supplyTime": this.selectedText[2],
            //"requirementType": a,
            "planningFoodList": [
              {
                "id": "",
                "storehouseId": null,
                "foodAndSupplierId": "",
                "foodId": "",
                "supplyWay": "",
                "superiorLimit": null,
                "lowerLimit": null,
                "storageLocation": null,
                "stock": null,
                "storehouseStatus": null,
                "izCollect": "",
                "encoding": "",
                "groupId": "",
                "groupName": "",
                "foodName": "",
                "forShort": "",
                "internationalCode": null,
                "pinyinCode": "",
                "specification": "",
                "expirationDay": null,
                "brandLevel": "",
                "minDeclare": null,
                "unit": "",
                "packageQuantity": null,
                "procurementPricing": null,
                "supplyPricing": null,
                "marketPrice": null,
                "modifyPrice": null,
                "supplyNames": "",
                "supplyName": "",
                "supplierId": "",
                "aggregatePurchasePrice": null,
                "images": "",
                "izConvert": null,
                "realSpecification": "",
                "placeOrigin": "",
                "remarks": null,
                "remark": null,
                "testReport": null,
                "supplyWay_dictText": "",
                "quantitySupplied": "",
                "marketWeight": null
              }
            ] as  Array<PlanningFoodItem>,
            "summary": "",
            "mealType": "1",
            "mealCategory": "1",
            "unitName": "实训第二学校(库房)",
            "unitType": "1",
            "planningStatus": "1"
          })
        }
      );

      if (response.responseCode !== 200) {
        return {
          success: false,
          message: `HTTP Error: ${response.responseCode}`
          // 添加其他错误处理逻辑
        };
      }

      const jsonData = JSON.parse(response.result as string) as addResponse;
      //console.log('', response.responseCode);
      //console.log('',jsonData.code);
      return {
        success: jsonData.code === 200,
        code: jsonData.code,
        //userInfo: jsonData.result.userInfo,
        // token: jsonData.result.token,
        message: jsonData.message,
        relTenantIds:jsonData.result.userInfo.relTenantIds
      };
    } catch (error) {
      //console.error('Login Error:', JSON.stringify(error));
      return {
        success: false,
        message: 'fuck u!'
      };
    }
  }

  build() {
    Stack(){
      Column() {
        Column(){
          Column({ space: 10 }) {
            this.buildLabelRow($r("app.media.unitName"), "需求单位", true, 0)
            this.buildLabelRow($r("app.media.supplyDate"), "供应日期", true, 1)
            this.buildLabelRow($r("app.media.supplyTime"), "供应时间", false, 2)
            this.buildLabelRow($r("app.media.demand"), "需求类型", true, 3)

            // 条件用餐类型行
            if (this.showMealType) {
              this.buildLabelRow($r("app.media.requirementType"), "用餐类型", true, 4)
            }

            this.buildLabelRow($r("app.media.mealCategory"), "餐别", true, 5)
            this.buildLabelRow($r("app.media.remarks"), "摘要", false, 6)
          }
          .width('100%')
          .padding(10)

          // 添加食材按钮
          Row() {
            Button({type: ButtonType.Normal}) {
              Text('+添加食材')
                .fontSize(16)
                .fontColor(Color.White)
                .padding({
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8
                })
                .borderRadius(8)
                .onClick(() => {
                  // 跳转到 chuku 页面
                  router.pushUrl({
                    url: 'pages/renew'
                  });

                });
            }
            .width('80%')
            .height(35)
            .backgroundColor('#02BC65')
            .fontColor(Color.White)
            .borderRadius(8)
            .width('auto')
            .padding({ left: 15, right: 15 })

            Text('已选中*种食材')
              .fontColor('#8A96A2')
              .position({ x: 137, y: 15 })
          }

          Column()//渐变框
            .linearGradient({
              angle: 180,
              colors: [['#93D0B1', 0.1],['#FDFDFD',1]],
            })
            .margin({top: 10})
            .width('100%')
            .height(20)
        }
        .layoutWeight(1)

        if (this.showDialog) {
          // 半透明背景层
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#80000000')
            .position({ x: 0, y: 0 })
            .opacity(this.opacityValue)
            .onClick(() => {
              animateTo({
                duration: 300,
                curve: Curve.EaseOut
              }, () => {
                this.opacityValue = 0
                this.scaleValue = 0.8
              })
              setTimeout(() => {
                this.showDialog = false
              }, 300)
            })
            .zIndex(2)

          // 对话框内容
          Column() {
            Text('摘要')
              .fontSize(18)
              .margin({ bottom: 16 })

            TextArea({ text:this.summary,placeholder: '输入摘要'})

              .onChange((value: string) => {
                // this.summary = value
                this.selectedText[6] = value
              })
              .height(150)
              .width('100%')
              .border({
                width: 2,                     // 边框宽度
                color: '#4CAF50',             // 边框颜色
                radius: 8,                    // 圆角半径

              })

            Row({space:100}) {
              Button('取消', {type: ButtonType.Normal})
                .onClick(() => { this.showDialog = false })
                .backgroundColor('#ffffffff')
                .fontColor('#ff706f6f')
              Button('确定', {type: ButtonType.Normal})
                .backgroundColor('#ffffffff')
                .fontColor('#5BC043')
                .onClick(() => { this.showDialog = false })
            }
          }
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .width('80%')
          .position({ x: '11%', y: '30%' })
          .opacity(this.opacityValue)
          .scale({ x: this.scaleValue, y: this.scaleValue })
          .animation({
            duration: 300,
            curve: Curve.EaseOut
          })
          .zIndex(2)
        }
        // 底部按钮部分
        Column() {
          Row() {
            Text('总计：*元')
              .fontColor('#8A96A2')
              .fontSize(16)
              .margin({ right: 10 })

            Button({type: ButtonType.Normal}){
              Text('保存')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .height(35)
            .backgroundColor('#02BC65')
            .fontColor(Color.White)
            .borderRadius(8)
            .width('auto')
            .padding({ left: 15, right: 15 })

            Button({type: ButtonType.Normal}){
              Text('保存上报')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .onClick(async() => {
              router.pushUrl({
                url: 'pages/uploadPlan',
                params: {
                  token: this.receivedToken,
                  tenantId: this.tenantId,
                } })
              console.log('meal',this.selectedText[2]);
              const result = await this.addStaff()

              //this.submitForm();
            })
            .height(35)
            .backgroundColor('#02BC65')
            .fontColor(Color.White)
            .borderRadius(8)
            .width('auto')
            .padding({ left: 15, right: 15 })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: 20 })
        }
        .padding(10)
        .zIndex(1)
      }}

  }

  @Builder
  buildLabelRow(iconResource: Resource, label: string, showAsterisk: boolean, index: number) {
    Column() {
      Row() {
        // 左侧图标和标签
        Row() {
          Image(iconResource)
            .width(30)
            .height(30)
            .objectFit(ImageFit.Contain)
            .margin({ right: 10 })

          Text(label)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)

          if (showAsterisk) {
            Text("*")
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Red)
              .margin({ left: 4 })
          }
        }
        .layoutWeight(1)

        // 右侧选择区域
        Row() {
          // 使用固定宽度容器包裹 Text 组件

          if (label === "摘要") {
            Column() {
              Text(this.selectedText[index] === '请输入摘要' ? '请输入摘要' :
                `${this.selectedText[index].substring(0, 10)}${this.selectedText[index].length > 10 ? '...' : ''}`)
                .fontSize(14)
                .fontColor(this.selectedText[index] === '请输入摘要' ? '#000000' : '#000000')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('250px')

            }
            .alignItems(HorizontalAlign.End)
          } else {
            Text(this.selectedText[index])
              .fontSize(14)
              .fontColor('#000000')
          }


          Image($r("app.media.ic_arrow_right"))
            .width(20)
            .height(20)
            .margin({ left: 5 })
            .fillColor('#8A96A2')
        }

        .justifyContent(FlexAlign.End) // 确保文本和箭头靠右对齐

        .onClick(() => {
          switch (label){
            case "需求单位":
              this.showTextDialog(this.unitOptions,0)
              break;
            case "供应日期":
              this.showDateDialog()
              break;
            case "供应时间":
              this.showTextDialog(this.selectedTime,2)
              break;
            case "需求类型":
              this.showTextDialog(this.demandOptions,3)
              break;
            case "用餐类型":
              this.showTextDialog(this.mealTypeOptions,4)
              break;
            case "餐别":
              this.showTextDialog(this.mealOptions,5)
              break;
            case "摘要":
              this.summary = this.selectedText[6] === '请输入摘要' ? '' : this.selectedText[6]
              this.showDialog = true
              this.opacityValue = 1
              this.scaleValue = 1
              break;

          }
        })      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .height(40)
      .padding({ right: 10 })

      // 添加横线
      Divider()
        .strokeWidth(1)
        .color('#ffb1afaf')
        .margin({ top: 0, bottom: 7 })
    }
    .width('100%')
  }
  //日历函数

  private showDateDialog() {
    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2100-1-1'),
      selected: this.selectDate,
      onAccept: (value: DatePickerResult) => {
        const year = value.year ?? new Date().getFullYear()
        const month = value.month ?? new Date().getMonth()+1
        const day = value.day ?? new Date().getDate()
        this.selectDate = new Date(year, month-1 , day)
        this.selectedText[1] = `${year}-${(month+1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`
      }
    })
  }

  private showTextDialog(array:string[],index:number) {
    TextPickerDialog.show({
      range: array,
      selected: array.findIndex(item => item === this.selectedText[index]),
      canLoop:false,
      onAccept: (value: TextPickerResult) => {
        if (typeof value.index === 'number' && value.index < array.length) {
          this.selectedText[index] = array[value.index]
          this.displayTime = this.selectedText[index] === 'forenoon' ? '上午' : this.selectedText[index]
        }
        switch (index){
          case 3:
            if(this.selectedText[index] === '学生餐')
              this.showMealType = true
            else{
              this.showMealType = false
              this.selectedText[4] = '请选择'
            }
            break;
          case 4:
            this.showMealType = true
            break;
          default :
            if(!this.showMealType){
              this.showMealType = false
              this.selectedText[4] = '请选择'
            }
            break;
        }
      }
    })
  }

  private submitForm() {
    // 验证必填项
    const isStudentMeal = this.selectedText[3] === '学生餐';

    // if (this.selectedText[0] === '请选择' ||  // 需求单位
    //   this.selectedText[1] === '请选择' ||  // 供应日期
    //   this.selectedText[3] === '请选择' ||  // 需求类型
    //   this.selectedText[5] === '请选择'     // 餐别
    // ) {
    //   prompt.showToast({
    //     message: '请填写所有必填项',
    //     duration: 2000
    //   });
    //   return;
    // }
    // 如果是学生餐，则必须填写用餐类型
    if (isStudentMeal && this.selectedText[4] === '请选择') {
      prompt.showToast({
        message: '请选择用餐类型',
        duration: 2000
      });
      return;
    }
    prompt.showToast({
      message: '保存成功',
      duration: 2000
    });

    // 创建表单数据对象
    let formData: GeneratedObjectLiteralInterface_1 = {
      date: this.selectedText[2] === '请选择'
        ? this.selectedText[1]
        : `${this.selectedText[1]} ${this.selectedText[2]}`,
      recipeName: this.selectedText[1], // 使用已选择的日期
      mealType: this.selectedText[3],   // 使用已选择的餐别
      diningType: isStudentMeal ? this.selectedText[4] : '', // 非学生餐时为空 用餐类型
      place: this.selectedText[5],      // 需求单位
      photoUri: this.selectedText[0]    // 餐别（如果需要）
    };

    // 跳转到 'uploadPlan' 页面并传递 formData
    router.back ({
      url: 'pages/uploadPlan',  // 页面路径
      params: formData          // 传递的参数
    });
  }
}