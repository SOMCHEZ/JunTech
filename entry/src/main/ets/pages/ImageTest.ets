import http from '@ohos.net.http';

interface ImageListResponse {
  urls: string[];
}

@Entry
@Component
struct ImageSelector {
  @State imageList: string[] = [];
  @State selectedImage: string | null = null;
  private httpClient = http.createHttp();

  build() {
    List() {
      ForEach(this.imageList, (url: string) => {
        ListItem() {
          Image(url)
            .width(100)
            .height(100)
            .objectFit(ImageFit.Cover)
            .onClick(() => {
              this.selectedImage = url;
            })
        }
      })
    }
    .onAppear(() => this.loadImages())
  }


  private async loadImages() {
    console.log('开始加载')
    try {
      console.log('发起请求')
      const response = await this.httpClient.request(
        "https://5ddd.com/xiaoys",
        {
          method: http.RequestMethod.GET,
          expectDataType: http.HttpDataType.STRING, // 关键配置
          connectTimeout: 5000,
        }
      );
      console.log('收到响应:',response.result)
      if (response.responseCode === 200 && typeof response.result === 'string') {
        const data: ImageListResponse = JSON.parse(response.result);
        if (Array.isArray(data?.urls)) {
          this.imageList = data.urls.filter(url =>
            url.startsWith('http') || url.startsWith('data:image')
          );
        }
      }
    } catch (error) {
      console.error('图片加载失败:', error);
    }finally {
      this.httpClient.destroy();
    }
  }
}
