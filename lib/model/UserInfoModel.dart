//"admin": false,
//"chapterTops": [
//
//],
//"collectIds": [
//
//],
//"email": "",
//"icon": "",
//"id": 26904,
//"nickname": "lq1111113",
//"password": "",
//"token": "",
//"type": 0,
//"username": "lq1111113"

import 'package:json_annotation/json_annotation.dart';
part 'UserInfoModel.g.dart';
///这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()
class UserInfoModel{
  bool admin;
  String email;
  String icon;
  int id;
  String nickname;
  String password;
  String token;
  int type;
  String username;


  UserInfoModel(this.admin, this.email, this.icon, this.id, this.nickname,
      this.password, this.token, this.type, this.username);

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}