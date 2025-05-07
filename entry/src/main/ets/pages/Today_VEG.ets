import router from '@ohos.router';
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';
import { PrintExtensionAbility } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  // 新增登录相关状态变量
  @State userUsername: string = '';
  @State userPassword: string = '';
  build() {
    Stack() {
      Text("caonima")
      Button('heek')
        .position({ x: 60, y: 60 })
        .onClick(async() => {
          const success = await Tv();
      })


    }
  }
}


async function Tv(): Promise<boolean> {
  let httpRequest = http.createHttp();

  interface Data {
    "recipeDate": "2025-04-30",
    "startTime": "2025-04-30",
    "endTime": "2025-04-30",
    "mealCategory": "0",
    "dishName": "鱼香周哥",
    "sampleType": "0",
    "demandUnit": "1651892693627330561",
    "demandUnitName": "浐灞二小餐厅",
    "recipeImg": "https://admin.suoeryun.com/pcUpload/1917469119841849345_1745995237687.png",
    "recipeStatus": "1"
  }
  interface TvResponse {
    success: boolean;
    message: string;
    code: number;
    result: null;
    timestamp: number;
  }

let url = 'https://api.suoeryun.com/ifood/jeecg-school/school/xxRecipeReported/add';
let data: Data = {
  "recipeDate": "2025-04-30",//食谱日期
  "startTime": "2025-04-30",//开始时间
  "endTime": "2025-04-30",//结束时间
  "mealCategory": "0",//类别
  "dishName": "鱼香周哥",//菜名
  "sampleType": "0",//样本类型
  "demandUnit": "1651892693627330561",
  "demandUnitName": "浐灞二小餐厅",//餐厅名
  "recipeImg": "https://admin.suoeryun.com/pcUpload/1917469119841849345_1745995237687.png",
  "recipeStatus": "1"
};

  try {
    let response = await httpRequest.request(
      url,
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json',
                  'Tenant-Id':'10021011',
                  'X-Access-Token':'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwd2QiOiI5NzJiNzBjMWQwNGQ3YTY0ZGFjYzUwYTY3MzkyOWRlZSIsImV4cCI6MTc0NzIwNjk5NywidXNlcm5hbWUiOiIxODk5MTI3NDI2MSJ9.EYOitkMTmOLRA6aegogPBwC7m2nd20O_uCJUDxsM1ak'
        },
        extraData: JSON.stringify(data)
      }
    );

    // 确保请求成功（HTTP 状态码为200）
    if (response.responseCode === 200) {
      const jsonResponse = JSON.parse(response.result as string) as TvResponse;
      // 将结果解析为JSON对象
      console.log('响应 code:', jsonResponse.code); // 获取code字段
      return jsonResponse.code === 200; // 返回code值
    } else {
      console.log('请求失败，状态码:', response.responseCode);
      return false;
    }
  } catch (error) {
    console.error('请求异常:', error);
    return false;
  }
}