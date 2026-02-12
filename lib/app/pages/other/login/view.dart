import 'package:flutter/material.dart';
import 'dart:ui'; // 导入ui包以使用ImageFilter
import 'package:get/get.dart';
import 'logic.dart';
class LoginPage extends GetView<LoginLogic> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
      body: Stack(
        children: [
          // 英雄部分：背景图片和渐变叠加层
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 背景图片
                Image.asset(
                  'assets/images/login_bg.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.blue.shade900,
                  ),
                ),
                // 渐变叠加层
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                // 英雄内容
                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 应用Logo - 带高斯模糊效果
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 应用名称
                        Text(
                          "Meow Translator".tr,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 4,
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 应用标语
                        // Text(
                        //   "只需一拍，".tr,
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w500,
                        //     color: Colors.white,
                        //     shadows: [
                        //       Shadow(
                        //         offset: Offset(0, 1),
                        //         blurRadius: 2,
                        //         color: Color.fromRGBO(0, 0, 0, 0.3),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 登录部分
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: Get.height* 0.40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "欢迎使用".tr+"Meow Translator",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.loginType==0?"绑定Apple ID来保存你的购买记录，在其他设备也能恢复".tr:"通过Apple ID登录，安全便捷地使用所有功能".tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Apple 登录按钮
                  ElevatedButton.icon(
                    onPressed: () => controller.signInWithApple(),
                    icon: const Icon(Icons.apple, color: Colors.white, size: 24),
                    label:  Text(
                      controller.loginType==0?"绑定Apple ID".tr: "通过 Apple 登录".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // 用户协议文本
                  Obx(
                        () => Row(
                      children: [
                        Checkbox(
                          value: controller.hasAgreedToTerms.value,
                          onChanged: (_) => controller.toggleAgreement(),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              children: [
                                TextSpan(text: controller.loginType==0?"绑定即表示您同意我们的".tr:"登录即表示您同意我们的".tr),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: (){controller.toPrivacy(type: 1);},
                                    child: Text(
                                      '用户协议'.tr,
                                      style: TextStyle(color: Color(0xFF3B82F6)),
                                    ),
                                  ),
                                ),
                                TextSpan(text: '和'.tr),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: (){controller.toPrivacy(type: 2);},
                                    child: Text(
                                      '隐私政策'.tr,
                                      style: TextStyle(color: Color(0xFF3B82F6)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // 稍后再说
                  // GestureDetector(
                  //   onTap: controller.skipLogin,
                  //   child: Text(
                  //     controller.loginType==0?"稍后再说，先体验一下".tr:"稍后再说，先体验一下(游客身份)".tr,
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       color: Colors.grey.shade600,
                  //       decoration: TextDecoration.underline,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

         controller.showClose.value ? closeWidget() : Positioned(
             top: 0,
             child: SizedBox()),

        ],
      ),
    ));
  }


  closeWidget() {
    return Positioned(
        top: 50,
        right: 20,
        child: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                border: Border.all(color: Colors.grey.shade400, width: 1.5)),
            child: Icon(Icons.close, color: Colors.grey.shade400, size: 20),
          ),
        ));
  }

}


