import 'package:get/get.dart';


class VideoPreviewLogic extends GetxController{

  String url = "";
  bool isLocalVideo=true;
  @override
  void onInit() {
    url = Get.arguments?["url"]??"";
    isLocalVideo = Get.arguments?["isLocalVideo"]??true;
    super.onInit();
  }

}