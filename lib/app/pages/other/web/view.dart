
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'logic.dart';

class WebPage extends GetView<WebLogic> {
  WebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(
            controller.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => controller.progressValue.value != 1.0
                ? Obx(() => LinearProgressIndicator(
                      value: controller.progressValue.value,
                    ))
                : Container()),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(controller.url)),
                onWebViewCreated: (webController) {
                  controller.webViewController = webController;
                  print("safdfdd");
                  // webController.addJavaScriptHandler(
                  //   handlerName: 'inputChanged',
                  //   callback: (args) {
                  //    print("输入内容: ${args.first}");
                  //     controller.inputCallback(args.first);
                  //   },
                  // );
                },
                onProgressChanged: (webController, progress) {
                  controller.progressValue.value = progress / 100;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  //阻止非http打开（有些或重定向到app内）
                  final uri = navigationAction.request.url!;
                  if (!["http", "https"].contains(uri.scheme)) {
                    print("Blocked unknown scheme: ${uri.scheme}");
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },

                onLoadStop: (webController, url) async {
                  controller.getCookie(url);

                  // 注入 JS：实时监听所有 input 元素
                //   await webController.evaluateJavascript(source: """
                //   (function() {
                //     document.querySelectorAll('input').forEach(function(input) {
                //       input.addEventListener('input', function() {
                //         window.flutter_inappwebview.callHandler('inputChanged', input.value);
                //       });
                //     });
                //   })();
                // """);
                },

              ),
            )
          ],
        ),
      ),

    );
  }

}
