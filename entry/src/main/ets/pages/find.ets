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
      Text("find")
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

  };

  try {
    let response = await httpRequest.request(
      url,
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json',
          'Tenant-Id':'100001',
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