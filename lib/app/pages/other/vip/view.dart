import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/Widget/close_widget.dart';
import '../../../common/config/app_color.dart';
import 'logic.dart';

class VipPage extends GetView<VipLogic> {
  const VipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            "assets/images/vip/vip_bg.png",
            width: Get.width,
            height: Get.height,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 60,
            right: 0,
            left: 0,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    desc(),
                    SizedBox(height: 20),
                    priceWidget(),
                    SizedBox(height: 30),
                    buyBtn(),
                    SizedBox(height: 10),
                    privacy(),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CloseWidget(
                  onTap: () {
                    controller.close();
                  },
                  color: Colors.grey,
                ),
              ],
            ).marginSymmetric(horizontal: 15, vertical: 15),
          ),
        ],
      ),
    );
  }

  //权益说明
  Widget desc() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Text(
          "一键破解猫咪的“语言密码”与品种奥秘".tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        Column(
          children: List.generate(controller.descList.length, (int index) {
            return Row(
              children: [
                Image.asset('assets/images/vip/duigou.png', width: 20),
                SizedBox(width: 5),
                Expanded(child: Text(
                  controller.descList[index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ],
            ).marginOnly(bottom: 12);
          }),
        ).marginSymmetric(horizontal: 15),
      ],
    );
  }

  Widget priceWidget() {
    return Row(
      children: [
        Expanded(
          child: priceItem(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            index: 0,
          ),
        ),
        Expanded(
          child: priceItem(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            index: 1,
          ),
        ),
      ],
    ).marginSymmetric(horizontal: 15);
  }

  Widget priceItem({
    required BorderRadiusGeometry borderRadius,
    required int index,
  }) {
    return Obx(
      () {
        Map dataMap=(controller.priceList.length>=index&&controller.priceList.isNotEmpty)?controller.priceList[index]:{};
        return InkWell(
          onTap: () {
            controller.opTapPriceItem(index);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: controller.selectIndex.value == index
                  ? AppColor.subAppColor
                  : Colors.transparent,
              border: controller.selectIndex.value == index
                  ? Border.all(color: AppColor.mainAppColor, width: 2)
                  : Border(
                top: BorderSide(width: 2, color: Colors.grey.shade200),
                bottom: BorderSide(width: 2, color: Colors.grey.shade200),
                left: BorderSide(
                  width: index == 0 ? 2 : 0.1,
                  color: Colors.grey.shade200,
                ),
                right: BorderSide(
                  width: index == 0 ? 0.1 : 2,
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${dataMap["productName"]??"--"}".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: controller.selectIndex.value == index
                            ? Color(0xfffaaf19)
                            : Colors.black,
                      ),
                    ),
                    Text(
                      "\$${ dataMap["price"]??"--"}",
                      style: TextStyle(
                        color: controller.selectIndex.value == index
                            ? Color(0xfffaaf19)
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buyBtn() {
    return InkWell(
      onTap: (){
        controller.payHandle();
      },
      child: Container(
        width: Get.width,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Color(0xfffaaf19),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text("继续".tr,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        // child: Obx(() => Text(
        //   (controller.priceList.isNotEmpty &&
        //       controller.priceList[controller.selectIndex.value]
        //       ["productName"]
        //           .toString()
        //           .contains("年"))
        //       ? "三天免费试用".tr
        //       : "继续".tr,
        //   style: const TextStyle(
        //       color: Colors.white,
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold),
        // )
        // ),
      ),
    );
  }

  Widget privacy() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: (){
            controller.toPrivacy(type: 1);
          },
          child: Text("用户协议".tr, style: TextStyle(color: Colors.grey)),
        ),
        InkWell(
          onTap: (){
            controller.toPrivacy(type: 2);
          },
          child: Text("隐私政策".tr, style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
