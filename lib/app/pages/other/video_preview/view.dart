import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../new_custom_video_play/view.dart';
import 'logic.dart';


class VideoPreviewPage extends GetView<VideoPreviewLogic> {
  const VideoPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: NewCustomVideoPlay(
              url: controller.url,
              tag: 'video_preview',
              isLocal: controller.isLocalVideo,
              autoPlay: true,
              videoFill: false,
              showLoading: true,
            ),
          ),
          closeWidget()
        ],
      ),
    );
  }
  
  Widget closeWidget(){
    return Positioned(
        top: 80,
        left: 20,
        child: InkWell(
          onTap: (){
            Get.back();
          },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle
        ),
        child: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,),
      ),
    ));
  }
}
