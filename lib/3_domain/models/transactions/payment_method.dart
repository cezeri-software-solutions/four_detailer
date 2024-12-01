import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models.dart';

part 'payment_method.g.dart';

@JsonSerializable(explicitToJson: true)
class PaymentMethod extends Equatable {
  final String id;
  final String name;
  @JsonKey(name: 'short_name')
  final String shortName;
  final bool isDefault;
  @JsonKey(name: 'branch_id')
  final String branchId;
  @JsonKey(name: 'cash_register_id')
  final String cashRegisterId;
  @JsonKey(name: 'cash_register')
  final CashRegister? cashRegister; // Falls ich den CashRegister mitladen will
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.shortName,
    required this.isDefault,
    required this.branchId,
    required this.cashRegisterId,
    required this.cashRegister,
    required this.logoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);

  factory PaymentMethod.empty() {
    return PaymentMethod(
      id: '',
      name: '',
      shortName: '',
      isDefault: false,
      branchId: '',
      cashRegisterId: '',
      cashRegister: null,
      logoUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  PaymentMethod copyWith({
    String? id,
    String? name,
    String? shortName,
    bool? isDefault,
    String? branchId,
    String? cashRegisterId,
    CashRegister? cashRegister,
    String? logoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      isDefault: isDefault ?? this.isDefault,
      branchId: branchId ?? this.branchId,
      cashRegisterId: cashRegisterId ?? this.cashRegisterId,
      cashRegister: cashRegister ?? this.cashRegister,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
