// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankDetails _$BankDetailsFromJson(Map<String, dynamic> json) => BankDetails(
      id: json['id'] as String,
      bankName: json['bank_name'] as String,
      accountHolder: json['account_holder'] as String,
      iban: json['iban'] as String,
      bic: json['bic'] as String,
      paypalEmail: json['paypal_email'] as String,
    );

Map<String, dynamic> _$BankDetailsToJson(BankDetails instance) => <String, dynamic>{
      'id': instance.id,
      'bank_name': instance.bankName,
      'account_holder': instance.accountHolder,
      'iban': instance.iban,
      'bic': instance.bic,
      'paypal_email': instance.paypalEmail,
    };
