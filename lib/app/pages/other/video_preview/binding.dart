import 'package:get/get.dart';

import 'logic.dart';


class VideoPreviewBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>VideoPreviewLogic());
  }

}