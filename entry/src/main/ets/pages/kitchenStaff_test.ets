import router from '@ohos.router';
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';
import { PrintExtensionAbility } from '@kit.BasicServicesKit';

//add定义申明

interface RouteParams {
  token?: string;
  relTenantIds?: number;
}
@Entry
@Component
struct KitchenStaffList {
  @State selectedUnit: string = '所属单位';
  @State units: string[] = ['所属单位', '实训第二学校餐厅', '其他单位'];
  @State showDropdown: boolean = false;
  @State kitchenStaffs: string[] = []; // 后厨人员数据


  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上

  onPageShow() {//这是一个接收传递参数的方法
    // 使用接口类型断言
    const params = router.getParams() as RouteParams;
    console.log('aaa', params?.token);// 打印接收到的参数
    console.log('bbb', params?.relTenantIds);//  打印接收到的参数

    // 安全取值
    if (params?.token) {
      this.receivedToken = params.token;
    }

    if (params?.relTenantIds) {
      this.tenantId = params.relTenantIds;
    }
  }



  build() {
    Stack() {
      Column({
        space: 16
      }) {
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
        Button({type: ButtonType.Normal}){
          Text('新建后厨人员')
            .fontSize(16)
            .fontColor(Color.White)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .borderRadius(8)
            .onClick(() => {
              router.pushUrl({          // 使用push入栈一个新页面
                url: "pages/addStaff_test"  // 通过url指定新打开的页面
                ,
                params:{
                  token:this.receivedToken,
                  relTenantIds:this.tenantId

                }
              })
            })
        }
        .width('80%')
        .height(45)
        .backgroundColor(Color.Green)
        .fontColor(Color.White)
        .borderRadius(8)
        .onClick(() => {
          console.log('New kitchen staff button clicked');
        })
        .margin({ top: 385 });
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White);
    }.backgroundColor("#ff969696")
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
