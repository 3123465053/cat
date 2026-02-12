import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/constant/constant.dart';
import '../../common/enum/MotionType.dart';
import '../../routes/app_pages.dart';
import 'home/logic.dart';
import 'me/logic.dart';

class MainLogic extends GetxController {
  RxInt selectTabIndex = 0.obs;

  changeTab(int index) {
    if (index == 1) {
      return;
    }
    if (index > 1) {
      selectTabIndex.value = 2;
      stopAudio();
      Get.find<MeLogic>().getHistory();
    } else {
      selectTabIndex.value = index;
    }
  }

  onTapShoot() {
    try {
      stopAudio();
      if (!(Constant.userInfo.value.vipExpires ?? false)) {
        Get.toNamed(AppRoutes.VIP);
        return;
      }

      Get.find<HomeLogic>().selectVideo(ImageSource.camera, MotionType.tennis);
    } catch (e) {}
  }

  stopAudio() {
    try {
      if (Get.previousRoute == "/main"||Get.currentRoute=="/main") {
        Get.find<HomeLogic>().audioPlayer.stop();
      }
    } catch (e) {}
  }
}
