import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'intro_controller.dart';

class IntroView extends GetView<IntroController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (int page) {
          controller.changePage(page);
        },
        children: <Widget>[
          _buildPageContent(
            image: 'assets/image1.png',
            title: '欢迎使用',
            body: '这是一个介绍页面。',
          ),
          _buildPageContent(
            image: 'assets/image2.png',
            title: '功能介绍',
            body: '这里是功能介绍。',
          ),
          _buildPageContent(
            image: 'assets/image3.png',
            title: '开始使用',
            body: '点击按钮开始使用应用。',
            isLastPage: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent({required String image, required String title, required String body, bool isLastPage = false}) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(image),
          SizedBox(height: 20.0),
          Text(
            title,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          Text(
            body,
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          if (isLastPage)
            ElevatedButton(
              onPressed: () async {
                // 使用 GetX 进行导航
                Get.offNamed('/home');
              },
              child: Text('开始'),
            ),
        ],
      ),
    );
  }
} 