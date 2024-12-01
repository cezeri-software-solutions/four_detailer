// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      id: json['id'] as String,
      isoCode: json['iso_code'] as String,
      name: json['name'] as String,
      nameEnglish: json['name_english'] as String,
      dialCode: json['dial_code'] as String,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'iso_code': instance.isoCode,
      'name': instance.name,
      'name_english': instance.nameEnglish,
      'dial_code': instance.dialCode,
    };
