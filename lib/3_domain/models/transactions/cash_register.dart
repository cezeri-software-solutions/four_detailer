import 'package:equatable/equatable.dart';
import 'package:four_detailer/3_domain/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cash_register.g.dart';

enum CashRegisterType { cash, bank, online, crypto }

@JsonSerializable(explicitToJson: true)
class CashRegister extends Equatable {
  final String id;
  final String name;
  @JsonKey(name: 'short_name')
  final String shortName;
  @JsonKey(name: 'cash_register_type')
  final CashRegisterType cashRegisterType;
  @JsonKey(name: 'branch_id')
  final String branchId;
  final double balance;
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @JsonKey(name: 'list_of_transactions')
  final List<Transaction>? listOfTransactions; // Falls ich die letzen x Transaktionen mitladen will
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const CashRegister({
    required this.id,
    required this.name,
    required this.shortName,
    required this.cashRegisterType,
    required this.branchId,
    required this.balance,
    required this.isDefault,
    required this.listOfTransactions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CashRegister.fromJson(Map<String, dynamic> json) => _$CashRegisterFromJson(json);
  Map<String, dynamic> toJson() => _$CashRegisterToJson(this);

  factory CashRegister.empty() {
    return CashRegister(
      id: '',
      name: '',
      shortName: '',
      cashRegisterType: CashRegisterType.bank,
      branchId: '',
      balance: 0.0,
      isDefault: true,
      listOfTransactions: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  CashRegister copyWith({
    String? id,
    String? name,
    String? shortName,
    CashRegisterType? cashRegisterType,
    String? branchId,
    double? balance,
    bool? isDefault,
    List<Transaction>? listOfTransactions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CashRegister(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      cashRegisterType: cashRegisterType ?? this.cashRegisterType,
      branchId: branchId ?? this.branchId,
      balance: balance ?? this.balance,
      isDefault: isDefault ?? this.isDefault,
      listOfTransactions: listOfTransactions ?? this.listOfTransactions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
