import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebLogic extends GetxController {
  InAppWebViewController? webViewController;

  String url = "";
  RxDouble progressValue = 0.0.obs;
  String title = "";

  //是否需要cookie
  bool isNeeCookie = false;

  @override
  void onInit() async {
    super.onInit();
    url = Get.arguments ?? "";
    addListen();
  }

  @override
  void onClose() {
    if (webViewController != null) {
      webViewController!.dispose();
    }
  }

  addListen() {
    ever(progressValue, (callback) {
      print("sfsff");
      print(progressValue.value);
      if (progressValue.value == 1.0) {
        Future.delayed(Duration(milliseconds: 1000))
            .then((value) => {Get.back()});
      }
    });
  }

  getCookie(WebUri? url) async {
    // final cookies = await CookieManager.instance().getCookies(
    //   url: url!,
    // );
    // List<Map<String, dynamic>> formattedCookies = cookies.map((cookie) {
    //   return {
    //     "domain": cookie.domain,
    //     "expirationDate": cookie.expiresDate,
    //     "hostOnly": !(cookie.domain?.startsWith('.') ?? false),
    //     "httpOnly": cookie.isHttpOnly,
    //     "name": cookie.name,
    //     "path": cookie.path,
    //     "sameSite":
    //         (cookie.sameSite?.toString().split('.').last.toLowerCase() ??
    //             "unspecified"),
    //     "secure": cookie.isSecure,
    //     "session": cookie.expiresDate == null,
    //     "storeId": "0",
    //     "value": cookie.value,
    //   };
    // }).toList();
    // // 过滤掉没有 name/value 的项（可选）
    // formattedCookies = formattedCookies
    //     .where((c) => c["name"] != null && c["value"] != null)
    //     .toList();
    // cookie.value = jsonEncode(formattedCookies).toString();
  }

  //输入回调
  inputCallback(String input) {}
}
