import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '/core/core.dart';
import 'models.dart';

part 'vehicle.g.dart';

enum FuelType {
  @JsonValue('petrol')
  petrol, // Benzin
  @JsonValue('diesel')
  diesel, // Diesel
  @JsonValue('electric')
  electric, // Elektro
  @JsonValue('hybrid')
  hybrid, // Hybrid
  @JsonValue('plugin_hybrid')
  pluginHybrid, // Plugin-Hybrid
  @JsonValue('lpg')
  lpg, // Autogas
  @JsonValue('cng')
  cng, // Erdgas
  @JsonValue('other')
  other, // Sonstiges
}

enum BodyType {
  @JsonValue('motorcycle')
  motorcycle, // Motorrad
  @JsonValue('compact')
  compact, // Kleinwagen
  @JsonValue('sedan')
  sedan, // Limousine
  @JsonValue('wagon')
  wagon, // Kombi
  @JsonValue('convertible')
  convertible, // Cabrio / Roadster
  @JsonValue('coupe')
  coupe, // Coupe / Sportwagen
  @JsonValue('suv')
  suv, // SUV / Geländewagen / Pickup
  @JsonValue('van')
  van, // Van / Kleinbus
  @JsonValue('transporter')
  transporter, // Transporter
  @JsonValue('other')
  other; // Sonstiges
}

@JsonSerializable(explicitToJson: true)
class Vehicle extends Equatable {
  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(name: 'customer_id')
  final String customerId; //! IM STATE
  final String brand;
  final String model;
  @JsonKey(name: 'model_variant')
  final String modelVariant; //* (z.B. GTI, TDI, ...)
  @JsonKey(name: 'body_type')
  final BodyType bodyType;
  @JsonKey(name: 'first_registration')
  final DateTime? firstRegistration;
  final int mileage; //* Kilometerstand
  @JsonKey(name: 'fuel_type')
  final FuelType fuelType;
  @JsonKey(name: 'power_hp')
  final int powerHP;
  @JsonKey(name: 'power_kw')
  final int powerKW;
  final String color;
  @JsonKey(name: 'color_code')
  final String colorCode;
  @JsonKey(name: 'vin')
  final String vin; //* Fahrgestellnummer
  @JsonKey(name: 'license_plate')
  final String licensePlate; //* Kennzeichen
  final String comment;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', includeToJson: false)
  final DateTime updatedAt;
  @JsonKey(name: 'entity_state', includeFromJson: false, includeToJson: true)
  final EntityState entityState;

  const Vehicle({
    required this.id,
    required this.ownerId,
    required this.customerId,
    required this.brand,
    required this.model,
    required this.modelVariant,
    required this.bodyType,
    required this.firstRegistration,
    required this.mileage,
    required this.fuelType,
    required this.powerHP,
    required this.powerKW,
    required this.color,
    required this.colorCode,
    required this.vin,
    required this.licensePlate,
    required this.comment,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.entityState = EntityState.none,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    final vehicle = _$VehicleFromJson(json);
    return vehicle.copyWith(entityState: EntityState.none);
  }
  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  factory Vehicle.empty() {
    return Vehicle(
      id: '',
      ownerId: '',
      customerId: '',
      brand: '',
      model: '',
      modelVariant: '',
      bodyType: BodyType.sedan,
      firstRegistration: null,
      mileage: 0,
      fuelType: FuelType.petrol,
      powerHP: 0,
      powerKW: 0,
      color: '',
      colorCode: '',
      vin: '',
      licensePlate: '',
      comment: '',
      isActive: true,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      entityState: EntityState.none,
    );
  }

  Vehicle copyWith({
    String? id,
    String? ownerId,
    String? customerId,
    String? brand,
    String? model,
    String? modelVariant,
    BodyType? bodyType,
    DateTime? firstRegistration,
    int? mileage,
    FuelType? fuelType,
    int? powerHP,
    int? powerKW,
    String? color,
    String? colorCode,
    String? vin,
    String? licensePlate,
    String? comment,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    EntityState? entityState,
  }) {
    return Vehicle(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      customerId: customerId ?? this.customerId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      modelVariant: modelVariant ?? this.modelVariant,
      bodyType: bodyType ?? this.bodyType,
      firstRegistration: firstRegistration ?? this.firstRegistration,
      mileage: mileage ?? this.mileage,
      fuelType: fuelType ?? this.fuelType,
      powerHP: powerHP ?? this.powerHP,
      powerKW: powerKW ?? this.powerKW,
      color: color ?? this.color,
      colorCode: colorCode ?? this.colorCode,
      vin: vin ?? this.vin,
      licensePlate: licensePlate ?? this.licensePlate,
      comment: comment ?? this.comment,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      entityState: entityState ?? this.entityState,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}

extension ConvertFuelTypeToString on FuelType {
  String convert(BuildContext context) {
    return switch (this) {
      FuelType.petrol => context.l10n.enum_fuelType_petrol,
      FuelType.diesel => context.l10n.enum_fuelType_diesel,
      FuelType.electric => context.l10n.enum_fuelType_electric,
      FuelType.hybrid => context.l10n.enum_fuelType_hybrid,
      FuelType.pluginHybrid => context.l10n.enum_fuelType_pluginHybrid,
      FuelType.lpg => context.l10n.enum_fuelType_lpg,
      FuelType.cng => context.l10n.enum_fuelType_cng,
      FuelType.other => context.l10n.other,
    };
  }
}

extension ConvertBodyTypeToString on BodyType {
  String convert(BuildContext context) {
    return switch (this) {
      BodyType.motorcycle => context.l10n.enum_bodyType_motorcycle,
      BodyType.compact => context.l10n.enum_bodyType_compact,
      BodyType.sedan => context.l10n.enum_bodyType_sedan,
      BodyType.wagon => context.l10n.enum_bodyType_wagon,
      BodyType.convertible => context.l10n.enum_bodyType_convertible,
      BodyType.coupe => context.l10n.enum_bodyType_coupe,
      BodyType.suv => context.l10n.enum_bodyType_suv,
      BodyType.van => context.l10n.enum_bodyType_van,
      BodyType.transporter => context.l10n.enum_bodyType_transporter,
      BodyType.other => context.l10n.other,
    };
  }
}
