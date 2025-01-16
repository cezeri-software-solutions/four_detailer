import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '/core/core.dart';
import '../models.dart';

part 'service_smart_item.g.dart';

enum ServiceSmartItemType {
  @JsonValue('vehicle_size')
  vehicleSize,
  @JsonValue('contamination_level')
  contaminationLevel,
}

@JsonSerializable(explicitToJson: true)
class ServiceSmartItem extends Equatable {
  final String id;
  @JsonKey(name: 'service_id')
  final String serviceId;
  final String name;
  final String description;
  final int position;
  @JsonKey(name: 'additional_net_price')
  final double additionalNetPrice;
  @JsonKey(name: 'additional_gross_price')
  final double additionalGrossPrice;
  @JsonKey(name: 'additional_duration')
  @DurationConverter()
  final Duration additionalDuration;
  @JsonKey(name: 'additional_net_material_costs')
  final double additionalNetMaterialCosts;
  @JsonKey(name: 'additional_gross_material_costs')
  final double additionalGrossMaterialCosts;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', includeToJson: false)
  final DateTime updatedAt;
  final ServiceSmartItemType type;
  @JsonKey(name: 'entity_state', includeFromJson: false, includeToJson: true)
  final EntityState entityState;

  const ServiceSmartItem({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.description,
    required this.position,
    required this.additionalNetPrice,
    required this.additionalGrossPrice,
    required this.additionalDuration,
    required this.additionalNetMaterialCosts,
    required this.additionalGrossMaterialCosts,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    this.entityState = EntityState.none,
  });

  factory ServiceSmartItem.fromJson(Map<String, dynamic> json) {
    final serviceSmartItem = _$ServiceSmartItemFromJson(json);
    return serviceSmartItem.copyWith(entityState: EntityState.none);
  }
  Map<String, dynamic> toJson() => _$ServiceSmartItemToJson(this);

  factory ServiceSmartItem.empty() {
    return ServiceSmartItem(
      id: '',
      serviceId: '',
      name: '',
      description: '',
      position: 0,
      additionalNetPrice: 0.0,
      additionalGrossPrice: 0.0,
      additionalDuration: Duration.zero,
      additionalNetMaterialCosts: 0.0,
      additionalGrossMaterialCosts: 0.0,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      type: ServiceSmartItemType.vehicleSize,
      entityState: EntityState.none,
    );
  }

  ServiceSmartItem copyWith({
    String? id,
    String? serviceId,
    String? name,
    String? description,
    int? position,
    double? additionalNetPrice,
    double? additionalGrossPrice,
    Duration? additionalDuration,
    double? additionalNetMaterialCosts,
    double? additionalGrossMaterialCosts,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    ServiceSmartItemType? type,
    EntityState? entityState,
  }) {
    return ServiceSmartItem(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      name: name ?? this.name,
      description: description ?? this.description,
      position: position ?? this.position,
      additionalNetPrice: additionalNetPrice ?? this.additionalNetPrice,
      additionalGrossPrice: additionalGrossPrice ?? this.additionalGrossPrice,
      additionalDuration: additionalDuration ?? this.additionalDuration,
      additionalNetMaterialCosts: additionalNetMaterialCosts ?? this.additionalNetMaterialCosts,
      additionalGrossMaterialCosts: additionalGrossMaterialCosts ?? this.additionalGrossMaterialCosts,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      entityState: entityState ?? this.entityState,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        position,
        additionalNetPrice,
        additionalGrossPrice,
        additionalDuration,
        additionalNetMaterialCosts,
        additionalGrossMaterialCosts,
        isDeleted,
        type,
        entityState,
      ];

  @override
  bool get stringify => true;
}

extension ConvertServiceSmartItemTypeStringToEnum on String {
  ServiceSmartItemType toEnumSSIT() {
    return switch (this) {
      'vehicleSize' => ServiceSmartItemType.vehicleSize,
      'contaminationLevel' => ServiceSmartItemType.contaminationLevel,
      _ => ServiceSmartItemType.vehicleSize,
    };
  }
}

extension ConvertServiceSmartItemTypeStringToJsonString on ServiceSmartItemType {
  String toJsonString() {
    return switch (this) {
      ServiceSmartItemType.vehicleSize => 'vehicle_size',
      ServiceSmartItemType.contaminationLevel => 'contamination_level',
    };
  }
}
