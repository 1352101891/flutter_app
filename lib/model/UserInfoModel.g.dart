// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfoModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) {
  return UserInfoModel(
      json['admin'] as bool,
      json['email'] as String,
      json['icon'] as String,
      json['id'] as int,
      json['nickname'] as String,
      json['password'] as String,
      json['token'] as String,
      json['type'] as int,
      json['username'] as String);
}

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'admin': instance.admin,
      'email': instance.email,
      'icon': instance.icon,
      'id': instance.id,
      'nickname': instance.nickname,
      'password': instance.password,
      'token': instance.token,
      'type': instance.type,
      'username': instance.username
    };
