import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import '../../../common/Widget/app_tips_widget.dart';
import '../../../common/Widget/bottom_sheet.dart';
import '../../../common/constant/constant.dart';
import '../../../common/enum/MotionType.dart';
import '../../../routes/app_pages.dart';

class HomeLogic extends GetxController {
  String text = "开始视频分析".tr;
  List<SceneType> sceneTypeList = [
    SceneType(
      "assets/images/home/Meow_Engine.png",
      "喵力引擎",
      "audio/MeowEngine.MP3",
    ),
    SceneType(
      "assets/images/home/Cuddle_Skill.png",
      "撒娇技能",
      "audio/CuddleSkill.MP3",
    ),
    SceneType(
      "assets/images/home/Anger_99.png",
      "怒气值+99",
      "audio/Anger+99.MP3",
    ),
    SceneType(
      "assets/images/home/Happiness_MAX.png",
      "快乐值 MAX",
      "audio/HappinessMAX.MP3",
    ),
    SceneType(
      "assets/images/home/Food_Request.png",
      "供粮请求",
      "audio/FoodRequest.MP3",
    ),
    SceneType("assets/images/home/Pet_Me.png", "快来摸我", "audio/PetMe.MP3"),
  ];

  List<BannerContent> bannerContentList = [
    BannerContent("今日场景推荐".tr, "根据你的训练习惯，优先展示最合适的练习场景。".tr, [
      "在家挥拍".tr,
      "双人对打".tr,
    ], ""),
    BannerContent("亲子陪练推荐".tr, "轻松互动训练，培养兴趣与节奏感。".tr, [
      "亲子陪练".tr,
      "轻松入门".tr,
    ], ""),
    BannerContent("个人训练计划".tr, "专注提升挥拍稳定性与节奏。".tr, ["个人训练".tr, "节奏强化".tr], ""),
  ];

  //选择场景类型
  RxInt selectSceneTypeIndex = 0.obs;

  final AudioPlayer audioPlayer = AudioPlayer();

  Rx<PlayerState> playerState = PlayerState.stopped.obs;

  @override
  void onInit() {
    addListenPlayer();
    super.onInit();
  }

  addListenPlayer() async{
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        print('正在播放');
        playerState.value=PlayerState.playing;
      } else if (state == PlayerState.paused) {
        playerState.value=PlayerState.paused;
        print('暂停');
      } else if (state == PlayerState.stopped) {
        playerState.value=PlayerState.stopped;
        print('停止');
      }
    });
  }

  onTapSceneType(SceneType sceneType, int index) async {
    if(index==selectSceneTypeIndex.value&&playerState.value==PlayerState.playing){
      await audioPlayer.stop();
      return;
    }
    selectSceneTypeIndex.value = index;
    await audioPlayer.play(AssetSource(sceneType.audioPath));
  }

  selectVideo(ImageSource source, MotionType motionType) async {
    audioPlayer.stop();
    if(!(Constant.userInfo.value.vipExpires??false)){
      Get.toNamed(AppRoutes.VIP);
      return;
    }

    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickVideo(
      source: source,
      maxDuration: Duration(seconds: 60),
    );
    if (xFile == null) {
      return;
    }

    print("视频路径");
    print(xFile?.path);

    if (Platform.isAndroid || Platform.isIOS) {
      final info = await VideoCompress.getMediaInfo(xFile.path);
      if ((info.duration ?? 0) / 1000 > 60) {
        AppTipsWidget.showToast("时长超过1分钟，请裁剪到一分钟以内".tr);
        Get.toNamed(AppRoutes.VIDEO_CROP, arguments: {"videoPath": xFile.path});
        return;
      }
    }

    Get.toNamed(
      AppRoutes.ANYLYSIS_RES,
      arguments: {"videoPath": xFile.path, "type": motionType},
    );
  }

  onTap(MotionType motionType) {
    bottomSheet(
      title: "你将从哪里获取视频".tr,
      leftBtnText: "相册".tr,
      leftIcon: Icon(Icons.photo, color: Colors.green),
      rightBtnText: "相机".tr,
      rightIcon: Icon(Icons.camera_alt, color: Colors.blue),
      onTapLeft: () {
        selectVideo(ImageSource.gallery, motionType);
      },
      onTapRight: () {
        selectVideo(ImageSource.camera, motionType);
      },
    );
  }

  @override
  void onClose() {
    try {
      audioPlayer.stop();
    } catch (e) {}
    super.onClose();
  }
}

//场景类
class SceneType {
  String iconPath;
  String title;
  String audioPath;

  SceneType(this.iconPath, this.title, this.audioPath);
}

class BannerContent {
  String title;
  String subTitle;
  List keyList;
  String imgPath;

  BannerContent(this.title, this.subTitle, this.keyList, this.imgPath);
}
