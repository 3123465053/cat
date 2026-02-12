import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math';
import '../../../common/Widget/app_tips_widget.dart';
import '../../../common/bean/UserInfo.dart';
import '../../../common/constant/constant.dart';
import '../../../common/constant/sp_key.dart';
import '../../../common/network/api/api.dart';
import '../../../common/network/request/app_common_api.dart';
import '../../../common/network/request/app_request.dart';
import '../../../common/utils/secure_storage.dart';
import '../../../common/utils/sp_utils.dart';
import '../../../routes/app_pages.dart';

class LoginLogic extends GetxController {

  //登录类型 0表示绑定 1表示通过Apple登录
  int loginType=0;
  // 是否同意用户协议和隐私政策
  final hasAgreedToTerms = false.obs;

  @override
  void onInit() {
    loginType=Get.arguments?['loginType']??0;
    super.onInit();
  }

  // 切换同意状态
  void toggleAgreement() {
    hasAgreedToTerms.value = !hasAgreedToTerms.value;
  }
  
  // 跳过登录，直接进入应用
  void skipLogin() async{

    try{
      //是登录的话就掉游客登录
      if(loginType==1){
        var token=SpUtils.getString(SpKey.token);
        if(token==null||token.isEmpty){
          EasyLoading.show(status: "loading...");
          await AppCommonApi.guestLogin();

          EasyLoading.dismiss();
        }else{
          Get.offAllNamed(AppRoutes.MAIN);
        }
      }else{
        //绑定就导航到主页或其他页面
        Get.offAllNamed(AppRoutes.MAIN);
      }
    }catch(e){
      EasyLoading.dismiss();
    }
  }

  // Apple登录方法
  Future<void> signInWithApple() async {
    // 检查是否同意协议
    if (!hasAgreedToTerms.value) {
      AppTipsWidget.showToast('请先阅读并同意用户协议和隐私政策');
      return;
    }

    try {
      EasyLoading.show(status: "正在登录...");
      
      // 检查平台是否支持苹果登录
      if (!Platform.isIOS && !Platform.isMacOS) {
        AppTipsWidget.showToast('当前平台不支持苹果登录');
        EasyLoading.dismiss();
        return;
      }
      
      // 检查设备是否支持苹果登录
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        AppTipsWidget.showToast('您的设备不支持苹果登录，请使用其他方式登录');
        EasyLoading.dismiss();
        return;
      }
      
      // 执行苹果登录 - 添加更多选项和错误处理
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // 添加nonce参数以增加安全性
        nonce: _generateNonce(),
        // 在iOS和macOS上不需要配置webAuthenticationOptions
      );
      
      // 获取用户信息
      String? appleIdToken = credential.identityToken;
      String? appleUserID = credential.userIdentifier;
      String? email = credential.email;
      String userName = '${credential.familyName ?? ''} ${credential.givenName ?? ''}'.trim();
      
      print('苹果登录信息：');
      print('userID: $appleUserID');
      print('email: $email');
      print('userName: $userName');
      print('identityToken长度: ${appleIdToken?.length ?? 0}');

