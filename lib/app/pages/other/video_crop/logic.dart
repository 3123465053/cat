import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:video_editor/video_editor.dart';

import '../../../common/Widget/app_tips_widget.dart';
import '../../../common/enum/MotionType.dart';
import '../../../common/utils/ExportService.dart';
import '../../../routes/app_pages.dart';

class VideoCropLogic extends GetxController{

late VideoEditorController videoEditorController;
 RxBool isInit=false.obs;
   String path="";

   @override
  void onInit() {
     path=Get.arguments["videoPath"]??"";
    loadVideo();
    super.onInit();
  }

  loadVideo()async{
     print("fdsdddd");
     print(path);
    videoEditorController=VideoEditorController.file(
        maxDuration: Duration(seconds: 60),
        minDuration: Duration(seconds: 0),
        File(path))..initialize().then((value){
      isInit.value=true;
      videoEditorController.addListener((){
        update(["trimDuration"]);
      });
    });
  }

 exportTrimmedVideo() async {
  final config = VideoFFmpegVideoEditorConfig(videoEditorController);

  EasyLoading.show(status: "导出中...");
  await ExportService.runFFmpegCommand(
    await config.getExecuteConfig(),
    onProgress: (stats) {
      print("progress:${config.getFFmpegProgress(stats.getTime())}");
    },
    onError: (e, s) {
      EasyLoading.dismiss();
      AppTipsWidget.showToast("导出出错$e");
    },
    onCompleted: (file) {
      EasyLoading.dismiss();
      print("导出结果");
      Get.offAndToNamed(
        AppRoutes.ANYLYSIS_RES,
        arguments: {"videoPath": file.path, "type": MotionType.tennis},
      );
    },
  );
}


/// 自动根据时长显示：
/// < 1 小时  -> mm:ss
/// >= 1 小时 -> hh:mm:ss
String formatDurationAuto(
    Duration d, {
      bool showMilliseconds = false,
    }) {
  if (d.isNegative) d = Duration.zero;

  final totalSeconds = d.inMilliseconds / 1000;

  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);
  final seconds = d.inSeconds.remainder(60);
  final milliseconds = d.inMilliseconds.remainder(1000);

  String two(int n) => n.toString().padLeft(2, '0');

  String secWithMs() {
    final value = seconds + milliseconds / 1000;
    return value.toStringAsFixed(1);
  }


  // < 1 小时 → mm:ss
  if (totalSeconds < 3600) {
    return showMilliseconds
        ? '${two(minutes)}:${secWithMs().padLeft(4, '0')}'
        : '${two(minutes)}:${two(seconds)}';
  }

  // >= 1 小时 → hh:mm:ss
  return showMilliseconds
      ? '$hours:${two(minutes)}:${secWithMs().padLeft(4, '0')}'
      : '$hours:${two(minutes)}:${two(seconds)}';
}





}