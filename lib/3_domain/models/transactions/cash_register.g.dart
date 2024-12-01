// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashRegister _$CashRegisterFromJson(Map<String, dynamic> json) => CashRegister(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['short_name'] as String,
      cashRegisterType:
          $enumDecode(_$CashRegisterTypeEnumMap, json['cash_register_type']),
      branchId: json['branch_id'] as String,
      balance: (json['balance'] as num).toDouble(),
      isDefault: json['is_default'] as bool,
      listOfTransactions: (json['list_of_transactions'] as List<dynamic>?)
          ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CashRegisterToJson(CashRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'short_name': instance.shortName,
      'cash_register_type':
          _$CashRegisterTypeEnumMap[instance.cashRegisterType]!,
      'branch_id': instance.branchId,
      'balance': instance.balance,
      'is_default': instance.isDefault,
      'list_of_transactions':
          instance.listOfTransactions?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$CashRegisterTypeEnumMap = {
  CashRegisterType.cash: 'cash',
  CashRegisterType.bank: 'bank',
  CashRegisterType.online: 'online',
  CashRegisterType.crypto: 'crypto',
};
