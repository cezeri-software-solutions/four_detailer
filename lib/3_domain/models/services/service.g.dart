// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      id: json['id'] as String,
      position: (json['position'] as num).toInt(),
      ownerId: json['owner_id'] as String,
      branchId: json['branch_id'] as String,
      category: json['category'] == null ? null : Category.fromJson(json['category'] as Map<String, dynamic>),
      number: json['number'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['short_description'] as String,
      currency: Currency.fromJson(json['currency'] as Map<String, dynamic>),
      tax: (json['tax'] as num).toDouble(),
      netPrice: (json['net_price'] as num).toDouble(),
      grossPrice: (json['gross_price'] as num).toDouble(),
      duration: const DurationConverter().fromJson(json['duration'] as String),
      vehicleSizes: (json['vehicle_sizes'] as List<dynamic>?)?.map((e) => ServiceSmartItem.fromJson(e as Map<String, dynamic>)).toList(),
      contaminationLevels:
          (json['contamination_levels'] as List<dynamic>?)?.map((e) => ServiceSmartItem.fromJson(e as Map<String, dynamic>)).toList(),
      todos: (json['todos'] as List<dynamic>?)?.map((e) => ServiceTodo.fromJson(e as Map<String, dynamic>)).toList(),
      isDeleted: json['is_deleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'owner_id': instance.ownerId,
      'branch_id': instance.branchId,
      'category': instance.category?.toJson(),
      'number': instance.number,
      'name': instance.name,
      'description': instance.description,
      'short_description': instance.shortDescription,
      'currency': instance.currency.toJson(),
      'tax': instance.tax,
      'net_price': instance.netPrice,
      'gross_price': instance.grossPrice,
      'duration': const DurationConverter().toJson(instance.duration),
      'vehicle_sizes': instance.vehicleSizes?.map((e) => e.toJson()).toList(),
      'contamination_levels': instance.contaminationLevels?.map((e) => e.toJson()).toList(),
      'todos': instance.todos?.map((e) => e.toJson()).toList(),
      'is_deleted': instance.isDeleted,
    };
