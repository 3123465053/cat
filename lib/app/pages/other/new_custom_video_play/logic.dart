import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class NewCustomVideoPlayLogic extends GetxController {
  VideoPlayerController? videoController;
  RxBool isVideoLoading = true.obs;
  RxBool autoPlay = true.obs;

  //当前是否在播放
  RxBool isPlaying = false.obs;
  String videoUrl = "";
  String tag = "";
  bool isLocal = false;
  RxBool isInit = false.obs;

  @override
  void onInit() {
    addListen();
    super.onInit();
  }

  //监听播放
  addListen() {
    ever(autoPlay, (value) {
      if (autoPlay.value && !isPlaying.value) {
        if (videoController != null) {
          videoController!.play();
          isPlaying.value = true;
        }
      }

      if (!autoPlay.value && videoController != null) {
        videoController!.pause();
        isPlaying.value = false;
      }
    });
  }

  initVideo() async {
    try {
      if (videoController == null) {
        print("初始化视频");
        if (isLocal) {
          videoController = VideoPlayerController.file(
            File(videoUrl),
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: false, // 避免与其他音频混合
              allowBackgroundPlayback: false, // 禁止后台播放
            ),
          );
        } else {
          videoController = VideoPlayerController.networkUrl(
            Uri.parse(videoUrl),
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: false, // 避免与其他音频混合
              allowBackgroundPlayback: false, // 禁止后台播放
            ),
          );
        }
        await videoController!.initialize();
        isVideoLoading.value = false;

        print("时长:${videoController!.value.duration.inSeconds}");
        isInit.value = true;
        videoController!.setLooping(true);
        if (autoPlay.value) {
          print("播放");
          videoController!.play();
          isPlaying.value = true;
        }
      }
    } catch (e) {
      print("视频播放出错:$e");
    }
  }

  //重新加载当前视频
  reloadVideo() async {
    isVideoLoading.value = true;
    isPlaying.value = false;
    await initVideo();
  }

  //重新初始化视频
  reInitVideo(String url) {
    try {
      videoUrl = url;
      isInit.value = false;
      videoController!.pause();
      isVideoLoading.value = true;
      isPlaying.value = false;
      videoController = null;
      initVideo();
    } catch (e) {}
  }

  playOrPause() async {
    if (videoController == null) {
      return;
    }
    try {
      // 执行播放/暂停操作
      if (!isPlaying.value) {
        await videoController!.play();
        isPlaying.value = true;
      } else {
        await videoController!.pause();
        isPlaying.value = false;
      }
    } catch (e) {
      print('播放控制错误: $e');
    }
  }

  // @override
  // void onClose() {
  //   try {
  //     if (videoController != null) {
  //       videoController!.dispose();
  //       videoController=null;
  //      // Get.delete<NewCustomVideoPlayLogic>(tag: tag);
  //       print("销毁视频播放器");
  //     }
  //   } catch (e) {
  //     print("销毁视频播放器失败${e}");
  //   }
  //   super.onClose();
  // }

  disposeVideoController() {
    try {
      if (videoController != null) {
        videoController!.dispose();
        videoController = null;
        print("销毁视频播放器");
      }
    } catch (e) {
      print("销毁视频播放器失败${e}");
    }
  }
}
