import router from '@ohos.router';
import http from '@ohos.net.http';
//import { promptAction } from '@kit.ArkUI';
//import { PrintExtensionAbility } from '@kit.BasicServicesKit';

//永久存储token和租户id
AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);


interface  records{//定义接口返回类型
  id: string;
  schoolId: string;
  schoolName:  string;
  unitId: string;
  unitName: string;
  userName: string;// 后端返回的姓名
  realname: string;
  idCard?: string;
  portraitPhoto?:string;
  position:  string;//  后端返回的职位
  tel: string;// 后端返回的电话
  type: string;//  后端返回的职位类型
  type_dictText:string;// 后端返回的职位类型
  licenceIssuing: string;//  后端返回的营业执照有效期
  healthNumber: string;//  后端返回的健康证号
  healthUrl?: string;  // 后端返回的健康证图片
  healthStartTime: string;// 后端返回的营业执照有效期
  healthEndTime:  string;// 后端返回的营业执照有效期
  photoQualification: string;//  后端返回的营业执照图片
  remark: string;//  后端返回的备注
  inspectionType?:number//  后端返回的职位类型
  version: number;//  后端返回的版本
  canteenId:  string;// 后端返回的食堂id
  wxopenId: string;// 后端返回的微信openid
  tenantId:  number;//  后端返回的租户id
  demandUnitIds:string;// 后端返回的食堂id
  code?: number;// 后端返回的code

  // 其他字段根据实际API响应补充...
}

interface HouchuResult {
  records: records[];
  //token: string;
}

interface HouchuResponse {
  code: number;
  message: string;
  result: HouchuResult;
  timestamp: number;
}

interface HouchuHandlerResult {
  success: boolean;
  code?: number;
  records?: records[];
  message?: string;
}


interface RouteParams {
  token?: string;
  relTenantIds?: number;
}


interface kitchenStaffs{
  name: string;
  status: string;
  position: string;
  issueTime: string;
  expireTime: string;
  workplace: string;
}

@Entry
@Component
struct KitchenStaffList {
  @State selectedUnit: string = '所属单位';
  @State units: string[] = ['所属单位', '实训第二学校餐厅', '其他单位'];
  @State showDropdown: boolean = false;
  @State receivedToken: string = ''; // 参数传递
  @State tenantId: number = 0; // 同上
  @State kitchenNumbers: number = 3; // 修改为大于2的值
  @State kitchenStaffs: kitchenStaffs[] = [
    {
      name: '王师傅',
      status: '休假',
      position: '帮厨',
      issueTime: '2023-08-01',
      expireTime: '2024-08-01',
      workplace: '其他单位'
    },
    {
      name: '李贵',
      status: '在职',
      position: '垃圾回收',
      issueTime: '2023-07-01',
      expireTime: '2024-07-01',
      workplace: '实训第二学校餐厅'
    },
    {
      name: '张三',
      status: '在职',
      position: '厨师',
      issueTime: '2023-09-01',
      expireTime: '2024-09-01',
      workplace: '实训第二学校餐厅'
    }
  ];

  onPageShow() {
    // ...原有代码保持不变
  }

  build() {
    Stack() {
      Column({ space: 16 }) {
        Row() {
          DropdownSelector({
            selected: this.selectedUnit,
            options: this.units,
            showDropdown: this.showDropdown,
            onToggle: () => { this.showDropdown = !this.showDropdown; },
            onSelect: (unit: string) => {
              this.selectedUnit = unit;
              this.showDropdown = false;
            }
          })
        }
        .padding({ left: 16, right: 16 });

        if (this.kitchenNumbers > 2) {
          this.renderMultipleStaffCards();
        } else {
          this.renderSingleStaffCard();
        }

        // 暂无相关数据提示（条件渲染）
        if (this.kitchenStaffs.length === 0) {
          Text('~ 暂无相关数据 ~')
            .fontSize(16)
            .fontColor(Color.Gray)
            .padding({ top: 200 })
            .textAlign(TextAlign.Center); // 居中显示
        }

        // 返回按钮
        Image($r('app.media.left_icon'))
          .width(32)
          .height(32)
          .position({ bottom: 16, right: 16 });
        // 新建后厨人员按钮

        Button({ type: ButtonType.Normal }) {
          Text('新建后厨人员')
            .fontSize(18)
            .fontColor(Color.White)
        }
        .width('80%')
        .height(45)
        .backgroundColor("#4CAF50")
        .fontColor(Color.White)
        .borderRadius(8)
        .margin({ top:'auto', left: 'auto', right: 'auto' })
        .onClick(() => {
          router.pushUrl({
            url: "pages/addStaff_test",
            params: {
              token: this.receivedToken,
              relTenantIds: this.tenantId
            }
          });
        });
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White);
    }
    .backgroundColor("#f5f5f5");
  }

