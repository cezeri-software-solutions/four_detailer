// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainSettings _$MainSettingsFromJson(Map<String, dynamic> json) => MainSettings(
      id: json['id'] as String,
      documentPraefixes: DocumentPraefixes.fromJson(
          json['document_praefixes'] as Map<String, dynamic>),
      documentTexts: DocumentTexts.fromJson(
          json['document_texts'] as Map<String, dynamic>),
      numberCounters: NumberCounters.fromJson(
          json['number_counters'] as Map<String, dynamic>),
      bankDetails:
          BankDetails.fromJson(json['bank_details'] as Map<String, dynamic>),
      currency: Currency.fromJson(json['currency'] as Map<String, dynamic>),
      isSmallBusiness: json['is_small_business'] as bool,
      tax: (json['tax'] as num).toDouble(),
      paymentDeadline: (json['payment_deadline'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MainSettingsToJson(MainSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'document_praefixes': instance.documentPraefixes.toJson(),
      'document_texts': instance.documentTexts.toJson(),
      'number_counters': instance.numberCounters.toJson(),
      'bank_details': instance.bankDetails.toJson(),
      'currency': instance.currency.toJson(),
      'is_small_business': instance.isSmallBusiness,
      'tax': instance.tax,
      'payment_deadline': instance.paymentDeadline,
    };
