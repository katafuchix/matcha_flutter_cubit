// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Relation _$RelationFromJson(Map<String, dynamic> json) => Relation(
      json['outcomming_relation'] as bool,
      json['incomming_relation'] as bool,
      json['outcomming_block'] as bool,
      json['incomming_block'] as bool,
      json['outcomming_favorite'] as bool,
      json['incomming_favorite'] as bool,
    );

Map<String, dynamic> _$RelationToJson(Relation instance) => <String, dynamic>{
      'outcomming_relation': instance.outcommingRelation,
      'incomming_relation': instance.incommingRelation,
      'outcomming_block': instance.outcommingBlock,
      'incomming_block': instance.incommingBlock,
      'outcomming_favorite': instance.outcommingFavorite,
      'incomming_favorite': instance.incommingFavorite,
    };
