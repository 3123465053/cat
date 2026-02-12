import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'app/common/i18n/i18n.dart';
import 'app/common/utils/app_untls.dart';
import 'app/common/utils/sp_utils.dart';
import 'app/routes/app_pages.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //顶部状态栏透明
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  await SpUtils.init();
  await AppUtils.flutterTTSInit();
  configLoading();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var locale= Get.deviceLocale; //当前设备语言;
  // var locale=Locale("en","US");
    return GetMaterialApp(
      // 你的翻译
      locale: locale,
      translations: MyAppTranslations(),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.Pages,   //所有页面列表
      initialRoute: AppRoutes.WELCOME,
      navigatorObservers: [routeObserver],
      // 添加一个回调语言选项，以备上面指定的语言翻译不存在
      localizationsDelegates: const [
        //此处
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // // 添加支持中文的本地化代理
        // GlobalCupertinoLocalizations.delegate,
      ],
      builder: EasyLoading.init(builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      }),
      // defaultTransition: Transition.rightToLeftWithFade,
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
  //..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.black
    ..backgroundColor =Colors.grey.shade200
    ..indicatorColor =Color(0xff000000)
    ..textColor = Color(0xff000000)
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale;
}