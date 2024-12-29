// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_contamination_level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryContaminationLevel _$CategoryContaminationLevelFromJson(
        Map<String, dynamic> json) =>
    CategoryContaminationLevel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      position: (json['position'] as num).toInt(),
      isDeleted: json['is_deleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CategoryContaminationLevelToJson(
        CategoryContaminationLevel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'name': instance.name,
      'position': instance.position,
      'is_deleted': instance.isDeleted,
    };
