import router from '@ohos.router';

@Entry
@Component
struct Index {
  // 新增登录相关状态变量
  @State userUsername: string = '';
  @State userPassword: string = '';
build() {
  Stack() {
    Button('heek')
      .position({ x: 60, y: 60 })
      .onClick(() => {
        router.pushUrl({ url: 'pages/Today_VEG' });
      })

  }
}
}