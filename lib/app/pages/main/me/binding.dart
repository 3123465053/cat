
import 'package:get/get.dart';

import 'logic.dart';

class MeBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => MeLogic());
  }
}
