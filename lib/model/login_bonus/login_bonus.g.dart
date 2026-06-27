// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_bonus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogInBonus _$LogInBonusFromJson(Map<String, dynamic> json) => LogInBonus(
      DailyLogIn.fromJson(json['daily_login'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LogInBonusToJson(LogInBonus instance) =>
    <String, dynamic>{
      'daily_login': instance.dailyLogin,
    };

DailyLogIn _$DailyLogInFromJson(Map<String, dynamic> json) => DailyLogIn(
      json['give_bonus'] as bool,
      json['point'] as int?,
    );

Map<String, dynamic> _$DailyLogInToJson(DailyLogIn instance) =>
    <String, dynamic>{
      'give_bonus': instance.giveBonus,
      'point': instance.point,
    };
