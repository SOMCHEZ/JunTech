import { router } from '@kit.ArkUI'
import preferences from '@ohos.data.preferences'
import common from '@ohos.app.ability.common'

// 定义后厨人员接口
interface KitchenStaff {
  id: string;
  name: string;
  position: string;
  phone: string;
  certificate: string;
  certExpiry: string;
  joinDate: string;
  status: string;
}

@Entry
@Component
struct Chenjian1Page {
  @State staffList: KitchenStaff[] = []
  private context = getContext(this) as common.UIAbilityContext

  aboutToAppear() {
    this.getStaffList()
  }

  onPageShow() {
    this.getStaffList()
  }

  private async getStaffList() {
    try {
      const prefer = await preferences.getPreferences(this.context, 'myPreferences')
      const storageStaff = await prefer.get('staffList', '[]')
      if (storageStaff) {
        this.staffList = JSON.parse(storageStaff as string)
        // 按入职日期倒序排列，最新的显示在前面
        this.staffList.sort((a, b) => new Date(b.joinDate).getTime() - new Date(a.joinDate).getTime())
      }
    } catch (error) {
      console.error('获取人员数据失败:', error)
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.about'))
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            try {
              router.pushUrl({
                url: 'pages/chenjian'
              })
            } catch (error) {
              console.error('路由跳转失败：', error)
            }
          })
        Text('未晨检人员')
          .fontSize(18)
          .fontColor('#ff000000')
          .margin({ left: 85 })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#00C853')

      // 主要内容区域
      Column() {
        if (this.staffList.length === 0) {
          // 无数据时显示提示
          Column() {
            Blank()
            Text('~暂无相关数据~')
              .fontSize(15)
              .fontColor('#BBBBBB')
            Blank()
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          // 有数据时显示列表
          List() {
            ForEach(this.staffList, (staff: KitchenStaff) => {
              ListItem() {
                Column() {
                  Row() {
                    Text('姓    名：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.name)
                      .fontSize(16)
                      .fontColor('#333')
                    Blank()
                    Text(staff.status)
                      .fontSize(14)
                      .fontColor(staff.status === '在职' ? '#4CAF50' : '#FF5722')
                      .backgroundColor(staff.status === '在职' ? '#E8F5E9' : '#FBE9E7')
                      .borderRadius(4)
                      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('职    位：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.position)
                      .fontSize(16)
                      .fontColor('#333')
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('联系电话：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.phone)
                      .fontSize(16)
                      .fontColor('#333')
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('健康证号：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.certificate)
                      .fontSize(16)
                      .fontColor('#333')
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('证件有效期：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.certExpiry)
                      .fontSize(16)
                      .fontColor('#333')
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })

                  Row() {
                    Text('入职日期：')
                      .fontSize(16)
                      .fontColor('#666')
                    Text(staff.joinDate)
                      .fontSize(16)
                      .fontColor('#333')
                  }
                  .width('100%')
                  .padding({ top: 5, bottom: 5 })
                }
                .width('100%')
                .padding(16)
                .backgroundColor('#FFF')
                .border({
                  width: 1,
                  color: '#4CAF50',
                  style: BorderStyle.Solid
                })
                .borderRadius(8)
              }
              .margin({ bottom: 10 })
            })
          }
          .width('100%')
          .padding(10)

          // 底部显示-END-
          Text('-END-')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 20, bottom: 20 })
            .width('100%')
            .textAlign(TextAlign.Center)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
    }
    .width('100%')
    .height('100%')
  }
}
