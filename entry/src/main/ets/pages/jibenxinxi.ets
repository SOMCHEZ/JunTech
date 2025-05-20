// Page1.ets
interface CompanyInfo {
  companyName: string
  registrationNumber: string
  establishmentDate: string
  legalPerson: string
  fixedPhone: string
  address: string
  contactPerson: string
  businessScope: string
  openingBank: string
  bankAccount: string
  remarks: string
}


@Entry
@Component
struct CompanyInfoPage {
  @State companyInfo: CompanyInfo = {
    companyName: '彦红粮油有限公司',
    registrationNumber: '2221558',
    establishmentDate: '2025-05-16',
    legalPerson: 'mmm',
    fixedPhone: '',
    address: '',
    contactPerson: '彦红',
    businessScope: '渭南市',
    openingBank: '',
    bankAccount: '',
    remarks: ''
  }

  build() {
    Scroll() {
      Column() {
        // 基本信息标题区域
        this.buildBaseInfoHeader()

        // ✅ 公司名称
        Row() {
          Column() {
            Text('公司名称 *')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            // 修改 buildInputItem 方法中的 TextInput 部分
            TextInput({ placeholder: '请输入公司名称',text: this.companyInfo.companyName })
              .onChange((value: string) => {
                this.companyInfo.companyName=  value
              })
              .fontSize(16)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .alignItems(HorizontalAlign.End)
          .width('70%')
        }
        .margin({ bottom: 10 })

        // ✅ 注册编号
        Row() {
          Column() {
            Text('注册编号')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            // 修改 buildInputItem 方法中的 TextInput 部分
            TextInput({ placeholder: '请输入注册编号',text: this.companyInfo.registrationNumber })
              .onChange((value: string) => {
                this.companyInfo.registrationNumber=  value
              })
              .fontSize(16)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .alignItems(HorizontalAlign.End)
          .width('70%')
        }
        .margin({ bottom: 10 })

        // ✅ 成立时间
        Row() {
          Column() {
            Text('成立时间')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            TextInput({ placeholder: '请输入成立时间',text: this.companyInfo.establishmentDate })
              .onChange((value: string) => {
                this.companyInfo.establishmentDate=  value
              })
              .fontSize(16)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .alignItems(HorizontalAlign.End)
          .width('70%')
        }
        .margin({ bottom: 10 })

        // ✅ 法人
        Row() {
          Column() {
            Text('法人')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            // 修改 buildInputItem 方法中的 TextInput 部分
            TextInput({ placeholder: '请输入法人',text: this.companyInfo.legalPerson})
              .onChange((value: string) => {
                this.companyInfo.legalPerson=  value
              })
              .fontSize(16)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .alignItems(HorizontalAlign.End)
          .width('70%')
        }
        .margin({ bottom: 10})

        // ✅ 固定电话
        Row() {
          Column() {
            Text('固定电话')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            // 修改 buildInputItem 方法中的 TextInput 部分
            TextInput({ placeholder: '请输入固定电话',text: this.companyInfo.fixedPhone })
              .onChange((value: string) => {
                this.companyInfo.fixedPhone=  value
              })
              .fontSize(16)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .alignItems(HorizontalAlign.End)
          .width('70%')
        }
        .margin({ bottom: 10 })

        // ✅ 地址
        Row() {
          Column() {
            Text('地址')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            // 修改 buildInputItem 方法中的 TextInput 部分
            TextInput({ placeholder: '请输入地址',text: this.companyInfo.address })
              .onChange((value: string) => {
                this.companyInfo.address =  value
              })
              .fontSize(16)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .alignItems(HorizontalAlign.End)
          .width('70%')
        }
        .margin({ bottom: 10 })

        // ✅ 联系人
        Row() {
          Column() {
            Text('联系人')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            // 修改 buildInputItem 方法中的 TextInput 部分
            TextInput({ placeholder: '请输入联系人',text: this.companyInfo.contactPerson })
              .onChange((value: string) => {
                this.companyInfo.contactPerson=  value
              })
              .fontSize(16)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .alignItems(HorizontalAlign.End)
          .width('70%')
        }
        .margin({ bottom: 10 })

        // ✅ 经营范围
        Row() {
          Column() {
            Text('经营范围 *')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            // 修改 buildInputItem 方法中的 TextInput 部分
            TextInput({ placeholder: '请输入经营范围',text: this.companyInfo.businessScope })
              .onChange((value: string) => {
                this.companyInfo.businessScope=  value
              })
              .fontSize(16)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .alignItems(HorizontalAlign.End)
          .width('70%')
        }
        .margin({ bottom: 10 })

        // ✅ 开户银行
        Row() {
          Column() {
            Text('开户银行')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            // 修改 buildInputItem 方法中的 TextInput 部分
            TextInput({ placeholder: '请输入开户银行',text: this.companyInfo.openingBank })
              .onChange((value: string) => {
                this.companyInfo.openingBank=  value
              })
              .fontSize(16)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .alignItems(HorizontalAlign.End)
          .width('70%')
        }
        .margin({ bottom: 10 })

        // ✅ 银行账号
        Row() {
          Column() {
            Text('银行账号')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            // 修改 buildInputItem 方法中的 TextInput 部分
            TextInput({ placeholder: '请输入银行账号',text: this.companyInfo.bankAccount })
              .onChange((value: string) => {
                this.companyInfo.bankAccount=  value
              })
              .fontSize(16)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .alignItems(HorizontalAlign.End)
          .width('70%')
        }
        .margin({ bottom: 10 })

        // ✅ 备注
        Column() {
          Row() {
            Text('备注')
              .fontSize(14)
              .fontColor('#666666')
          }
          .margin({ bottom: 5})
          .width('100%')
          Row() {
            // 修改 buildInputItem 方法中的 TextInput 部分
            TextInput({ placeholder: '请输入备注',text: this.companyInfo.remarks })
              .onChange((value: string) => {
                this.companyInfo.remarks=  value
              })
              .fontSize(16)
              .height(80)
              .fontColor('#999999')
              .placeholderColor('#999999')  // 修复后的属性名
              .borderWidth(0) // 去除边框
          }
          .width('100%')
        }
        // 提交按钮
        Button('提交')
          .width('90%')
          .height(40)
          .margin({ top: 20, bottom: 30 })
          .backgroundColor('#007DFF')
          .fontColor('#FFFFFF')
          .onClick(() => {
            //添加储存信息
            console.log('提交成功')
          })
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#FFFFFF')
  }

  // 基本信息标题组件
  @Builder
  buildBaseInfoHeader() {
    Column() {
      Text('基本信息')
        .fontSize(18)
        .fontColor('#000000')
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 6 })

      // 标题分隔线（比字段分隔线更粗）
      Divider()
        .strokeWidth(1.5)
        .color('#E5E5E5')
        .margin({ bottom: 20 })
    }
    .width('100%')
  }

  // 构建信息项
  @Builder
  buildInfoItem(label: string, value: string, required?: boolean) {
    Column() {
      Row() {
        if (required) {
          Text(label)
            .fontSize(14)
            .fontColor('#FF0000')
        } else {
          Text(label)
            .fontSize(14)
            .fontColor('#666666')
        }
      }
      .width('100%')
      .margin({ bottom: 4 })

      Text(value)
        .fontSize(16)
        .fontColor('#000000')
        .margin({ bottom: 14 })
    }
    .width('100%')
  }

  // 分隔线组件
  @Builder
  buildDivider() {
    Divider()
      .strokeWidth(1)
      .color('#ff100c0c')
      .margin({ bottom: 14 })
  }
}

