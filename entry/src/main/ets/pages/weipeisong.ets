// pages/distribution_detail.ets

import router from '@ohos.router';

interface DistributionDetailProps {
  record: DistributionRecord; // 传递过来的配送记录
}
interface DistributionRecord {
  schoolName: string;
  documentNo: string;
  supplyDate: string;
  deliveryPhone?: string;
  summary?: string;
  gysDistributionGoodsList: GysDistributionGoods[];
}
interface GysDistributionGoods {
  foodName: string;
  specification: string;
  deliveriesNum: number;
  unit: string;
  supplyPricing: number;
  // 可根据实际需要补充其他字段
}
interface RouteParams {
  record: string; // JSON字符串格式的配送记录
}

@Entry
@Component
struct DistributionDetailPage {
  @State private props: DistributionDetailProps = {
    record: {
      schoolName: '',
      documentNo: '',
      supplyDate: '',
      deliveryPhone: '',
      summary: '',
      gysDistributionGoodsList: []
    }
  };

  aboutToAppear() {
    const params = router.getParams()as RouteParams;
    if (params && params.record) {
      this.props.record = JSON.parse(params.record);
    }
  }

  build() {
    Column() {
      // 标题部分
      Column() {
        Image($r('app.media.strip'))
          .width('100%')
          .height('3%');

        // 单据信息部分
        Column({ space: 8 }) {
          Row() { // 新增 Row 容器用于放置标题和印章
            Column({ space: 8 }) { // 标题内容
              Text(this.props.record.schoolName)
                .fontSize(24)
                .fontColor('#333333')
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 10 });

              Row() {
                Text('单据号:')
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#666666');
                Text(this.props.record.documentNo)
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#333333');
              }
              .width('70%')
              Row() {
                Text('供应时间:')
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#666666');
                Text(`${this.props.record.supplyDate} 上午`)
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#333333');
              }
              .width('70%')
              Row() {
                Text('需求单位:')
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#666666');
                Text(this.props.record.schoolName + '(库房)')
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#333333');
              }
              .width('70%')
              Row() {
                Text('下单人:')
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#666666');
                Text('系统用户')
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#333333');
              }
              .width('70%')
              Row() {
                Text('下单电话:')
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#666666');
                Text(this.props.record.deliveryPhone || '无')
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#333333');
              }
              .width('70%')
              Row() {
                Text('摘要:')
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#666666');
                Text(this.props.record.summary || '无')
                  .width('40%')
                  .fontSize(16)
                  .fontColor('#333333');
              }
              .width('70%')
            }
            .padding({
              left: 16,
              top: 8,
              bottom: 8
            });

            // 右侧印章图片
            Image($r('app.media.delivery0')) // 假设资源名为 unshipped_stamp
              .width(90) // 根据实际需要调整宽度
              .height(90) // 根据实际需要调整高度
              .margin({ left: 'auto', right: 0 }); // 靠右对齐
          }
          .width('100%'); // 确保 Row 容器占满宽度

          Image($r('app.media.strip'))
            .width('100%')
            .height('3%');

          // 底部按钮部分
          Row() {
            Button('+添加食材')
              .width('45%')
              .height(40)
              .backgroundColor('#4CAF50')
              .fontColor('#FFFFFF')
              .borderRadius(4)
              .onClick(() => {
                // 添加食材逻辑
              });

            Button('+批量添加检验报告')
              .width('45%')
              .height(40)
              .backgroundColor('#2196F3')
              .fontColor('#FFFFFF')
              .borderRadius(4)
              .onClick(() => {
                // 批量添加检验报告逻辑
              });
          }
          .margin({ top: 10 })
          .justifyContent(FlexAlign.SpaceBetween);
        }
        .width('100%')
        .padding({ top: 20, left: 16, right: 16 });
      }

      Column() {
        // 配送商品列表部分
        Scroll() {
          Column() {
            ForEach(this.props.record.gysDistributionGoodsList, (item: GysDistributionGoods) => {
              this.DistributionGoodsItem(item);
            });
          }
        }
        .width('100%')
        .layoutWeight(1);
      }
      .width('100%')
      .height('100%')
      .padding({ top: 20, left: 16, right: 16 });
    }
  }



  @Builder
  private DistributionGoodsItem(item: GysDistributionGoods) {
    Column() {
      // 商品名称和品牌
      Row() {
        Text(item.foodName)
          .fontSize(18)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold);

        Text(`品牌：${item.specification}`)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ left: 10 });
      }

      // 计划数量和配送数量
      Row() {
        Text('计划数量：')
          .fontSize(14)
          .fontColor('#666666');
        Text(`${item.deliveriesNum} ${item.unit}`)
          .fontSize(14)
          .fontColor('#333333');

        Text('配送数量：')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ left: 20 });
        Text('1 Kg') // 示例值，实际应从 item 中获取
          .fontSize(14)
          .fontColor('#333333');
      }

      // 供应价和合计
      Row() {
        Text('供应价：')
          .fontSize(14)
          .fontColor('#666666');
        Text(`${item.supplyPricing} 元/${item.unit}`)
          .fontSize(14)
          .fontColor('#333333');

        Text('合计：')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ left: 20 });
        Text('12.96元') // 示例值，实际应从 item 中计算
          .fontSize(14)
          .fontColor('#FF5722');
      }

      // 生产日期和备注
      Row() {
        Text('生产日期：')
          .fontSize(14)
          .fontColor('#666666');
        Text('请选择日期') // 示例值，实际应从 item 中获取
          .fontSize(14)
          .fontColor('#333333');
      }

      // 检验报告
      Row() {
        Text('检验报告')
          .fontSize(14)
          .fontColor('#333333');
        Image($r('app.media.avatar')) // 示例图片，实际应从 item 中获取
          .width(40)
          .height(40)
          .margin({ left: 10 });
      }
    }
    .padding(10)
    .border({ width: 1, color: '#E0E0E0', radius: 4 })
    .margin({ bottom: 10 });
  }
}
