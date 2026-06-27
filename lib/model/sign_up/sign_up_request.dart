import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../IModel.dart';
import '../basic/sex.dart';

part 'sign_up_request.g.dart';

@JsonSerializable()
class SignUpRequest extends IModel {
  @JsonKey(name: 'nickname')
  String nickname;
  @JsonKey(name: 'prof_address_id')
  int profAddressId;
  @JsonKey(name: 'sex')
  Sex sex;
  @JsonKey(name: 'birthday')
  String birthday;
  @JsonKey(name: 'client_identifier')
  String? clientIdentifier;

  SignUpRequest(this.nickname, this.profAddressId, this.sex, this.birthday, this.clientIdentifier);

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  factory SignUpRequest.fromUi(
      String nickname, int profAddressId, Sex sex, DateTime birthday, String? clientIdentifier) {
    initializeDateFormatting("ja_JP");
    var formatter = new DateFormat('yyyy-MM-dd', "ja_JP");
    var formatted = formatter.format(birthday); // DateからString
    return SignUpRequest(nickname, profAddressId, sex, formatted, clientIdentifier);
  }

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);

  @override
  String toString() => jsonEncode(this);
}
