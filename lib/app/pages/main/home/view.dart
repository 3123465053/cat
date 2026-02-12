import 'package:audioplayers/audioplayers.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/config/app_color.dart';
import '../../../common/enum/MotionType.dart';
import '../../../routes/app_pages.dart';
import 'logic.dart';

class HomePage extends GetView<HomeLogic> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topBar(),
            SizedBox(height: 15),
            bannerWidget(),
            SizedBox(height: 30),
            sceneTypeWidget(),
            SizedBox(height: 15),
            pickerAndShoot(),
            SizedBox(height: 10),
            // Text("视频时长一分钟以内").paddingSymmetric(horizontal: 10),
            // SizedBox(height: 20),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     //  print(Constant.userInfo.value.nickname);
      //     //    Get.toNamed(AppRoutes.LOGIN, arguments: {"loginType": 1});
      //     Get.toNamed(AppRoutes.VIP);
      //     //  AppCommonApi.getUserInfo();
      //
      //     // try{  FlutterTts flutterTts = FlutterTts();
      //     // var result = await flutterTts.speak("Hello");
      //     // print("dafdfsdsd");
      //     // print(result);}catch(e){
      //     //   print("dfasff$e");
      //     // }
      //   },
      // ),
    );
  }

  topBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.mainAppColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 35,
                height: 35,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xff2C2C2C),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "AI喵语言翻译管家".tr,
                            style: TextStyle(
                              color: AppColor.mainAppColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "一键破解猫咪的“语言密码”与品种奥秘".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   height: 45,
                    //   padding: EdgeInsets.all(8),
                    //   alignment: Alignment.center,
                    //   decoration: BoxDecoration(
                    //     color: AppColor.mainAppColor,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   child: Text(
                    //     "NOTE",
                    //     style: TextStyle(
                    //       color: Color(0xff2C2C2C),
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget bannerWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 160,
      child: Swiper(
        // pagination: SwiperPagination(
        //   margin: EdgeInsets.only(top: 10, bottom: 10),
        //   builder: DotSwiperPaginationBuilder(
        //     activeColor: AppColor.mainAppColor,
        //     color: Colors.grey.shade100,
        //   ),
        // ),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Image.asset(
              "assets/images/home/home_banner.png",
              fit: BoxFit.cover,
            ),
          );
        },
        // itemCount: controller.bannerContentList.length,
        // itemBuilder: (BuildContext context, int index) {
        //   return bannerItem(controller.bannerContentList[index]);
        // },
      ),
    );
  }

  Widget bannerItem(BannerContent bannerContent) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bannerContent.title,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  bannerContent.subTitle,
                  style: TextStyle(color: Color(0xff8e8e8e)),
                ),
                SizedBox(height: 10),
                Wrap(
                  children: List.generate(bannerContent.keyList.length, (
                    index,
                  ) {
                    return Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(
                        bannerContent.keyList[index],
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Container(width: 100, height: 100, color: Colors.blue),
        ],
      ),
    );
  }

  Widget sceneTypeWidget() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.star, color: AppColor.mainAppColor),
            SizedBox(width: 10),
            Text(
              "嘿，听听这个".tr,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        GridView.count(
          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 0,
          crossAxisSpacing: 15,
          childAspectRatio: 0.82,
          children: List.generate(controller.sceneTypeList.length, (index) {
            return sceneTypeItem(controller.sceneTypeList[index], index);
          }),
        ),
      ],
    ).marginSymmetric(horizontal: 10);
  }

  Widget sceneTypeItem(SceneType sceneType, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        controller.onTapSceneType(sceneType, index);
      },
      child: Column(
        children: [
          Stack(
            children: [
              Obx(
                () =>
                    (controller.selectSceneTypeIndex.value == index &&
                        controller.playerState.value == PlayerState.playing)
                    ? Center(
                        child: Image.asset(
                          "assets/images/home/onTap.gif",
                          width: Get.width / 6,
                        ),
                      )
                    : SizedBox(),
              ),
              Center(
                child: Image.asset(sceneType.iconPath, width: Get.width / 6),
              ),
            ],
          ),
          SizedBox(height: 2),
          Text(
            sceneType.title.tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  //拍摄和照片选择按钮
  Widget pickerAndShoot() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              controller.selectVideo(ImageSource.camera, MotionType.tennis);
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.sub4AppColor,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.camera_alt, size: 30),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "拍摄视频".tr,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.video_camera_front_rounded),
                        SizedBox(width: 5),
                        Text("开始记录".tr),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: InkWell(
            onTap: () {
              controller.selectVideo(ImageSource.gallery, MotionType.tennis);
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.sub5AppColor,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.photo),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "上传视频".tr,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0xfff8fafc),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.video_camera_front_rounded),
                        SizedBox(width: 5),
                        Text("分析旧视频".tr),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 10);
  }
}
