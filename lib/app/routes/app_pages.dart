import 'package:get/get.dart';
import '../pages/main/binding.dart';
import '../pages/main/me/pages/analy_res/binding.dart';
import '../pages/main/me/pages/analy_res/view.dart';
import '../pages/main/me/pages/setting/binding.dart';
import '../pages/main/me/pages/setting/view.dart';
import '../pages/main/view.dart';
import '../pages/other/intro/intro_binding.dart';
import '../pages/other/intro/intro_view.dart';
import '../pages/other/login/binding.dart';
import '../pages/other/login/view.dart';
import '../pages/other/video_crop/binding.dart';
import '../pages/other/video_crop/view.dart';
import '../pages/other/video_preview/binding.dart';
import '../pages/other/video_preview/view.dart';
import '../pages/other/vip/binding.dart';
import '../pages/other/vip/view.dart';
import '../pages/other/web/binding.dart';
import '../pages/other/web/view.dart';
import '../pages/other/welcome/binding.dart';
import '../pages/other/welcome/view.dart';
part 'app_routes.dart';


class AppPages {
  static final Pages = [
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),

    GetPage(name: AppRoutes.WEB, page: () => WebPage(), binding: WebBinding()),

    GetPage(
      name: AppRoutes.ANYLYSIS_RES,
      page: () => AnalysisResPage(),
      binding: AnalysisResBinding(),
    ),

    GetPage(
      name: AppRoutes.VIDEO_PREVIEW,
      page: () => VideoPreviewPage(),
      binding: VideoPreviewBinding(),
    ),

    GetPage(
      name: AppRoutes.WELCOME,
      page: () => WelcomePage(),
      binding: WelcomeBinding(),
    ),

    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.VIDEO_CROP,
      page: () => VideoCropPage(),
      binding: VideoCropBinding(),
    ),

    GetPage(
      name: AppRoutes.SETTING,
      page: () => SettingPage(),
      binding: SettingBinding(),
    ),

    GetPage(
      name: AppRoutes.VIP,
      page: () => VipPage(),
      binding: VipBinding(),
    ),

    GetPage(
      name: AppRoutes.INTO,
      page: () => IntroView(),
      binding: IntroBinding(),
    ),
  ];
}
