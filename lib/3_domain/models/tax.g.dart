// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tax _$TaxFromJson(Map<String, dynamic> json) => Tax(
      id: json['id'] as String,
      rate: (json['rate'] as num).toDouble(),
      isReduced: json['is_reduced'] as bool,
      countryCodes: (json['country_codes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TaxToJson(Tax instance) => <String, dynamic>{
      'id': instance.id,
      'rate': instance.rate,
      'is_reduced': instance.isReduced,
      'country_codes': instance.countryCodes,
    };
