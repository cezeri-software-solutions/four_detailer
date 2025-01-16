import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '/core/core.dart';
import '../models.dart';

part 'service.g.dart';

@JsonSerializable(explicitToJson: true)
class Service extends Equatable {
  final String id;
  final int position;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(name: 'branch_id')
  final String branchId;
  final Category? category;
  final String number; // Artikelnummer
  final String name;
  final String description;
  @JsonKey(name: 'short_description')
  final String shortDescription;
  final Currency currency;
  final double tax;
  @JsonKey(name: 'net_price')
  final double netPrice; // Netto Preis OHNE Zuschläge durch Fahrzeuggröße oder Verschmutzungsgrad
  @JsonKey(name: 'gross_price')
  final double grossPrice; // Brutto Preis OHNE Zuschläge durch Fahrzeuggröße oder Verschmutzungsgrad
  @DurationConverter()
  final Duration duration; // Dauer der Service OHNE Zuschläge durch Fahrzeuggröße oder Verschmutzungsgrad
  @JsonKey(name: 'vehicle_sizes')
  final List<ServiceSmartItem>? vehicleSizes;
  @JsonKey(name: 'contamination_levels')
  final List<ServiceSmartItem>? contaminationLevels;
  @JsonKey(name: 'todos')
  final List<ServiceTodo>? todos;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', includeToJson: false)
  final DateTime updatedAt;

  const Service({
    required this.id,
    required this.position,
    required this.ownerId,
    required this.branchId,
    required this.category,
    required this.number,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.currency,
    required this.tax,
    required this.netPrice,
    required this.grossPrice,
    required this.duration,
    required this.vehicleSizes,
    required this.contaminationLevels,
    required this.todos,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  factory Service.empty() {
    return Service(
      id: '',
      position: 0,
      ownerId: '',
      branchId: '',
      category: null,
      number: '',
      name: '',
      description: '',
      shortDescription: '',
      currency: Currency.main(),
      tax: 0.0,
      netPrice: 0.0,
      grossPrice: 0.0,
      duration: Duration.zero,
      vehicleSizes: const [],
      contaminationLevels: const [],
      todos: const [],
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Service copyWith({
    String? id,
    int? position,
    String? ownerId,
    String? branchId,
    bool? resetCategory,
    Category? category,
    String? number,
    String? name,
    String? description,
    String? shortDescription,
    double? tax,
    Currency? currency,
    double? netPrice,
    double? grossPrice,
    Duration? duration,
    List<ServiceSmartItem>? vehicleSizes,
    List<ServiceSmartItem>? contaminationLevels,
    List<ServiceTodo>? todos,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      position: position ?? this.position,
      ownerId: ownerId ?? this.ownerId,
      branchId: branchId ?? this.branchId,
      category: resetCategory != null && resetCategory == true ? null : category ?? this.category,
      number: number ?? this.number,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      currency: currency ?? this.currency,
      tax: tax ?? this.tax,
      netPrice: netPrice ?? this.netPrice,
      grossPrice: grossPrice ?? this.grossPrice,
      duration: duration ?? this.duration,
      vehicleSizes: vehicleSizes ?? this.vehicleSizes,
      contaminationLevels: contaminationLevels ?? this.contaminationLevels,
      todos: todos ?? this.todos,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        position,
        ownerId,
        branchId,
        category,
        number,
        name,
        description,
        shortDescription,
        currency,
        tax,
        netPrice,
        grossPrice,
        duration,
        isDeleted,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}
