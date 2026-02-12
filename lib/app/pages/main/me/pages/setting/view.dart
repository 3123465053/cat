import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/config/app_color.dart';
import '../../../../../common/constant/constant.dart';
import 'logic.dart';

class SettingPage extends GetView<SettingLogic> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackgroundColor,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            functionWidget(funcName: "账户".tr, [
              Obx(
                () =>
                    Constant.userInfo.value.appAccountToken != null &&
                        Constant.userInfo.value.appAccountToken!.contains(
                          "custom",
                        )
                    ? functionItem(
                        leadingIcon: Icon(Icons.apple),
                        title: "绑定Apple账户".tr,
                        bgColor: AppColor.sub2AppColor,
                        onTap: () {
                          controller.login(0);
                        },
                      )
                    : SizedBox(),
              ),

              Obx(
                () =>
                    Constant.userInfo.value.appAccountToken != null &&
                        Constant.userInfo.value.appAccountToken!.contains(
                          "custom",
                        )
                    ? functionItem(
                        leadingIcon: Icon(Icons.refresh, color: Colors.grey),
                        title: "恢复购买".tr,
                        bgColor: AppColor.sub3AppColor,
                        onTap: () {
                          controller.login(1);
                        },
                      )
                    : SizedBox(),
              ),

              Obx(
                () =>
                    Constant.userInfo.value.appAccountToken != null &&
                        !Constant.userInfo.value.appAccountToken!.contains(
                          "custom",
                        )
                    ? functionItem(
                        leadingIcon: Icon(Icons.link_off, color: Colors.red),
                        title: "注销账户".tr,
                        bgColor: AppColor.sub4AppColor,
                        onTap: () {
                          showDeleteConfirmDialog();
                        },
                      )
                    : SizedBox(),
              ),
            ]),

            SizedBox(height: 20),
            functionWidget(funcName: "其他".tr, [
              functionItem(
                iconStr: "DOC",
                title: "用户协议".tr,
                bgColor: AppColor.sub2AppColor,
                onTap: () {
                controller.toPrivacy(type: 1);
                },
              ),
              functionItem(
                iconStr: "PRI",
                title: "隐私政策".tr,
                bgColor: AppColor.sub3AppColor,
                onTap: () {
                  controller.toPrivacy(type: 2);
                },
              ),
              functionItem(
                iconStr: "ABT",
                title: "关于我们".tr,
                bgColor: AppColor.sub4AppColor,
                onTap: () {
                  controller.toPrivacy(type: 3);
                },
              ),
            ]),
            Obx(() => Constant.userInfo.value.appAccountToken != null &&
                !Constant.userInfo.value.appAccountToken!.contains("custom")
                ? buildLogoutButton()
                : SizedBox()),
          ],
        ),
      ),
    );
  }

  appBar() {
    return AppBar(
      backgroundColor: AppColor.pageBackgroundColor,
      title: Text("设置".tr, style: TextStyle(fontSize: 18)),
      centerTitle: false,
    );
  }

  //功能组件
  Widget functionWidget(List functionItemList, {String? funcName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (funcName != null)
          Text(
            funcName,
            style: TextStyle(color: Colors.grey),
          ).paddingOnly(left: 8),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return functionItemList[index];
            },
            // separatorBuilder: (BuildContext context, int index) {
            //   return Divider();
            // },
            itemCount: functionItemList.length,
          ),
        ),
      ],
    ).marginSymmetric(horizontal: 10);
  }

  Widget functionItem({
    String? iconStr,
    required String title,
    required Function() onTap,
    required Color bgColor,
    Widget? leadingIcon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child:
                leadingIcon ??
                Text(
                  iconStr ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          Expanded(child: SizedBox()),
          Icon(Icons.keyboard_arrow_right, color: Colors.grey),
        ],
      ).marginSymmetric(vertical: 10),
    );
  }

  //退出登录
  Widget buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        showLogoutConfirmDialog();
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
            child: Text(
              "退出登录".tr,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )),
      ),
    );
  }

  // 显示退出登录确认对话框
  void showLogoutConfirmDialog() {
    showCupertinoDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('退出登录'.tr),
        content: Text('确定要退出登录吗？'.tr),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Get.back(),
            isDefaultAction: true,
            child: Text('取消'.tr),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: Text('确认退出'.tr),
          ),
        ],
      ),
    );
  }



  //删除账户弹窗
  void showDeleteConfirmDialog() {
    showCupertinoDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('注销账户'.tr),
        content: Text('确定要注销账户吗？\n将删除所有数据，不可恢复'.tr),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Get.back(),
            isDefaultAction: true,
            child: Text('取消'.tr),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Get.back();
              controller.deleteAccount();
            },
            child: Text('确认注销'.tr),
          ),
        ],
      ),
    );
  }
}
