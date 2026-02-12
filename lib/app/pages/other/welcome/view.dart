import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../common/Widget/loading_widget.dart';
import 'logic.dart';

class WelcomePage extends GetView<WelcomeLogic> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(color: Colors.white),
      child: Obx(
        () => controller.isOpenApp.value
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(height: 10),
                  //  CircularProgressIndicator(),
                  LoadingWidget(),
                  Text(
                    controller.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              )
            : videoWidget(),
      ),
    );
  }

  Widget videoWidget() {
    return Center(
      child: Obx(
        () => controller.isInitVideo.value
            ?
           SizedBox(
             width: Get.width,
             height: Get.height,
             child:  FittedBox(
               fit: BoxFit.cover,
               child: SizedBox(
                 width: controller.videoPlayerController.value.size.width,
                 height: controller.videoPlayerController.value.size.height,
                 child:  VideoPlayer(controller.videoPlayerController),
               ),
             ),
           )
            : Center(child: LoadingWidget()),
      ),
    );
  }
}
