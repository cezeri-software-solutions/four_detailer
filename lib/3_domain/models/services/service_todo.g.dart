// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTodo _$ServiceTodoFromJson(Map<String, dynamic> json) => ServiceTodo(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      position: (json['position'] as num).toInt(),
      isDeleted: json['is_deleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ServiceTodoToJson(ServiceTodo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'name': instance.name,
      'description': instance.description,
      'position': instance.position,
      'is_deleted': instance.isDeleted,
      'entity_state': _$EntityStateEnumMap[instance.entityState]!,
    };

const _$EntityStateEnumMap = {
  EntityState.edited: 'edited',
  EntityState.created: 'created',
  EntityState.deleted: 'deleted',
  EntityState.none: 'none',
};
