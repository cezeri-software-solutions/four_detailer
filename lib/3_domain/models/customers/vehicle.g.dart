// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      customerId: json['customer_id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      modelVariant: json['model_variant'] as String,
      bodyType: $enumDecode(_$BodyTypeEnumMap, json['body_type']),
      firstRegistration: json['first_registration'] == null ? null : DateTime.parse(json['first_registration'] as String),
      mileage: (json['mileage'] as num).toInt(),
      fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuel_type']),
      powerHP: (json['power_hp'] as num).toInt(),
      powerKW: (json['power_kw'] as num).toInt(),
      color: json['color'] as String,
      colorCode: json['color_code'] as String,
      vin: json['vin'] as String,
      licensePlate: json['license_plate'] as String,
      comment: json['comment'] as String,
      isActive: json['is_active'] as bool,
      isDeleted: json['is_deleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'customer_id': instance.customerId,
      'brand': instance.brand,
      'model': instance.model,
      'model_variant': instance.modelVariant,
      'body_type': _$BodyTypeEnumMap[instance.bodyType]!,
      'first_registration': instance.firstRegistration?.toIso8601String(),
      'mileage': instance.mileage,
      'fuel_type': _$FuelTypeEnumMap[instance.fuelType]!,
      'power_hp': instance.powerHP,
      'power_kw': instance.powerKW,
      'color': instance.color,
      'color_code': instance.colorCode,
      'vin': instance.vin,
      'license_plate': instance.licensePlate,
      'comment': instance.comment,
      'is_active': instance.isActive,
      'is_deleted': instance.isDeleted,
      'entity_state': _$EntityStateEnumMap[instance.entityState]!,
    };

const _$BodyTypeEnumMap = {
  BodyType.motorcycle: 'motorcycle',
  BodyType.compact: 'compact',
  BodyType.sedan: 'sedan',
  BodyType.wagon: 'wagon',
  BodyType.convertible: 'convertible',
  BodyType.coupe: 'coupe',
  BodyType.suv: 'suv',
  BodyType.van: 'van',
  BodyType.transporter: 'transporter',
  BodyType.other: 'other',
};

const _$FuelTypeEnumMap = {
  FuelType.petrol: 'petrol',
  FuelType.diesel: 'diesel',
  FuelType.electric: 'electric',
  FuelType.hybrid: 'hybrid',
  FuelType.pluginHybrid: 'plugin_hybrid',
  FuelType.lpg: 'lpg',
  FuelType.cng: 'cng',
  FuelType.other: 'other',
};

const _$EntityStateEnumMap = {
  EntityState.edited: 'edited',
  EntityState.created: 'created',
  EntityState.deleted: 'deleted',
  EntityState.none: 'none',
};
