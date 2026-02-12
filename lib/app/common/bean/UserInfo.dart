import 'dart:convert';
/// id : 1902560871428303032
/// nickname : "Noel"
/// headUrl : "https://vediocnd.corpring.com/ai_avatar_url16.png"
/// email : ""
/// gender : null
/// birthday : null
/// vipExpiresTimeMillis : null
/// isVipSharedFromCouple : false
/// couple : null
/// homeAddress : null
/// workAddress : null

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));
String userInfoToJson(UserInfo data) => json.encode(data.toJson());
class UserInfo {
  UserInfo({
      num? id, 
      String? nickname, 
      String? headUrl, 
      String? email, 
      dynamic gender, 
      dynamic birthday, 
      dynamic vipExpiresTimeMillis, 
      bool? isVipSharedFromCouple, 
      dynamic couple, 
      dynamic homeAddress, 
      dynamic workAddress,
      String? appAccountToken,
     bool ? vipExpires
  }){
    _id = id;
    _nickname = nickname;
    _headUrl = headUrl;
    _email = email;
    _gender = gender;
    _birthday = birthday;
    _vipExpiresTimeMillis = vipExpiresTimeMillis;
    _isVipSharedFromCouple = isVipSharedFromCouple;
    _couple = couple;
    _homeAddress = homeAddress;
    _workAddress = workAddress;
    _appAccountToken = appAccountToken;
    _vipExpires=vipExpires;
}

  UserInfo.fromJson(dynamic json) {
    _id = json['id'].runtimeType==String?int.tryParse(json['id']):json['id'];
    _nickname = json['nickname'];
    _headUrl = json['headUrl'];
    _email = json['email'];
    _gender = json['gender'];
    _birthday = json['birthday'];
    _vipExpiresTimeMillis = json['vipExpiresTimeMillis'];
    _isVipSharedFromCouple = json['isVipSharedFromCouple'];
    _couple = json['couple'];
    _homeAddress = json['homeAddress'];
    _workAddress = json['workAddress'];
    _appAccountToken= json["appAccountToken"];
    _vipExpires=json["vipExpires"];
  }
  num? _id;
  String? _nickname;
  String? _headUrl;
  String? _email;
  dynamic _gender;
  dynamic _birthday;
  dynamic _vipExpiresTimeMillis;
  bool? _isVipSharedFromCouple;
  dynamic _couple;
  dynamic _homeAddress;
  dynamic _workAddress;
  String? _appAccountToken;
  bool? _vipExpires;
UserInfo copyWith({  num? id,
  String? nickname,
  String? headUrl,
  String? email,
  dynamic gender,
  dynamic birthday,
  dynamic vipExpiresTimeMillis,
  bool? isVipSharedFromCouple,
  dynamic couple,
  dynamic homeAddress,
  dynamic workAddress,
  String? appAccountToken,
  bool? vipExpires
}) => UserInfo(  id: id ?? _id,
  nickname: nickname ?? _nickname,
  headUrl: headUrl ?? _headUrl,
  email: email ?? _email,
  gender: gender ?? _gender,
  birthday: birthday ?? _birthday,
  vipExpiresTimeMillis: vipExpiresTimeMillis ?? _vipExpiresTimeMillis,
  isVipSharedFromCouple: isVipSharedFromCouple ?? _isVipSharedFromCouple,
  couple: couple ?? _couple,
  homeAddress: homeAddress ?? _homeAddress,
  workAddress: workAddress ?? _workAddress,
  appAccountToken: appAccountToken??_appAccountToken,
  vipExpires: vipExpires??_vipExpires
);
  num? get id => _id;
  String? get nickname => _nickname;
  String? get headUrl => _headUrl;
  String? get email => _email;
  dynamic get gender => _gender;
  dynamic get birthday => _birthday;
  dynamic get vipExpiresTimeMillis => _vipExpiresTimeMillis;
  bool? get isVipSharedFromCouple => _isVipSharedFromCouple;
  dynamic get couple => _couple;
  dynamic get homeAddress => _homeAddress;
  dynamic get workAddress => _workAddress;
  String? get appAccountToken => _appAccountToken;
  bool? get vipExpires =>_vipExpires;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['nickname'] = _nickname;
    map['headUrl'] = _headUrl;
    map['email'] = _email;
    map['gender'] = _gender;
    map['birthday'] = _birthday;
    map['vipExpiresTimeMillis'] = _vipExpiresTimeMillis;
    map['isVipSharedFromCouple'] = _isVipSharedFromCouple;
    map['couple'] = _couple;
    map['homeAddress'] = _homeAddress;
    map['workAddress'] = _workAddress;
    map["appAccountToken"]= _appAccountToken;
    map["vipExpires"]=_vipExpires;
    return map;
  }

}