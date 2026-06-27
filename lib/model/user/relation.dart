import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'relation.g.dart';

@JsonSerializable()
class Relation extends IModel {
  @JsonKey(name: 'outcomming_relation')
  bool outcommingRelation;
  @JsonKey(name: 'incomming_relation')
  bool incommingRelation;
  @JsonKey(name: 'outcomming_block')
  bool outcommingBlock;
  @JsonKey(name: 'incomming_block')
  bool incommingBlock;
  @JsonKey(name: 'outcomming_favorite')
  bool outcommingFavorite;
  @JsonKey(name: 'incomming_favorite')
  bool incommingFavorite;

  Relation(
      this.outcommingRelation,
      this.incommingRelation,
      this.outcommingBlock,
      this.incommingBlock,
      this.outcommingFavorite,
      this.incommingFavorite);

  factory Relation.fromJson(Map<String, dynamic> json) {
    return _$RelationFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RelationToJson(this);

  @override
  String toString() => jsonEncode(this);
}
