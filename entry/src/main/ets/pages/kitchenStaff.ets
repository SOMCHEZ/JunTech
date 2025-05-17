import router from '@ohos.router';
import http from '@ohos.net.http';
//import { promptAction } from '@kit.ArkUI';
//import { PrintExtensionAbility } from '@kit.BasicServicesKit';

//永久存储token和租户id
AppStorage.setOrCreate('token', '');
AppStorage.setOrCreate('tenantId', 0);
//AppStorage.setOrCreate('man', 'fuck');

interface Staff {
  id: number;
  name: string;
  role: string;
}
interface Houchu_Delete_Request {
  success: boolean;
  code?: number;
  result:string;
  message?: string;
}
interface  records{//定义接口返回类型
  id?: number;
  schoolId: string;
  schoolName:  string;
  unitId: string;
  unitName: string;
  userName: string;// 后端返回的姓名
  //realname: string;
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
  man:string;
}
interface kitchenStaffs extends records {
  id:number;
  unitId: string;
  name: string;      // 对应原接口的username
  workplace: string; // 对应原接口的unitName
  status: string;    // 需确认来源字段
  issueTime: string; // 对应healthStartTime
  expireTime: string;// 对应healthEndTime
  type_dictText:string;//对应在职状态
  position: string;// 对应原接口的position
  tel: string;
  schoolId: string;
  schoolName:  string;
  //realname: string;
  idCard?: string;
  portraitPhoto?:string;
  type: string;//  后端返回的职位类型
  licenceIssuing: string;//  后端返回的营业执照有效期
  healthNumber: string;//  后端返回的健康证号
  healthUrl?: string;  // 后端返回的健康证图片
  photoQualification: string;//  后端返回的营业执照图片
  remark: string;//  后端返回的备注
  inspectionType?:number//  后端返回的职位类型
  version: number;//  后端返回的版本
  canteenId:  string;// 后端返回的食堂id
  wxopenId: string;// 后端返回的微信openid
  tenantId:  number;//  后端返回的租户id
  demandUnitIds:string;// 后端返回的食堂id
  code?: number;// 后端返回的code

}

@Entry
@Component
struct KitchenStaffList {

  @State selectedUnit: string = '所属单位';
  @State units: string[] = ['所属单位'];
  @State showDropdown: boolean = false;
  @State kitchenStaffs: kitchenStaffs[] = []; // 后厨人员数据
  @State kitchenNumbers: number = 0;
  @State receivedToken: string = '';//参数传递
  @State tenantId: number = 0;//同上
  @State unitId: string ='';
  @State tel: string = '';
  @State man: string = '';
  @State unitName : string = '';
  @State isDeleting: boolean = false;
  //@State Edit_Id: string = ''; // 保持字符串类型时
  //@State ddd:  string[] = [];




