// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] as String,
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transaction_type']),
      cashRegisterId: json['cash_register_id'] as String,
      cashRegister: json['cash_register'] == null
          ? null
          : CashRegister.fromJson(
              json['cash_register'] as Map<String, dynamic>),
      paymentMethod: PaymentMethod.fromJson(
          json['payment_method'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaction_type': _$TransactionTypeEnumMap[instance.transactionType]!,
      'cash_register_id': instance.cashRegisterId,
      'cash_register': instance.cashRegister?.toJson(),
      'payment_method': instance.paymentMethod.toJson(),
      'amount': instance.amount,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
