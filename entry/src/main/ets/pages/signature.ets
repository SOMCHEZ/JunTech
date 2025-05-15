import router from '@ohos.router';

interface Signer {
  name: string;
  role: string;
}

@Entry
@Component
struct SignaturePage {
  @State selectedSigner: number = 0;
  private signers: Array<Signer> = [
    { name: '王主管', role: '保管员' },
    { name: 'Y经理', role: '主管' }
  ];

  build() {
    Column() {
      // 顶部栏
      Row() {
        // 返回按钮
        Image($r('app.media.left_icon'))
          .width(32).height(32)
          .margin({ left: 10, right: 8, top: 8, bottom: 8 })
          .onClick(() => router.back());
        // 标题
        Column() {
          Text('出库电子签')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center);

        }
        .layoutWeight(1);
        // 更多按钮
        Image($r('app.media.about'))
          .width(28).height(28)
          .margin({ right: 10, top: 8, bottom: 8 });
      }
      .height(56)
      .backgroundColor('#F5F5F5')
      .alignItems(VerticalAlign.Center)
      .borderRadius({ bottomLeft: 16, bottomRight: 16 })
      .shadow({ radius: 8, color: '#E0E0E0', offsetX: 0, offsetY: 2 });

      // 签名区域
      Column() {
        Blank()
          .width('92%')
          .height(380)
          .backgroundColor('#EAEAEA')
          .borderRadius(18)
          .margin({ top: 24, left: '4%', right: '4%', bottom: 24 })
          .shadow({ radius: 8, color: '#E0E0E0', offsetX: 0, offsetY: 2 });
      }
      .layoutWeight(1);

      // 底部操作区
      Row() {
        // 左侧按钮组
        Column() {
          Button('保存')
            .type(ButtonType.Capsule)
            .backgroundColor('#07C160')
            .fontColor('#fff')
            .fontSize(18)
            .width(100)
            .height(54)
            .margin({ bottom: 12 });
          Button('清除')
            .type(ButtonType.Capsule)
            .backgroundColor('#F5F5F5')
            .fontColor('#333')
            .fontSize(18)
            .width(100)
            .height(54)
            .margin({ bottom: 12 });
          Button('回退')
            .type(ButtonType.Capsule)
            .backgroundColor('#F5F5F5')
            .fontColor('#333')
            .fontSize(18)
            .width(100)
            .height(54);
        }
        .margin({ left: 32, right: 24 });

        // 右侧签名人选择
        Column() {
          ForEach(this.signers, (signer: Signer, idx: number) => {
            Row() {
              // 圆形单选
              Stack() {
                // 外圈
                Row() {
                  Blank()
                    .width(24).height(24)
                    .backgroundColor('#fff')
                    .border({ width: 2, color: idx === this.selectedSigner ? '#07C160' : '#ccc', style: BorderStyle.Solid })
                    .borderRadius(12)
                    .margin({ right: 8 })
                    .onClick(() => this.selectedSigner = idx);
                }
                // 内圈（选中时显示）
                if (idx === this.selectedSigner) {
                  Row() {
                    Blank()
                      .width(12).height(12)
                      .backgroundColor('#07C160')
                      .borderRadius(6)
                      .position({ x: 6, y: 6 });
                  }
                }
              }

              .margin({ right: 4 });
              Text(signer.role)
                .fontSize(16)
                .fontColor('#888')
                .margin({ right: 4 });
              Text(signer.name)
                .fontSize(18)
                .fontColor('#222');
            }
            .margin({ bottom: 14 })
            .onClick(() => this.selectedSigner = idx);
          });
        }
        .margin({ left: 24 });
      }
      .margin({ bottom: 32, top: 8 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff');
  }
}