import 'package:get/get.dart';

import 'home/logic.dart';
import 'logic.dart';
import 'me/logic.dart';
class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MainLogic());
    Get.lazyPut(() => MeLogic());
    Get.lazyPut(() => HomeLogic());
  }

}