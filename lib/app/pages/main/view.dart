import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../common/config/app_color.dart';
import '../../common/network/request/app_common_api.dart';
import 'home/view.dart';
import 'logic.dart';
import 'me/view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>with RouteAware, WidgetsBindingObserver {
  var controller = Get.put(MainLogic());

  @override
  void initState() {
    AppCommonApi.getUserInfo();
    // 注册应用生命周期观察器
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }


  @override
  void dispose() {
    // 页面销毁时释放广告资源
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    AppCommonApi.getUserInfo();
  }

  @override
  void didPushNext() {
    print("didPushNextfdsafdd${Get.previousRoute}");
    controller.stopAudio();
    super.didPushNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(
            () => IndexedStack(
          index: controller.selectTabIndex.value,
          children: const [HomePage(),SizedBox(), MePage()],
        ),
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          backgroundColor: Colors.white,
          onTap: (index) {
            controller.changeTab(index);
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.selectTabIndex.value,
          selectedItemColor: AppColor.mainAppColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页".tr),
            BottomNavigationBarItem(icon: Text(""), label: "拍摄分析".tr),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的".tr),
          ],
        ),
      ),

      floatingActionButton: InkWell(
        onTap: (){
          controller.onTapShoot();
        },
        child: Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.mainAppColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.subAppColor,
                offset: Offset(0, 3),
                blurRadius: 10,
              ),
            ],
          ),
          child: Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              color: AppColor.mainAppColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white,width: 3),

            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
