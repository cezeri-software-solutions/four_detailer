// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplateService _$TemplateServiceFromJson(Map<String, dynamic> json) =>
    TemplateService(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      branchId: json['branch_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      position: (json['position'] as num).toInt(),
      type: $enumDecode(_$TemplateServiceTypeEnumMap, json['type']),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TemplateServiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TemplateServiceToJson(TemplateService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'branch_id': instance.branchId,
      'name': instance.name,
      'description': instance.description,
      'position': instance.position,
      'type': _$TemplateServiceTypeEnumMap[instance.type]!,
      'items': instance.items?.map((e) => e.toJson()).toList(),
    };

const _$TemplateServiceTypeEnumMap = {
  TemplateServiceType.vehicleSize: 'vehicle_size',
  TemplateServiceType.contaminationLevel: 'contamination_level',
  TemplateServiceType.todo: 'todo',
};

TemplateServiceItem _$TemplateServiceItemFromJson(Map<String, dynamic> json) =>
    TemplateServiceItem(
      id: json['id'] as String,
      templateServiceId: json['template_service_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      position: (json['position'] as num).toInt(),
    );

Map<String, dynamic> _$TemplateServiceItemToJson(
        TemplateServiceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'template_service_id': instance.templateServiceId,
      'name': instance.name,
      'description': instance.description,
      'position': instance.position,
    };