      var data = {
        "oauthType": "apple",
        "nickname": userName,
        //苹果登录 无法获取头像 填个默认的
        "headUrl": "https://vediocnd.corpring.com/ai_avatar_url16.png",
        "email": credential.email ?? "",
        "appAccountToken": credential.userIdentifier ?? '',
        "createdDevice": Platform.isAndroid ? 1 : 2
      };
        SpUtils.setBool(SpKey.isLogoutOrDelete, false);
      loginType == 0 ? bind(data) : login(data);
    } catch (error) {
      print('苹果登录错误详情: $error');
      // 登录失败处理
      String errorMessage = '苹果登录失败';
      
      if (error is SignInWithAppleAuthorizationException) {
        switch (error.code) {
          case AuthorizationErrorCode.canceled:
            errorMessage = '您已取消登录';
            break;
          case AuthorizationErrorCode.failed:
            errorMessage = '登录失败，请重试';
            break;
          case AuthorizationErrorCode.invalidResponse:
            errorMessage = '服务器响应无效，请重试';
            break;
          case AuthorizationErrorCode.notHandled:
            errorMessage = '登录请求未处理，请重试';
            break;
          case AuthorizationErrorCode.unknown:
            // 特殊处理error 1000错误
            if (error.message.contains('error 1000')) {
              errorMessage = '苹果认证服务暂不可用，请稍后再试或使用其他登录方式';
              
              // 尝试使用替代方案处理1000错误
              // 如果是在模拟器上测试，提示用户在真机上测试
              if (Platform.isIOS) {
                errorMessage = '苹果登录无法在模拟器上完成，请在真机上测试';
              }
            } else {
              errorMessage = '未知错误，请重试';
            }
            break;
          default:
            errorMessage = '苹果登录出错: ${error.message}';
        }
      }
      
      _handleSignInError(errorMessage);
      EasyLoading.dismiss();
    }
  }
  
  // 生成随机nonce用于苹果登录安全验证
  String _generateNonce() {
    final Random random = Random.secure();
    final List<int> values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values).replaceAll(RegExp(r'[^\w]'), '');
  }


  //登录自己的服务器
  login(Map<String, dynamic> data) async {
    //写死
    data["appId"] = Constant.appBundleID;
    EasyLoading.show(status: "loading...");
    try {
      var res = await AppRequest.instance.post(UserApi.ThreeLogin, data: data);
      EasyLoading.dismiss();
      if (res['code'] == 200) {
        //接口没返回appAccountToken 所以自己添加
        if (res['data']['userInfo']['appAccountToken'] == null) {
          res['data']['userInfo']['appAccountToken'] = data['appAccountToken'];
        }
        print(res);
        Constant.userInfo.value = UserInfo.fromJson(res['data']["userInfo"]);
        await SpUtils.setString(SpKey.token, res['data']["token"]);
        await SpUtils.setString(SpKey.userInfo, jsonEncode(Constant.userInfo));
        await SecureStorage.setSecureDeviceId(
            deviceId: data["appAccountToken"]);

        //有号码就直接进入主页面
        AppTipsWidget.showToast("登录成功".tr);
        Get.offAllNamed(AppRoutes.MAIN);
      } else {

        AppTipsWidget.showToast(res['message'] ?? "登录出错".tr);
      }
    } catch (e) {

      EasyLoading.dismiss();
      print("login err:" + e.toString());
      AppTipsWidget.showToast("登录出错".tr);
    }
  }

  //绑定
  bind(Map<String, dynamic> data) async {
    print("daaaa");
    print(data);
    //写死
    data["appId"] = Constant.appBundleID;
    EasyLoading.show(status: "loading...");
    try {
      var res = await AppRequest.instance.post(UserApi.bindApple, data: data);
      print("asfgudasf");
      print(res);
      EasyLoading.dismiss();
      if (res['code'] == 200) {
        //接口没返回appAccountToken 所以自己添加
        if (res['data']['userInfo']['appAccountToken'] == null) {
          res['data']['userInfo']['appAccountToken'] = data['appAccountToken'];
        }
        print(res);
        Constant.userInfo.value = UserInfo.fromJson(res['data']["userInfo"]);
        await SpUtils.setString(SpKey.userInfo, jsonEncode(Constant.userInfo));
        await SecureStorage.setSecureDeviceId(
            deviceId: data["appAccountToken"]);
        AppTipsWidget.showToast("绑定成功".tr);
        Get.offAllNamed(AppRoutes.MAIN);
      } else {
        AppTipsWidget.showToast(res['message'] ?? "绑定出错".tr);
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("login err:" + e.toString());
      AppTipsWidget.showToast("绑定出错".tr);
    }
  }

  // 登录错误处理
  void _handleSignInError(dynamic error) {
  //  AppDialogWidget.showToast('登录失败，请稍后重试: ${error.toString()}');
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
    }
  }
}