import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import '../../../common/Widget/loading_widget.dart';
import '../../../common/bean/HistoryBean.dart';
import '../../../common/config/app_color.dart';
import '../../../common/constant/constant.dart';
import '../../../routes/app_pages.dart';
import 'logic.dart';

class MePage extends GetView<MeLogic> {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profileWidget(),
          SizedBox(height: 10),
          functionWidget([
            functionItem(
              iconStr: "VIP",
              title: "会员订阅".tr,
              bgColor: AppColor.mainAppColor,
              tailWidget: Row(
                children: [
                  Obx(
                    () => (Constant.userInfo.value.vipExpires ?? false)
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppColor.subAppColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.diamond,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  "已开通".tr,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                ],
              ),
              onTap: () {
                controller.toVipPage();
              },
            ),
            // functionItem(
            //   iconStr: "HIS",
            //   title: "分析历史",
            //   bgColor: AppColor.sub1AppColor,
            //   onTap: () {
            //     print("分析历史");
            //   },
            // ),
            // functionItem(
            //   iconStr: "SET",
            //   title: "设置",
            //   bgColor: AppColor.sub2AppColor,
            //   onTap: () {
            //     Get.toNamed(AppRoutes.SETTING);
            //   },
            // ),
          ]),
          SizedBox(height: 15),
          tabWidget(),
          Expanded(child: historyWidget()),
        ],
      ),
    );
  }

  Widget profileWidget() {
    return Obx(
      () => Container(
        width: Get.width,
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.mainAppColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: Image.network(
                        Constant.userInfo.value.headUrl ?? "",
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${Constant.userInfo.value.nickname ?? ""}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("ID:${Constant.userInfo.value.id}"),
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.SETTING);
                    },
                    child: Icon(Icons.settings),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Container(width: Get.width, color: Colors.black12, height: 1),
              // SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: List.generate(controller.dataAnalysis.length, (
              //     int index,
              //   ) {
              //     return Column(
              //       children: [
              //         Text(
              //           "${controller.dataAnalysis[index].count}",
              //           style: TextStyle(
              //             fontSize: 19,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         Text(
              //           "${controller.dataAnalysis[index].desc}",
              //           style: TextStyle(
              //             color: Color(0xff666666),
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ],
              //     );
              //   }),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabWidget() {
    return Row(
      children: [
        Text(
          "我的分析记录".tr,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    ).marginSymmetric(horizontal: 15);
  }

  Widget historyWidget() {
    return EasyRefresh(
      controller: controller.refreshController,
      header: const MaterialHeader(color: Color(0xFF222222)),
      footer: ClassicFooter(
        position: IndicatorPosition.behind,
        dragText: '上拉加载'.tr,
        armedText: '释放开始'.tr,
        readyText: '上拉加载中'.tr,
        processingText: '上拉加载中...'.tr,
        processedText: '成功了'.tr,
        noMoreText: '没有更多'.tr,
        failedText: '失败了'.tr,
        messageText: '最后更新于 %T'.tr,
      ),
      onRefresh: controller.onRefresh,
      onLoad: controller.onLoad,
      child: Obx(
        () => controller.loading.value
            ? Center(child: LoadingWidget())
            : controller.historyList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                itemCount: controller.historyList.length,
                itemBuilder: (BuildContext context, int index) {
                  return historyItemWidget(controller.historyList[index]);
                },
              )
            : ListView(children: [Center(child: Text("暂无历史记录".tr))]),
      ),
    );
  }

  Widget historyItemWidget(HistoryBean historyBean) {
    return InkWell(
      onTap: (){
        controller.toDetail(historyBean);
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.sub2AppColor,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text(
                    "猫咪分析".tr,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  DateFormat(
                    "yyyy-MM-dd HH:mm",
                  ).format(DateTime.parse(historyBean.createdTime ?? "")),
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 15),
            // Row(
            //   children: [
            //     ClipRRect(
            //       borderRadius: BorderRadius.all(Radius.circular(100)),
            //       child: Image.network(
            //         Constant.userInfo.value.headUrl ?? "",
            //         width: 50,
            //         height: 50,
            //       ),
            //     ),
            //     Text("用户昵称".tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
            //   ],
            // ),
            Text(
              historyBean.resultContent?.content ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(historyBean.coverUrl ?? ""),
            ),
          ],
        ),
      ),
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
          child: ListView.separated(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return functionItemList[index];
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: functionItemList.length,
          ),
        ),
      ],
    ).marginSymmetric(horizontal: 10);
  }

  Widget functionItem({
    required String iconStr,
    required String title,
    required Function() onTap,
    required Color bgColor,
    Widget? tailWidget,
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
            child: Text(iconStr, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          Expanded(child: SizedBox()),
          tailWidget ?? Icon(Icons.keyboard_arrow_right, color: Colors.grey),
        ],
      ).marginSymmetric(vertical: 8),
    );
  }

  Widget myMotion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "我的运动库".tr,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xff0f172a),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffa3e635),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Icon(Icons.sports_tennis),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "网球(当前)".tr,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "已记录24次分析".tr,
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffa3e635),
                  shape: BoxShape.circle,
                ),
                child: Text("✔️"),
              ),
            ],
          ),
        ),
        SizedBox(height: 18),
        Obx(() => controller.showMoreMotion.value ? moreMotion() : SizedBox()),
        SizedBox(height: 18),
        InkWell(
          onTap: () {
            controller.showMoreMotion.toggle();
          },
          child: Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xff64748b),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 20),
                ),
                SizedBox(width: 10),

                Text("显示更多运动".tr, style: TextStyle(color: Color(0xff64748b))),
              ],
            ),
          ),
        ),
      ],
    ).paddingAll(20);
  }

  moreMotion() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 2.2,
      children: List.generate(controller.motionTypeList.length, (index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color(0xffe5e7eb),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Icon(
                  controller.motionTypeList[index].iconData,
                  color: Color(0xff94a3b8),
                ),
              ),
              SizedBox(width: 10),
              Text(
                controller.motionTypeList[index].name,
                style: TextStyle(color: Color(0xff94a3b8)),
              ),
            ],
          ),
        );
      }),
    );
  }
}