  @Builder
  renderMultipleStaffCards() {
    Scroll() {
      Column() {
        ForEach(this.kitchenStaffs, (staff: kitchenStaffs) => {
          this.renderStaffCard(staff);
        }, (staff: kitchenStaffs) => staff.name);
      }
    }
    .scrollBarWidth(0)
    .height('85%');
  }

  @Builder
  renderSingleStaffCard() {
    if (this.kitchenStaffs.length > 0) {
      this.renderStaffCard(this.kitchenStaffs[0]);
    }
  }

  @Builder
  renderStaffCard(staff: kitchenStaffs) {
    Stack() {
      Column({ space: 8 }) {
        Text(staff.name)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 16, left: 16 });

        Row({ space: 16 }) {
          Text(`人员状态 ${staff.status}`)
            .fontSize(16)
            .fontColor(Color.Gray);
          Text(`人员岗位 ${staff.position}`)
            .fontSize(16)
            .fontColor(Color.Gray);
        }
        .margin({ left: 16 });

        Text(`发证日期 ${staff.issueTime} 到期日期 ${staff.expireTime}`)
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ left: 16 });

        Text(`所属单位 ${staff.workplace}`)
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ left: 16, bottom: 16 });

        Divider()
          .width('90%')
          .margin({ left: 'auto', right: 'auto' });

        Row({ space: 16 }) {
          Button({ type: ButtonType.Normal }) {
            Text('重新编辑')
              .fontSize(16)
              .fontColor(Color.Green)
          }
          .width(150)
          .height(40)
          .borderRadius(20)
          .backgroundColor(Color.White)

          Button({ type: ButtonType.Normal }) {
            Text('删除人员')
              .fontSize(16)
              .fontColor(Color.Green)
          }
          .width(150)
          .height(40)
          .borderRadius(20)
          .backgroundColor(Color.White)
        }
        .margin({ left: 'auto', right: 'auto', bottom: 16 });
      }
      .padding({ top: 16, bottom: 16 });
    }
    .width('95%')
    .margin({ top: 16, left: 'auto', right: 'auto' })
    .backgroundColor(Color.White)
    .border({ width: 2, color: Color.Green, radius: 8})
  }
}
@Component
struct DropdownSelector {
  @Link selected: string;
  options: string[] = [];
  @State showDropdown: boolean = false;

  // 新增回调函数类型属性
  onToggle?: () => void;
  onSelect?: (unit: string) => void;

  build() {
    Column() {
      Row() {
        Text(this.selected)
          .fontSize(16);

        Image($r('app.media.down'))
          .width(16)
          .height(16)
          .onClick(() => { // ✅ 改为只在点击下拉箭头时触发
            this.showDropdown = !this.showDropdown;
            if (this.onToggle) {
              this.onToggle();
            }
          })
      }
      .width('70%')
      .padding({ left: 8, right: 8, top: 8, bottom: 8 })
      .border({ width: 1, color: Color.Gray, radius: 8 })

      if (this.showDropdown) {
        Scroll() {
          Column() {
            ForEach(this.options, (unit: string) => {
              Text(unit)
                .fontSize(16)
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .onClick(() => {
                  this.selected = unit;
                  this.showDropdown = false;
                  if (this.onSelect) {
                    this.onSelect(unit);
                  }
                })
            }, (unit: string) => unit)
          }
        }
        .scrollBarWidth(0)
        .width('100%')
        .backgroundColor(Color.White)
        .border({ width: 1, color: Color.Gray, radius: 8 })
        .position({ x: 0, y: 48 })
        .zIndex(100)
      }
    }
  }
}



