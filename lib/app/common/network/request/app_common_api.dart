//一些app公用的Api接口
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import '../../Widget/app_tips_widget.dart';
import '../../bean/UserInfo.dart';
import '../../constant/constant.dart';
import '../../constant/sp_key.dart';
import '../../utils/common.dart';
import '../../utils/secure_storage.dart';
import '../../utils/sp_utils.dart';
import '../api/api.dart';
import 'app_request.dart';

class AppCommonApi {

  ///游客登录
  static guestLogin() async {
    try {
      var data = {
        "oauthType": "apple",
        //苹果登录 无法获取头像 填个默认的
        "headUrl": "https://vediocnd.corpring.com/ai_avatar_url16.png",
        "createdDevice": Platform.isAndroid ? 1 : 2,
        "appId": Constant.appBundleID,
        "nickname":CommonUtils.ranndomName()
      };
      var id = await SecureStorage.getSecureDeviceId();
      data["appAccountToken"] = id;
      print("saigfff");
      print(data);
      var res = await AppRequest.instance.post(UserApi.ThreeLogin, data: data);
      print("asfgudasf");
      print(res);
      if (res['code'] == 200) {
        Constant.userInfo.value = UserInfo.fromJson(res['data']["userInfo"]);
        await SpUtils.setString(SpKey.token, res['data']["token"]);
        await SpUtils.setString(SpKey.userInfo, jsonEncode(Constant.userInfo));
       //  Get.offAllNamed(AppRoutes.MAIN);
      } else {
        AppTipsWidget.showToast('游客登录失败，请稍后重试'.tr);
      }
    } catch (e) {
      print("sfddd${e}");
      AppTipsWidget.showToast("游客登录失败，请稍后重试".tr+':${e.toString()}');
    }
  }


  ///获取用户信息
  static Future getUserInfo() async {
    try {
      //没有登录就不去获取用户信息
      var token = SpUtils.getString(SpKey.token);
      if (token == null || token.isEmpty) {
        return;
      }

      var res = await AppRequest.instance.get(UserApi.GetUserInfo);
      print("esdssss");
      print(res);
      if (res['code'] == 200) {
        Constant.userInfo.value = UserInfo.fromJson(res['data']['userInfo']);
        await SpUtils.setString(SpKey.userInfo, jsonEncode(Constant.userInfo));
        if (res['data']["token"] != null) {
          await SpUtils.setString(SpKey.token, res['data']["token"]);
        }
      }
    } catch (e) {
      print("dsafdfds$e");
      AppTipsWidget.showToast("获取用户信息失败".tr);
    }
  }
}
