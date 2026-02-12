import 'dart:convert';
/// id : 4
/// createdBy : null
/// createdName : null
/// createdTime : "2026-02-09T10:31:23.287Z"
/// lastModifiedTime : "2026-02-09T10:31:57.200Z"
/// lastModifiedBy : null
/// lastModifiedName : null
/// deleted : false
/// userId : 1902560871428303043
/// videoUrl : "https://aimiaoying-shanghai.oss-accelerate.aliyuncs.commovement/ai/tennis/202602/09/f6062dac-669d-4cb3-b3ea-16b3a76f8e37.mp4"
/// coverUrl : "https://aimiaoying-shanghai.oss-accelerate.aliyuncs.commovement/ai/tennis/202602/09/f6062dac-669d-4cb3-b3ea-16b3a76f8e37.mp4"
/// type : "tennis"
/// resultContent : {"content":"# 网球正手击球技术分析报告\n\n## 一、主要问题分析\n\n### 问题一：击球点位置滞后\n- 时间点：00:03–00:07\n- 视频表现：\n  - 在球员进行对比演示的“错误动作”中，球拍触球瞬间位于身体侧面甚至侧后方。\n  - 手臂动作呈现明显的“推挤”感，肘部距离身体过近。\n- 问题：\n  - 击球点<…>"}

HistoryBean historyBeanFromJson(String str) => HistoryBean.fromJson(json.decode(str));
String historyBeanToJson(HistoryBean data) => json.encode(data.toJson());
class HistoryBean {
  HistoryBean({
      num? id, 
      dynamic createdBy, 
      dynamic createdName, 
      String? createdTime, 
      String? lastModifiedTime, 
      dynamic lastModifiedBy, 
      dynamic lastModifiedName, 
      bool? deleted, 
      num? userId, 
      String? videoUrl, 
      String? coverUrl, 
      String? type, 
      ResultContent? resultContent,}){
    _id = id;
    _createdBy = createdBy;
    _createdName = createdName;
    _createdTime = createdTime;
    _lastModifiedTime = lastModifiedTime;
    _lastModifiedBy = lastModifiedBy;
    _lastModifiedName = lastModifiedName;
    _deleted = deleted;
    _userId = userId;
    _videoUrl = videoUrl;
    _coverUrl = coverUrl;
    _type = type;
    _resultContent = resultContent;
}

  HistoryBean.fromJson(dynamic json) {
    _id = json['id'].runtimeType==String?int.tryParse( json['id']): json['id'];
    _createdBy = json['createdBy'];
     _createdName = json['createdName'];
     _createdTime = json['createdTime'];
    _lastModifiedTime = json['lastModifiedTime'];
     _lastModifiedBy = json['lastModifiedBy'];
     _lastModifiedName = json['lastModifiedName'];
     _deleted = json['deleted'];
     _userId = json['userId'].runtimeType==String?int.tryParse(json['userId']):json['userId'];
    _videoUrl = json['videoUrl'];
     _coverUrl = json['coverUrl'];
    _type = json['type'];
    _resultContent = json['resultContent'] != null ? ResultContent.fromJson(jsonDecode(json['resultContent'])) : null;
  }
  num? _id;
  dynamic _createdBy;
  dynamic _createdName;
  String? _createdTime;
  String? _lastModifiedTime;
  dynamic _lastModifiedBy;
  dynamic _lastModifiedName;
  bool? _deleted;
  num? _userId;
  String? _videoUrl;
  String? _coverUrl;
  String? _type;
  ResultContent? _resultContent;
HistoryBean copyWith({  num? id,
  dynamic createdBy,
  dynamic createdName,
  String? createdTime,
  String? lastModifiedTime,
  dynamic lastModifiedBy,
  dynamic lastModifiedName,
  bool? deleted,
  num? userId,
  String? videoUrl,
  String? coverUrl,
  String? type,
  ResultContent? resultContent,
}) => HistoryBean(  id: id ?? _id,
  createdBy: createdBy ?? _createdBy,
  createdName: createdName ?? _createdName,
  createdTime: createdTime ?? _createdTime,
  lastModifiedTime: lastModifiedTime ?? _lastModifiedTime,
  lastModifiedBy: lastModifiedBy ?? _lastModifiedBy,
  lastModifiedName: lastModifiedName ?? _lastModifiedName,
  deleted: deleted ?? _deleted,
  userId: userId ?? _userId,
  videoUrl: videoUrl ?? _videoUrl,
  coverUrl: coverUrl ?? _coverUrl,
  type: type ?? _type,
  resultContent: resultContent ?? _resultContent,
);
  num? get id => _id;
  dynamic get createdBy => _createdBy;
  dynamic get createdName => _createdName;
  String? get createdTime => _createdTime;
  String? get lastModifiedTime => _lastModifiedTime;
  dynamic get lastModifiedBy => _lastModifiedBy;
  dynamic get lastModifiedName => _lastModifiedName;
  bool? get deleted => _deleted;
  num? get userId => _userId;
  String? get videoUrl => _videoUrl;
  String? get coverUrl => _coverUrl;
  String? get type => _type;
  ResultContent? get resultContent => _resultContent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['createdBy'] = _createdBy;
    map['createdName'] = _createdName;
    map['createdTime'] = _createdTime;
    map['lastModifiedTime'] = _lastModifiedTime;
    map['lastModifiedBy'] = _lastModifiedBy;
    map['lastModifiedName'] = _lastModifiedName;
    map['deleted'] = _deleted;
    map['userId'] = _userId;
    map['videoUrl'] = _videoUrl;
    map['coverUrl'] = _coverUrl;
    map['type'] = _type;
    if (_resultContent != null) {
      map['resultContent'] = _resultContent?.toJson();
    }
    return map;
  }

}

/// content : "# 网球正手击球技术分析报告\n\n## 一、主要问题分析\n\n### 问题一：击球点位置滞后\n- 时间点：00:03–00:07\n- 视频表现：\n  - 在球员进行对比演示的“错误动作”中，球拍触球瞬间位于身体侧面甚至侧后方。\n  - 手臂动作呈现明显的“推挤”感，肘部距离身体过近。\n- 问题：\n  - 击球点<…>"

ResultContent resultContentFromJson(String str) => ResultContent.fromJson(json.decode(str));
String resultContentToJson(ResultContent data) => json.encode(data.toJson());
class ResultContent {
  ResultContent({
      String? content,}){
    _content = content;
}

  ResultContent.fromJson(Map json) {
    _content = json['content'];
  }
  String? _content;
ResultContent copyWith({  String? content,
}) => ResultContent(  content: content ?? _content,
);
  String? get content => _content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = _content;
    return map;
  }

}