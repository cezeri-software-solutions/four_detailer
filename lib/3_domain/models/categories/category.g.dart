// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      branchId: json['branch_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      position: (json['position'] as num).toInt(),
      isDeleted: json['is_deleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'branch_id': instance.branchId,
      'title': instance.title,
      'description': instance.description,
      'position': instance.position,
      'is_deleted': instance.isDeleted,
    };
