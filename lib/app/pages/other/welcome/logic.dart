import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../../../common/bean/UserInfo.dart';
import '../../../common/constant/constant.dart';
import '../../../common/constant/sp_key.dart';
import '../../../common/network/request/app_common_api.dart';
import '../../../common/utils/sp_utils.dart';
import '../../../routes/app_pages.dart';

class WelcomeLogic extends GetxController {
  String title = "";
  StreamSubscription<ConnectivityResult>? subscription;
  bool _hasShownDialog = false; // 标记是否已显示过弹窗
  bool _hasJumped = false; // 标记是否已经跳转过
  late VideoPlayerController videoPlayerController;

  //视频是否播放完成
  RxBool videoComplete = false.obs;

  //是否打开过app
  RxBool isOpenApp = true.obs;
  RxBool isInitVideo = false.obs;

  @override
  void onInit() {
    initVideo();
    // 立即开始监听网络变化
    _startNetworkListener();

    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      checkNetworkAndJump();
    });

    super.onInit();
  }

  @override
  void onClose() {
    subscription?.cancel();
    try{
      videoPlayerController.pause();
      videoPlayerController.dispose();
    }
    catch(e){}
    super.onClose();
  }

  //初始化视频
  initVideo() {
    //暂时不要开屏视频
    videoComplete.value=true;
    return;
   isOpenApp.value = SpUtils.getBool(SpKey.openApp) ?? false;
    //isOpenApp.value=false;
    if (isOpenApp.value) {
      videoComplete.value = true;
    } else {

      SpUtils.setBool(SpKey.openApp, true);
      videoPlayerController = VideoPlayerController.asset("assets/open_app.mp4")
        ..initialize().then((value) {
          isInitVideo.value=true;
          videoPlayerController.play();
        });
      videoPlayerController.addListener((){
        final value = videoPlayerController.value;
        if(value.position.inSeconds>=value.duration.inSeconds&&value.duration.inSeconds!=0){
          videoComplete.value=true;
        }
      });
    }
  }

  // 开始监听网络状态变化
  void _startNetworkListener() {
    subscription?.cancel();

    subscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) async {
      if (result != ConnectivityResult.none && !_hasJumped) {
        // 如果有弹窗显示，先关闭弹窗
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        // 等待一下确保网络稳定
        await Future.delayed(Duration(milliseconds: 500));

        // 验证网络连通性
        bool networkWorks = await _testNetworkConnectivity();
        if (networkWorks && !_hasJumped) {
          jumpTo();
        }
      }
    });
  }

  // 检测网络连接并跳转
  checkNetworkAndJump() async {
    if (_hasJumped) return; // 如果已经跳转过，直接返回

    final connectivityResult = await (Connectivity().checkConnectivity());

    // 如果有网络连接，先尝试跳转
    if (connectivityResult != ConnectivityResult.none) {
      // 进行简单的网络验证
      bool networkWorks = await _testNetworkConnectivity();
      if (networkWorks && !_hasJumped) {
        jumpTo();
        return;
      }
    }

    // 只有在确实没有网络时才显示弹窗
    if (!_hasJumped) {
      _showNoNetworkDialog();
    }
  }

  // 简单的网络连通性测试
  Future<bool> _testNetworkConnectivity() async {
    try {
      // 尝试连接一个简单的地址
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      // 如果Google不可用，尝试百度
      try {
        final result = await InternetAddress.lookup(
          'baidu.com',
        ).timeout(Duration(seconds: 3));
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (e) {
        // 如果DNS解析都失败，假设网络可用（避免误判）
        return true;
      }
    }
  }

  // 显示无网络连接的iOS风格弹窗
  void _showNoNetworkDialog() {
    if (Get.isDialogOpen == true || _hasShownDialog || _hasJumped) return;

    _hasShownDialog = true;

    Get.dialog(
      CupertinoAlertDialog(
        title: Text(
          '网络连接不可用'.tr,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            '请检查您的网络连接，或前往设置页面开启网络连接'.tr,
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              '取消'.tr,
              style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 17),
            ),
            onPressed: () {
              Get.back();
              _hasShownDialog = false; // 重置标记
              //checkNetworkAndJump();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              '前往设置'.tr,
              style: TextStyle(
                color: CupertinoColors.systemBlue,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              Get.back();
              _hasShownDialog = false; // 重置标记
              _openSettings();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    ).then((_) {
      // 弹窗关闭时重置标记
      _hasShownDialog = false;
    });
  }

  // 打开系统设置
  void _openSettings() async {
    try {
      openAppSettings();
    } catch (e) {
      print('打开设置失败: $e');
    }
    // 不需要重新开始监听，因为已经在onInit中开始了
  }

  //跳转逻辑
  jumpTo() async {
    if (_hasJumped) return; // 防止重复调用

    _hasJumped = true; // 标记已经跳转
    subscription?.cancel(); // 取消网络监听

    bool isLogoutOrDelete = SpUtils.getBool(SpKey.isLogoutOrDelete)??false;
    if(isLogoutOrDelete){
      Get.offAllNamed(AppRoutes.LOGIN,arguments: {"loginType": 1});
      return;
    }

    //没有登录就去登录
    var token = SpUtils.getString(SpKey.token);
    if (token == null || token.isEmpty) {
      //游客登录
      await AppCommonApi.guestLogin();
    }

    //从本地加载用户数据
    var userInfo = SpUtils.getString(SpKey.userInfo);
    if (userInfo != null && userInfo.isNotEmpty) {
      Constant.userInfo.value = UserInfo.fromJson(jsonDecode(userInfo));
    }
    if (videoComplete.value) {
      toMainOrVip();
    } else {
      ever(videoComplete, (value) {
        toMainOrVip();
      });
    }
  }

  toMainOrVip() {
    if (Constant.userInfo.value.vipExpires ?? false) {
      Get.offAllNamed(AppRoutes.MAIN);
    } else {
      Get.offAllNamed(AppRoutes.VIP,arguments: {"backTo":AppRoutes.MAIN});
    }
  }
}
