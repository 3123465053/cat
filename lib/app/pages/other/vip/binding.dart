import 'package:get/get.dart';

import 'logic.dart';


class VipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VipLogic());
  }
}
