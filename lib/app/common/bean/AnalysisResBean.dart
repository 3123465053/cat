import 'dart:convert';
/// technique_analysis_and_guidance : "球员的正手技术展现了良好的引拍节奏与引拍高度。引拍阶段，球员采用了半开放式站位，转体充分，拍头朝上，为挥拍提供了良好的重力加速空间。然而，在击球瞬间，视频显示出明显的‘刷球过多’现象，即拍面在接触球后过快地向上挥动，导致球的向前撞击力不足，球质偏浅。改进建议：在击球点应增加向前的‘挤压’感，延长球在拍面上的停留感，确保动力从下肢通过核心转体顺畅传递至球拍。随挥阶段应保持动作的完整性，确保手臂向前充分延展后再进行收拍。步法方面，击球后的回位意识良好，但在击球前的微调步仍有优化空间，以确保每次击球都能处于最佳的力学结构位点。常见风险点在于过分强调手腕提拉，长期可能导致手腕或肘部由于受力不均产生劳损。"
/// training_plan_and_exercise_strategy : "建议采用为期5天的针对性强化训练方案。训练频率：每周3-4次，单次时长90分钟。技术训练占比60%，体能与恢复各占20%。第1-2天：重点进行斜面刷球练习与静止球向前撞击练习，旨在拆解‘刷球’与‘撞击’的体感差异，每组30次，共5组。第3-4天：进行多球喂球训练，要求击球点落在底线深区，强制延长随挥轨迹。第5天：加入半场对抗，练习在移动中保持击球的穿透力。预期效果：在保持上旋的基础上，击球深度平均增加1-1.5米，击球稳定性显著提升。体能方面应加强核心稳定性和小腿爆发力练习，以支持更高效的动力链传递。"
/// video_data_statistics_and_quantitative_analysis : "视频共记录挥拍14次，有效击球12次。技术表现量化指标显示：主动进攻性挥拍占比70%，击球成功率为85%。数据反映出球员具备较强的击球欲望和基本的控球能力，但非受迫性失误倾向主要集中在球深度不足导致的对手反击风险。表现良好的指标是引拍动作的标准化程度。偏低的数据项是平均击球深度，由于过早收拍，约60%的击球落点位于发球线附近。数据层面的改进方向：提升击球时的水平运动轨迹比例，将垂直向上分力与水平向前的撞击分力比例调整至4:6，从而通过数据反馈优化击球效能。技术分析与训练规划已完成，旨在通过结构化练习全面提升底线竞技表现。"

AnalysisResBean analysisResBeanFromJson(String str) => AnalysisResBean.fromJson(json.decode(str));
String analysisResBeanToJson(AnalysisResBean data) => json.encode(data.toJson());
class AnalysisResBean {
  AnalysisResBean({
      String? techniqueAnalysisAndGuidance, 
      String? trainingPlanAndExerciseStrategy, 
      String? videoDataStatisticsAndQuantitativeAnalysis,}){
    _techniqueAnalysisAndGuidance = techniqueAnalysisAndGuidance;
    _trainingPlanAndExerciseStrategy = trainingPlanAndExerciseStrategy;
    _videoDataStatisticsAndQuantitativeAnalysis = videoDataStatisticsAndQuantitativeAnalysis;
}

  AnalysisResBean.fromJson(dynamic json) {
    _techniqueAnalysisAndGuidance = json['technique_analysis_and_guidance'];
    _trainingPlanAndExerciseStrategy = json['training_plan_and_exercise_strategy'];
    _videoDataStatisticsAndQuantitativeAnalysis = json['video_data_statistics_and_quantitative_analysis'];
  }
  String? _techniqueAnalysisAndGuidance;
  String? _trainingPlanAndExerciseStrategy;
  String? _videoDataStatisticsAndQuantitativeAnalysis;
AnalysisResBean copyWith({  String? techniqueAnalysisAndGuidance,
  String? trainingPlanAndExerciseStrategy,
  String? videoDataStatisticsAndQuantitativeAnalysis,
}) => AnalysisResBean(  techniqueAnalysisAndGuidance: techniqueAnalysisAndGuidance ?? _techniqueAnalysisAndGuidance,
  trainingPlanAndExerciseStrategy: trainingPlanAndExerciseStrategy ?? _trainingPlanAndExerciseStrategy,
  videoDataStatisticsAndQuantitativeAnalysis: videoDataStatisticsAndQuantitativeAnalysis ?? _videoDataStatisticsAndQuantitativeAnalysis,
);
  String? get techniqueAnalysisAndGuidance => _techniqueAnalysisAndGuidance;
  String? get trainingPlanAndExerciseStrategy => _trainingPlanAndExerciseStrategy;
  String? get videoDataStatisticsAndQuantitativeAnalysis => _videoDataStatisticsAndQuantitativeAnalysis;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['technique_analysis_and_guidance'] = _techniqueAnalysisAndGuidance;
    map['training_plan_and_exercise_strategy'] = _trainingPlanAndExerciseStrategy;
    map['video_data_statistics_and_quantitative_analysis'] = _videoDataStatisticsAndQuantitativeAnalysis;
    return map;
  }

}