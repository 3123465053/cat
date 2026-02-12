import 'package:get/get.dart';

import 'logic.dart';


class VideoCropBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>VideoCropLogic());
  }

}