
import 'package:get/get.dart';

import 'logic.dart';

class AnalysisResBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>AnalysisResLogic());
  }
  
}