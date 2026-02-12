import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:screenshot/screenshot.dart';
import '../../../../../common/config/app_color.dart';
import 'logic.dart';

class AnalysisResPage extends GetView<AnalysisResLogic> {
  const AnalysisResPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: AppColor.pageBackgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            videoCoverImg().paddingSymmetric(horizontal: 20),
            SizedBox(height: 20),
            Obx(
              () => controller.loading.value
                  ? progressWidget()
                  : controller.resStr.isEmpty
                  ? Center(child: Text("暂无分析结果".tr))
                  : markdownWidget(controller.resStr.value),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: (){
          controller.speakOrPauseSpeak();
        },
        child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(Radius.circular(1000)),
        ),
        child: Obx(
              () => Icon(
            controller.isPlaying.value
                ? Icons.pause
                : Icons.play_arrow,
            color: Colors.grey,
          ),
        ),
      ),),
    );
  }

  appBar() {
    return AppBar(
      backgroundColor: AppColor.pageBackgroundColor,
      title: Text(
        "分析结果".tr,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        InkWell(
          onTap: () {
            controller.share();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: AppColor.mainAppColor,
            ),
            child: Text("分享".tr, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget videoCoverImg() {
    return InkWell(
      onTap: () {
        controller.toPreviewVideo();
      },
      child: Container(
        width: Get.width,
        height: (Get.width - 40) * (9 / 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Center(
              child: Obx(
                () => controller.videoCoverUint8List.value == null
                    ? CircularProgressIndicator()
                    : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Image.memory(
                          controller.videoCoverUint8List.value!,
                        ),
                      ),
              ),
            ),

            Obx(
              () => controller.videoCoverUint8List.value != null
                  ? Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  //进度界面
  Widget progressWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("分析中...".tr+"${controller.progress}%"),
          SizedBox(height: 10),
          SizedBox(
            width: Get.width / 2,
            child: Obx(
              () => LinearProgressIndicator(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.blue,
                minHeight: 6,
                value: controller.progress.value / 100,
              ),
            ),
          ),
        ],
      ),
    ).marginSymmetric(vertical: 100);
  }

  // Widget resWidget() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       resItemWidget(
  //         title: "问题分析",
  //         des:
  //             controller
  //                 .analysisResBean
  //                 .value
  //                 ?.videoDataStatisticsAndQuantitativeAnalysis ??
  //             "暂无结果",
  //       ),
  //       SizedBox(height: 15),
  //       resItemWidget(
  //         title: "动作技术分析指导",
  //         des:
  //             controller.analysisResBean.value?.techniqueAnalysisAndGuidance ??
  //             "暂无结果",
  //       ),
  //       SizedBox(height: 15),
  //       resItemWidget(
  //         title: "提升计划",
  //         des:
  //             controller
  //                 .analysisResBean
  //                 .value
  //                 ?.trainingPlanAndExerciseStrategy ??
  //             "暂无结果",
  //       ),
  //     ],
  //   );
  // }

  Widget resItemWidget({required String title, required String des}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ).marginSymmetric(horizontal: 20),
        SizedBox(height: 5),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(5, 5),
                blurRadius: 10,
              ),
            ],
          ),
          //child: Text(des, style: TextStyle(color: Colors.black87)),
          child: SizedBox(
            // height: 100,
            child: Markdown(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // controller: controller,
              selectable: true,
              data: des,
              extensionSet: md.ExtensionSet(
                md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                <md.InlineSyntax>[
                  md.EmojiSyntax(),
                  ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  markdownWidget(String des) {
    return Screenshot(
      child: Markdown(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // controller: controller,
        selectable: true,
        data: des,
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          <md.InlineSyntax>[
            md.EmojiSyntax(),
            ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
          ],
        ),
      ),
      controller: controller.screenshotController,
    );
  }

  test() {
    return Container(
      width: Get.width,
      height: 200,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 0,
          sections: [
            PieChartSectionData(
              color: Colors.red,
              value: 40,
              title: '40%',
              radius: 60,
            ),
            PieChartSectionData(
              color: Colors.blue,
              value: 30,
              title: '30%',
              radius: 60,
            ),
            PieChartSectionData(value: 30, title: '30%', radius: 60),
          ],
        ),
      ),
    );
  }

  test1() {
    return SizedBox(
      width: Get.width,
      height: 200,
      child: BarChart(
        BarChartData(
          // 不显示背景虚线
          gridData: FlGridData(
            drawHorizontalLine: true,
            drawVerticalLine: false,
          ),
          // 不显示边框
          borderData: FlBorderData(
            show: true,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 5,
                  width: 20,
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 3,
                  width: 20,
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 7,
                  width: 20,
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('Day ${value.toInt()}');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  test2() {
    return SizedBox(
      width: Get.width,
      height: 200,
      child: LineChart(
        LineChartData(
          // 不显示背景虚线
          gridData: FlGridData(
            drawHorizontalLine: true,
            drawVerticalLine: false,
          ),
          // 不显示边框
          borderData: FlBorderData(
            show: true,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 3),
                FlSpot(2, 2),
                FlSpot(3, 5),
                FlSpot(4, 3),
              ],
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  test3() {
    return SizedBox(
      width: Get.width,
      height: 100,
      child: Markdown(
        // controller: controller,
        selectable: true,
        data: 'Insert emoji :smiley: here',
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          <md.InlineSyntax>[
            md.EmojiSyntax(),
            ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
          ],
        ),
      ),
    );
  }
}
