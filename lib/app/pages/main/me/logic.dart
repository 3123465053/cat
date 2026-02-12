import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../common/Widget/app_tips_widget.dart';
import '../../../common/bean/HistoryBean.dart';
import '../../../common/bean/UserInfo.dart';
import '../../../common/constant/constant.dart';
import '../../../common/constant/sp_key.dart';
import '../../../common/network/api/api.dart';
import '../../../common/network/request/app_request.dart';
import '../../../common/utils/sp_utils.dart';
import '../../../routes/app_pages.dart';

class MeLogic extends GetxController {
  EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  List<MotionTypeData> motionTypeList = [
    MotionTypeData(Icons.sports_golf_outlined, "高尔夫".tr),
    MotionTypeData(Icons.run_circle_outlined, "跑步".tr),
    MotionTypeData(Icons.sports_baseball_rounded, "匹克球".tr),
  ];

  List<DataAnalysis> dataAnalysis = [
    DataAnalysis(128, "分析次数".tr),
    DataAnalysis(33, "本周运动".tr),
    DataAnalysis(7, "连续天数".tr),
  ];

  RxBool showMoreMotion = false.obs;
  var pageNumber = 1;
  var pageSize = 20;

  ///是否是最后一页
  RxBool lastPage = false.obs;
  RxBool loading = true.obs;

  //历史记录
  RxList<HistoryBean> historyList = <HistoryBean>[].obs;

  @override
  void onInit() {
    getHistory();
    super.onInit();
  }

  toDetail(HistoryBean historyBean) {
    Get.toNamed(AppRoutes.ANYLYSIS_RES,arguments: {"resStr":historyBean.resultContent?.content??"结果","videoPath":historyBean.videoUrl});
  }

  toVipPage() {
    if ((Constant.userInfo.value.vipExpires ?? false)) {
      return;
    }
    Get.toNamed(AppRoutes.VIP);
  }

  onLoad() async {
    pageNumber += 1;
    await getHistory();
    refreshController.finishLoad(
      lastPage.value ? IndicatorResult.noMore : IndicatorResult.success,
    );
  }

  onRefresh() async {
    pageNumber = 1;
    lastPage.value = false;
    await getHistory();
    refreshController.finishRefresh();
    refreshController.resetFooter();
  }

  getHistory() async {
    try {
      var res = await AppRequest.instance.get(
        AnalyseApi.getHistory,
        parameters: {"pageNum": pageNumber, "pageSize": pageSize},
      );
      loading.value = false;
      print("dsasdsss");
      print(res);
      if (res["code"] == 200 && res["data"].isNotEmpty) {
        if (res["data"]["records"].isNotEmpty) {
          if (pageNumber == 1) {
            historyList.clear();
          }
          res["data"]["records"].forEach((e) {
             historyList.add(HistoryBean.fromJson(e));
          });
        } else {
          lastPage.value = true;
        }
      }
    } catch (e) {
      AppTipsWidget.showToast("获取历史记录出错${e}");
      print("dsafd$e");
    }
  }
}

class MotionTypeData {
  IconData iconData;
  String name;

  MotionTypeData(this.iconData, this.name);
}

class DataAnalysis {
  int count;
  String desc;

  DataAnalysis(this.count, this.desc);
}
