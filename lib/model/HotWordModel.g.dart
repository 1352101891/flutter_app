// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HotWordModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotWordModel _$HotWordModelFromJson(Map<String, dynamic> json) {
  return HotWordModel(json['id'] as int, json['link'] as String,
      json['name'] as String, json['order'] as int, json['visible'] as int);
}

Map<String, dynamic> _$HotWordModelToJson(HotWordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'link': instance.link,
      'name': instance.name,
      'order': instance.order,
      'visible': instance.visible
    };
