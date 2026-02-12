import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/Widget/app_tips_widget.dart';
import '../../../../../common/bean/UserInfo.dart';
import '../../../../../common/constant/constant.dart';
import '../../../../../common/constant/sp_key.dart';
import '../../../../../common/network/api/api.dart';
import '../../../../../common/network/request/app_request.dart';
import '../../../../../common/utils/secure_storage.dart';
import '../../../../../common/utils/sp_utils.dart';
import '../../../../../routes/app_pages.dart';

class SettingLogic extends GetxController{

  // 点击登录/注册按钮
  void login(int type) {
    Get.toNamed(AppRoutes.LOGIN, arguments: {"loginType": type,"showClose":true});
    // 这里实现跳转到登录页面的逻辑
    print('点击了登录/注册按钮');
  }

  //用户协议和隐私政策
  toPrivacy({required int type}) async {
    final Uri _url;
    if (type == 1) {
      _url = Uri.parse(UserApi.agreement);
      if (!await launchUrl(_url)) {
        throw 'Could not launch $_url';
      }
    } else if (type == 2) {
      _url = Uri.parse(UserApi.privacy);
      if (!await launchUrl(_url)) {
        throw 'Could not launch $_url';
      }
    }else if (type == 3) {
      _url = Uri.parse(UserApi.official);
      if (!await launchUrl(_url)) {
        throw 'Could not launch $_url';
      }
    }
  }
  //删除账户
  deleteAccount() async {
    try {
      EasyLoading.show(status: "loading...");
      var res = await AppRequest.instance.post(UserApi.DeleteAccount);
      EasyLoading.dismiss();
      if (res['code'] == 200) {
        await SpUtils.clear();
        await SpUtils.remove(SpKey.userInfo);
        await SpUtils.remove(SpKey.token);
       // await SecureStorage.clean();
        Constant.userInfo.value = UserInfo();
        SpUtils.setBool(SpKey.isLogoutOrDelete, true);
        AppTipsWidget.showToast("注销账号成功".tr);
        Get.back();
        Get.offAllNamed(AppRoutes.LOGIN, arguments: {"loginType":1});
      } else {
        AppTipsWidget.showToast("账号注销失败".tr);
      }
    } catch (e) {
      EasyLoading.dismiss();
      AppTipsWidget.showToast("账号注销失败".tr);
    }
  }

  //退出登录
  logout() async {
    try {
      EasyLoading.show(status: "loading...");

      await SpUtils.remove(SpKey.userInfo);
      await SpUtils.remove(SpKey.token);
      Constant.userInfo.value = UserInfo();
      SpUtils.setBool(SpKey.isLogoutOrDelete, true);
      EasyLoading.dismiss();
      AppTipsWidget.showToast("已退出登录");
      Get.offAllNamed(AppRoutes.LOGIN, arguments: {"loginType":1,});
    } catch (e) {
      EasyLoading.dismiss();
      AppTipsWidget.showToast('退出登录出错 $e,请稍后再试');
    }
  }
}