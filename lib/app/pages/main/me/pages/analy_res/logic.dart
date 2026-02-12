import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:screenshot/screenshot.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../../common/Widget/app_tips_widget.dart';
import '../../../../../common/constant/sp_key.dart';
import '../../../../../common/enum/MotionType.dart';
import '../../../../../common/network/api/api.dart';
import '../../../../../common/utils/common.dart';
import '../../../../../common/utils/sp_utils.dart';
import '../../../../../routes/app_pages.dart';
import 'package:share_plus/share_plus.dart';

class AnalysisResLogic extends GetxController {
  //视频封面
  Rx<Uint8List?> videoCoverUint8List = Rx<Uint8List?>(null);
  String videoPath = "";

  RxString resStr = "".obs;
  RxBool loading = true.obs;
  MotionType motionType = MotionType.tennis;
  RxDouble progress = 0.0.obs;
  Timer? timer;
  ScreenshotController screenshotController = ScreenshotController();
  FlutterTts flutterTts = FlutterTts();
  RxBool isPlaying= false.obs;

  @override
  void onInit() {
    videoPath = Get.arguments?["videoPath"] ?? "";
    motionType = Get.arguments?["type"] ?? MotionType.tennis;
    resStr.value=Get.arguments?["resStr"]??"";
    getVideoThumbnail();
    analyse();
    startProgress();
    super.onInit();
  }

  //开始显示进度条(40秒)
  startProgress() {
    timer = Timer.periodic(Duration(milliseconds: 400), (time) {
      double temp = progress.value + 1;
      if (temp <= 99) {
        progress.value = temp;
      } else {
        time.cancel();
      }
    });
  }

  getVideoThumbnail() async {
    if (videoPath.isEmpty) {
      return;
    }
    videoCoverUint8List.value = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 1080,
      quality: 85,
    );
  }

  toPreviewVideo() {
    Get.toNamed(AppRoutes.VIDEO_PREVIEW, arguments: {"url": videoPath,"isLocalVideo":!videoPath.contains("http")});
  }

  //分析
  analyse() async {
    try {
      if(resStr.value.isNotEmpty){
        loading.value = false;
        return;
      }
      if (videoPath.isEmpty) {
        loading.value = false;
        return;
      }
      print("dsafdd");
      print(motionType);
      Dio dio = Dio();
      String? token=SpUtils.getString(SpKey.token);
      dio.options.headers['couple-token'] = token;

      final formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(videoPath),
        "type": getMotionTypeStr(motionType),
      });
      print("Fsfdsdssss");
      print(getMotionTypeStr(motionType));
      dio.options.contentType = "multipart/form-data";
      var res = await dio.post(AnalyseApi.AnalyseMotion, data: formData);
      loading.value = false;
      if (res.data["code"] == 200 && res.data["data"] != null) {
        resStr.value = res.data["data"]["content"];
      } else {
        AppTipsWidget.showToast("生成出错".tr+"${res.data["message"]}".tr);
      }
    } catch (e) {
      AppTipsWidget.showToast("生成出错".tr+"$e");
      print("出错:$e");
      loading.value = false;
    }
  }

  getMotionTypeStr(MotionType motionType) {

    switch (motionType) {
      case MotionType.tennis:
        return  "cat_en";
      case MotionType.running:
        return "running";
    }
  }

  share() async {
    try {
      EasyLoading.show(status: "loading...");
      //先截屏
      Uint8List? image = await screenshotController.capture();

      if (image == null || image.isEmpty) {
        AppTipsWidget.showToast("分享数据准备失败，请再次尝试".tr);
        return;
      }
      File imageFile = await CommonUtils.writeImageToTemp(image);
      final params = ShareParams(
        text: 'iSwingCoach',
        files: [XFile(imageFile.path)],
      );

      final result = await SharePlus.instance.share(params);
      EasyLoading.dismiss();
      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing the picture!');
      }
    } catch (e) {
      EasyLoading.dismiss();
      AppTipsWidget.showToast("分享出错，请稍后再试".tr+"${e}");
    }
  }

  speak() async {
    try {
      var result = await flutterTts.speak(resStr.value);
      print("dasdddd");
      print(result);
    } catch (e) {
      print("dsafddfd$e");
    }
  }

  speakOrPauseSpeak() async {
    try {
      if(resStr.isEmpty){
        return;
      }
      if(!isPlaying.value){
        var  result = await flutterTts.speak(resStr.value);
       if(result==1){
         isPlaying.value=true;
       }
      }else {
        var result = await flutterTts.pause();
        if(result==1){
          isPlaying.value=false;
        }
      }
    } catch (e) {
      print("dsafddfd$e");
    }
  }

  @override
  void onClose() {
 try{
   if (timer != null) {
     timer!.cancel();
   }
 flutterTts.pause();
 }catch(e){}

    super.onClose();
  }
}
