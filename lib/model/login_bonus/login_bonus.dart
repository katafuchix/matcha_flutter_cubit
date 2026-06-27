import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'login_bonus.g.dart';

@JsonSerializable()
class LogInBonus extends IModel {
  @JsonKey(name: 'daily_login')
  DailyLogIn dailyLogin;

  LogInBonus(this.dailyLogin);

  factory LogInBonus.fromJson(Map<String, dynamic> json) =>
      _$LogInBonusFromJson(json);

  Map<String, dynamic> toJson() => _$LogInBonusToJson(this);

  @override
  String toString() => jsonEncode(this);
}

@JsonSerializable()
class DailyLogIn extends IModel {
  @JsonKey(name: 'give_bonus')
  bool giveBonus;
  @JsonKey(name: 'point')
  int? point;

  DailyLogIn(this.giveBonus, this.point);

  factory DailyLogIn.fromJson(Map<String, dynamic> json) =>
      _$DailyLogInFromJson(json);

  Map<String, dynamic> toJson() => _$DailyLogInToJson(this);

  @override
  String toString() => jsonEncode(this);
}
