import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_editor/video_editor.dart';
import '../../../common/config/app_color.dart';
import 'logic.dart';

//视频裁剪界面
class VideoCropPage extends GetView<VideoCropLogic> {
  const VideoCropPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //禁止侧滑返回
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            topBarWidget(),
            SizedBox(height: 15),
            Expanded(child: previewWidget()),
            SizedBox(height: 15),
            trimSWidget(),
          ],
        ),
      ),
    );
  }

  //顶部功能条组件
  Widget topBarWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_outlined),
        ),
        InkWell(
          onTap: (){
            controller.exportTrimmedVideo();
          },
          child:
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: AppColor.mainAppColor,
            ),
            child: Text("继续".tr,style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        )
      ],
    ).marginSymmetric(horizontal: 10);
  }

  //预览部分
  Widget previewWidget() {
    return Center(
      child: Obx(
        () => controller.isInit.value
            ? AspectRatio(
                aspectRatio:
                    controller.videoEditorController.video.value.aspectRatio,
                child: CropGridViewer.preview(
                  controller: controller.videoEditorController,
                ),
              )
            : CircularProgressIndicator(),
      ),
    ).paddingSymmetric(horizontal: 15);
  }

  //裁剪部分
  Widget trimSWidget() {
    return Obx(
      () => controller.isInit.value
          ? Column(
              children: [
                GetBuilder<VideoCropLogic>(
                  id: "trimDuration",
                  builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${(controller.videoEditorController.endTrim - controller.videoEditorController.startTrim).inSeconds}s",
                        ),
                        Row(
                          children: [
                            Text(
                              controller.formatDurationAuto(
                                controller.videoEditorController.startTrim,
                              ),
                            ),
                            Text(" - "),
                            Text(
                              controller.formatDurationAuto(
                                controller.videoEditorController.endTrim,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).marginSymmetric(horizontal: 10);
                  },
                ),
                SizedBox(height: 10),
                TrimSlider(
                  controller: controller.videoEditorController,
                  child: TrimTimeline(
                    controller: controller.videoEditorController,
                    textStyle: TextStyle(color: Colors.grey),
                    padding: EdgeInsets.only(top: 5),
                  ),
                ),
              ],
            )
          : CircularProgressIndicator(),
    ).paddingSymmetric(horizontal: 15);
  }
}
