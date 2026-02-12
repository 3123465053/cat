import 'package:get/get.dart';

import '../bean/UserInfo.dart';

class Constant{
  static Rx<UserInfo> userInfo= UserInfo().obs;

  //app 包名。只是app里面用到的地方，修改项目的包名不是在这里
  static String appBundleID= "com.heyu.catAnalysisPay";
}