  async onPageShow() {//这是一个接收传递参数的方法
    // 使用接口类型断言
    const params = router.getParams() as RouteParams;
    //console.log('houch11u', params?.token);// 打印接收到的参数
    // 安全取值如果返回值空，则使用appsetcreat中所预保存的token和id
    if (!AppStorage.get('token') && params?.token) {
      AppStorage.set('token', params.token);
      //console.log('houchu', AppStorage.get('token'));
      //this.receivedToken = params.token;
    }
    if (!AppStorage.get('tenantId') && params?.relTenantIds) {
      AppStorage.set('tenantId', params.relTenantIds);
      //this.tenantId = params.relTenantIds;
    }

    // 同步到组件状态
    this.receivedToken = AppStorage.get('token')??'';
    this.tenantId = AppStorage.get('tenantId')??0;
    // console.log('houchu1', this.receivedToken);
    // console.log('houchu2', this.tenantId);

    const result = await this.Houchuchaxun();// 调用Houchuchaxun方法这个函数是用来查数据的

    //刚才删除的逻辑


    //删除的逻辑在上面
    if (result.records && result.records.length > 0) {

      this.unitId = result.records?.find(item =>//存放uid
      item?.unitId && item.unitId.trim() !== '',
      )?.unitId ?? 'default_unit_id'

    } else {
      //console.error('未获取到有效数据');
      this.unitId = ''; // 设置默认值
    }



    // 新增筛选逻辑
    const filteredRecords = result.records?.filter(item =>
    this.selectedUnit === '所属单位' ||  // 显示全部
      item.unitName === this.selectedUnit // 按选中单位过滤
    ) ?? [];

    if (result.success && filteredRecords) {
      this.kitchenStaffs = filteredRecords.map((item: records) => ({
        id: item.id || 0,
        unitId: item.unitId || '',
        name: item.userName || '',
        tel: item.tel || '',
        type: item.type || '未知类型',
        portraitPhoto: item.portraitPhoto || '',
        healthUrl: item.healthUrl || '',
        remark: item.remark || '',
        inspectionType: item.inspectionType || 0,
        version: item.version || 0,
        canteenId: item.canteenId || '',
        workplace: item.unitName || '',
        status: item.type_dictText || '未知状态',
        issueTime: item.healthStartTime || '未设置',
        expireTime: item.healthEndTime || '未设置',
        position: item.position || '未设置职位'
      } as kitchenStaffs));
    }
    // 在 onPageShow() 的 result 处理逻辑后添加：
    const unitNames = result.records?.map(item => item.unitName) ?? [];
    const filteredUnitNames = unitNames.filter(Boolean);
    const uniqueUnits = Array.from(new Set(filteredUnitNames));
    this.units = ['所属单位', ...uniqueUnits];


    if (result.records && result.records.length > 0) {

      this.unitName = result.records?.find(item =>//存放uid
      item?.unitName && item.unitName.trim() !== '',
      )?.unitName ?? 'default_unit_Name'

    } else {
      //console.error('未获取到有效数据');
      this.unitName = ''; // 设置默认值
    }
    if (result.success && filteredRecords) {
      this.kitchenStaffs = filteredRecords.map((item: records) => ({
        id: item.id || 0,
        unitId: item.unitId || '',
        name: item.userName || '',
        workplace: item.unitName || '',
        status: item.type_dictText || '未知状态',
        issueTime: item.healthStartTime || '未设置',
        expireTime: item.healthEndTime || '未设置',
        position: item.position || '未设置职位',
        tel: item.tel || '',
        //...其他字段映射
      } as kitchenStaffs));

      // 新增数量统计
      this.kitchenNumbers = this.kitchenStaffs.length;
    } else {
      this.kitchenNumbers = 0;
    }







    console.log('当前tel:', this.unitId)//打印uid
    // console.debug('所有unitIds:',//打印所有uid
    // result.records?.map(item => item.unitId).filter(Boolean)
    //)
    console.log('id',this.kitchenStaffs[0].id)//打印id
    console.log('kitchenStaffs', this.unitName);
    console.debug('所有单位:',//打印所有Id
      result.records?.map(item => item.unitName).filter(Boolean)
    )

    console.debug('所有tel:',//打印所有Id
      result.records?.map(item => item.tel).filter(Boolean)
    )
    console.log('man', this.man)
  }



