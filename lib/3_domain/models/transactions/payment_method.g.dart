// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) => PaymentMethod(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['short_name'] as String,
      isDefault: json['isDefault'] as bool,
      branchId: json['branch_id'] as String,
      cashRegisterId: json['cash_register_id'] as String,
      cashRegister: json['cash_register'] == null ? null : CashRegister.fromJson(json['cash_register'] as Map<String, dynamic>),
      logoUrl: json['logo_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'short_name': instance.shortName,
      'isDefault': instance.isDefault,
      'branch_id': instance.branchId,
      'cash_register_id': instance.cashRegisterId,
      'cash_register': instance.cashRegister?.toJson(),
      'logo_url': instance.logoUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
