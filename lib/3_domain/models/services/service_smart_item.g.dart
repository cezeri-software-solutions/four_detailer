// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_smart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceSmartItem _$ServiceSmartItemFromJson(Map<String, dynamic> json) => ServiceSmartItem(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      position: (json['position'] as num).toInt(),
      additionalNetPrice: (json['additional_net_price'] as num).toDouble(),
      additionalGrossPrice: (json['additional_gross_price'] as num).toDouble(),
      additionalDuration: const DurationConverter().fromJson(json['additional_duration'] as String),
      additionalNetMaterialCosts: (json['additional_net_material_costs'] as num).toDouble(),
      additionalGrossMaterialCosts: (json['additional_gross_material_costs'] as num).toDouble(),
      isDeleted: json['is_deleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      type: $enumDecode(_$ServiceSmartItemTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ServiceSmartItemToJson(ServiceSmartItem instance) => <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'name': instance.name,
      'description': instance.description,
      'position': instance.position,
      'additional_net_price': instance.additionalNetPrice,
      'additional_gross_price': instance.additionalGrossPrice,
      'additional_duration': const DurationConverter().toJson(instance.additionalDuration),
      'additional_net_material_costs': instance.additionalNetMaterialCosts,
      'additional_gross_material_costs': instance.additionalGrossMaterialCosts,
      'is_deleted': instance.isDeleted,
      'type': _$ServiceSmartItemTypeEnumMap[instance.type]!,
      'entity_state': _$EntityStateEnumMap[instance.entityState]!,
    };

const _$ServiceSmartItemTypeEnumMap = {
  ServiceSmartItemType.vehicleSize: 'vehicle_size',
  ServiceSmartItemType.contaminationLevel: 'contamination_level',
};

const _$EntityStateEnumMap = {
  EntityState.edited: 'edited',
  EntityState.created: 'created',
  EntityState.deleted: 'deleted',
  EntityState.none: 'none',
};
