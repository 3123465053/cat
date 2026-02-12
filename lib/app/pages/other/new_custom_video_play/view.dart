import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'logic.dart';

class NewCustomVideoPlay extends StatefulWidget {
  NewCustomVideoPlay(
      {super.key,
      required this.url,
      required this.autoPlay,
      required this.tag,
      required this.isLocal,
        Color? bgColor,
      bool? videoFill,
      bool? showLoading,
      }) {
    if (videoFill != null) {
      this.videoFill = videoFill;
    }
    if(bgColor!=null){
      this.bgColor=bgColor;
    }

    if(showLoading!=null){
      this.showLoading=showLoading;
    }

  }

  final String url;
  final bool autoPlay;
  final String tag;
  bool videoFill = true;
  Color bgColor =Colors.black;
 bool showLoading=true;
  //是否是本地视频
  bool isLocal;

  @override
  State<NewCustomVideoPlay> createState() => _NewCustomVideoPlayState();
}

class _NewCustomVideoPlayState extends State<NewCustomVideoPlay> {
  late NewCustomVideoPlayLogic customVideoPlayLogic;

  @override
  void initState() {
    customVideoPlayLogic = Get.put(NewCustomVideoPlayLogic(), tag: widget.tag);
    customVideoPlayLogic.autoPlay.value = widget.autoPlay;
    customVideoPlayLogic.videoUrl = widget.url;
    customVideoPlayLogic.isLocal = widget.isLocal;
    customVideoPlayLogic.tag = widget.tag;
    customVideoPlayLogic.initVideo();
    print("初始化${widget.tag}");
    super.initState();
  }

  @override
  void dispose() {
    try {
      print("销毁${widget.tag}");
      customVideoPlayLogic.disposeVideoController();
      Get.delete<NewCustomVideoPlayLogic>(tag: widget.tag);
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("是否自动播放${widget.autoPlay} ${widget.tag}");
    customVideoPlayLogic.autoPlay.value = widget.autoPlay;
    return Obx(() => Container(
          color: widget.bgColor,
          height: customVideoPlayLogic.isInit.value ? null : Get.height * 0.3,
          child: Obx(() {
            if (customVideoPlayLogic.isVideoLoading.value ||
                customVideoPlayLogic.videoController == null) {
              return Center(
                child: (widget.showLoading??true)? CircularProgressIndicator():SizedBox(),
              );
            }
            return videoPlay();
          }),
        ));
  }

  Widget videoPlay() {
    return InkWell(
      onTap: () {
        customVideoPlayLogic.playOrPause();
      },
      child: Stack(
        children: [
          Center(
            child: widget.videoFill
                ? VideoPlayer(customVideoPlayLogic.videoController!)
                : AspectRatio(
                    aspectRatio:
                        customVideoPlayLogic.videoController!.value.aspectRatio,
                    child: VideoPlayer(customVideoPlayLogic.videoController!),
                  ),
          ),
          Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: buildPlayPauseButton())
        ],
      ),
    );
  }

  // 播放/暂停按钮
  Widget buildPlayPauseButton() {
    return Center(
      child: Obx(() {
        // 如果正在播放或正在加载，不显示按钮
        if (customVideoPlayLogic.isPlaying.value ||
            customVideoPlayLogic.isVideoLoading.value) {
          return SizedBox();
        }
        return Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.all(Radius.circular(100))),
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 30,
          ),
        );
      }),
    );
  }
}
