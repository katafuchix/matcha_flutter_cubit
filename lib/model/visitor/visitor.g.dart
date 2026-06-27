// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Visitor _$VisitorFromJson(Map<String, dynamic> json) => Visitor(
      json['visit_date'] as String,
      (json['profiles'] as List<dynamic>)
          .map((e) => ProfileResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VisitorToJson(Visitor instance) => <String, dynamic>{
      'visit_date': instance.visitDate,
      'profiles': instance.profiles,
    };