  build() {
    Stack() {
      Column() {
        Row() {
          Select(this.units.map<SelectOption>((item: string) => ({ value: item })))
            .value(this.selectedUnit)
            .onSelect((index: number) => {
              this.selectedUnit = this.units[index]
              this.onPageShow();
            })
            .onClick(() => {
              this.onPageShow();
            })
        }

        .align(Alignment.Center)
        .padding({ left: 16, right: 16 });
        if (this.kitchenNumbers === 0 && this.selectedUnit !== '所属单位') {
          Text(`~ 在 ${this.selectedUnit} 中未找到相关人员 ~`)
            .fontSize(16)
            .fontColor(Color.Gray)
            .padding({ top: 200 })
            .textAlign(TextAlign.Center);
        }


        if (this.kitchenNumbers == 0) {
          Text('~ 暂无相关数据 ~')
            .fontSize(16)
            .fontColor(Color.Black)
            .padding({ top: 200 })
            .onClick(async() => {//这里藏了一个接口，点击后调取接口是查询的哦,但是我不用
              // const result = await this.Houchuchaxun();
              // console.log('houchu1', result);
            })
            .textAlign(TextAlign.Center); // 居中显示
        }
        else if(this.kitchenNumbers > 1) {
          this.renderMultipleStaffCards();
        } else {
          this.renderSingleStaffCard();
        }

        // 暂无相关数据提示（条件渲染）

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
        .position({x:35, y:'95%'})
        .onClick(() => {
          router.pushUrl({
            url: "pages/addStaff",
            params: {
              token: this.receivedToken,
              relTenantIds: this.tenantId,
              unitId:this.unitId
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

  private async Houchuchaxun(): Promise<HouchuHandlerResult> {//这个请求是针对查询后厨人员列表的
    try {
      const httpRequest = http.createHttp();

      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxUnitUser/list',
        {
          method: http.RequestMethod.GET,
          header: { //'Content-Type': 'application/json',
            'Tenant-Id':this.tenantId.toString(),
            'X-Access-Token':this.receivedToken
          },
          //extraData: JSON.stringify({//这里写body但是咱暂时不需要
          //username: this.userUsername,
          // password: this.userPassword
          // })

        }

      );

      if (response.responseCode !== 200) {
        //console.error('Login Error:'+response.responseCode);
        return {
          success: false,
          message: `HTTP Error: ${response.responseCode}`
          // 添加其他错误处理逻辑
        };
      }
      console.log('slfj'+response.result.toString())
      const jsonData = JSON.parse(response.result as string) as HouchuResponse;
      console.log('11',jsonData.result.records[1]);
      return {
        success: jsonData.code === 200,
        code: jsonData.code,
        records: jsonData.result.records,
        message: jsonData.message,
        //relTenantIds:jsonData.result.userInfo.relTenantIds
      };

    } catch (error) {
      console.error('Login Error:', JSON.stringify(error));
      return {
        success: false,
        message: '服务器繁忙'
      };
    }
  }



  private async HouchuDelete(staffId?: number): Promise<Houchu_Delete_Request> {//这个请求是针对查询后厨人员列表的

    try {
      const httpRequest = http.createHttp();

      const response = await httpRequest.request(
        'https://api.suoeryun.com/ifood/jeecg-school/school/xxUnitUser/delete',
        {
          method: http.RequestMethod.DELETE,
          header: { 'Content-Type': 'application/x-www-form-urlencoded',
            'Tenant-Id':this.tenantId.toString(),
            'X-Access-Token':this.receivedToken
          },
          extraData:
          `id=${staffId?.toString() ?? ''}`

        }

      );

      if (response.responseCode !== 200) {
        //console.error('Login Error:'+response.responseCode);
        return {
          success: false,
          result: '删除失败', // 新增默认值
          message: `HTTP Error: ${response.responseCode}`
          // 添加其他错误处理逻辑
        };
      }
      console.log('slfj'+response.result.toString())
      const jsonData = JSON.parse(response.result as string) as Houchu_Delete_Request;
      console.log('11',jsonData.result);
      return {
        success: jsonData.code === 200,
        code: jsonData.code,
        result: jsonData.result,
        message: jsonData.message,
        //relTenantIds:jsonData.result.userInfo.relTenantIds
      };

    } catch (error) {
      console.error('Login Error:', JSON.stringify(error));
      return {
        success: false,
        result: '删除失败', // 新增默认值
        message: '服务器繁忙'
      };
    }
  }//后厨人员删除接口


  @Builder
  renderMultipleStaffCards() {
    Scroll() {
      Column() {
        ForEach(this.kitchenStaffs, (staff: kitchenStaffs) => {
          this.renderStaffCard(staff);
        }, (staff: kitchenStaffs) => staff.name);
      }
    }
    .zIndex(0)
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
      Column({ space: 5}) {
        Text(staff.name)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10, left: 'auto' });

        Row({space:20}) {
          Text(`人员状态: ${staff.status}`)
            .fontSize(16)
            .fontColor(Color.Black)
          Text(`人员岗位: ${staff.position}`)
            .fontSize(16)
            .fontColor(Color.Black);
        }
        .width('85%')
        .margin({ left: 16 });

        Text(`发证日期: ${staff.issueTime}`)
          .width('85%')
          .fontSize(16)
          .fontColor(Color.Black)
          .margin({ left: 16 })
          .align(Alignment.TopStart)
        Text(`到期日期: ${staff.expireTime}`)
          .width('85%')
          .fontSize(16)
          .fontColor(Color.Black)
          .margin({ left: 16 })
        Text(`所属单位: ${staff.workplace}`)
          .width('85%')
          .fontSize(16)
          .fontColor(Color.Black)
          .margin({ left: 16, bottom: 16 });

        Divider()
          .width('85%')
          .height(3)
          .color(Color.Gray)
          .margin({ left: 'auto', right: 'auto' });

        Row({ space: 16 }) {
          Button({ type: ButtonType.Normal }) {
            Text('重新编辑')
              .fontSize(16)
              .fontColor(Color.Green)
          }
          .onClick(async () => {
            // this.Edit_Id  = await this.HouchuDelete(staff.id)
            console.log(staff.id?.toString())

            router.pushUrl({
              url: "pages/EditStaff",
              params: {
                token: this.receivedToken,
                relTenantIds: this.tenantId,

                unitId: this.unitId,
                editId: staff.id?.toString(), // 传递编辑ID

                //传送小卡片的数据
                name: staff.name?.toString(),
                status:  staff.status?.toString(),
                position: staff.position?.toString(),
                issueTime: staff.issueTime?.toString(),
                expireTime: staff.expireTime?.toString(),
                workplace: staff.workplace?.toString(),
                tel: staff.tel?.toString(),


              }
            });
            //console.log('Name',staff.name)
            console.log('status',staff.tel)
            // if() {
            //   this.onPageShow();
            //}


          })
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
          .onClick(() => {
            AlertDialog.show({                   // 点击按钮，弹出一个对话框
              title: "删除人员",                 // 设置标题
              message: "确认删除该人员？",          // 设置内容
              alignment: DialogAlignment.Center, // 设置弹窗的对齐方式
              confirm: {                         // 单个按钮的配置文本
                value: "确定",
                fontColor: Color.Red,
                backgroundColor: "#aabbcc",
                action:async () => {
                  console.log(staff.id?.toString())
                  const deleteResult = await this.HouchuDelete(staff.id)
                  console.log("牢莩是神")
                  console.log("牢俊nk",deleteResult)
                  if (deleteResult.success) {
                    // 删除成功后刷新列表
                    this.onPageShow();
                  }
                }
              }
            })
          })
        }
        .margin({ left: 'auto', right: 'auto', bottom: 16 });
      }
      .padding({ top: 16, bottom: 16 })
    }
    .width('95%')
    .height("38%")
    .margin({ top: 16, left: 'auto', right: 'auto' })
    .backgroundColor(Color.White)
    .border({ width: 2, color: Color.Green, radius: 8})
    .shadow({ radius: 20, color: '#07C160', offsetX: 20, offsetY: 10 })
    .zIndex(0)

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
    Stack() {
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
      .zIndex(100)
      .width('90%')
      .padding(10)
      .border({ width: 1, color: Color.Black, radius: 8 })

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
        .border({ width: 1, color: Color.Black, radius: 8 })
        .position({ x: 0, y: 48 }) // 设置位置
        .zIndex(200) // 设置 z-index
      }
    }
  }
}
