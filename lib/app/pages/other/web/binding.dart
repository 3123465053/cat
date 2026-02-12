
import 'package:get/get.dart';

import 'logic.dart';

class WebBinding extends Bindings{
  @override
  void dependencies() {
  Get.lazyPut(()=>WebLogic());
  }

}