// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeZone _$TimeZoneFromJson(Map<String, dynamic> json) => TimeZone(
      id: json['id'] as String,
      sortId: (json['sort_id'] as num).toInt(),
      name: json['name'] as String,
      utcOffset: json['utc_offset'] as String,
      abbreviation: json['abbreviation'] as String,
    );

Map<String, dynamic> _$TimeZoneToJson(TimeZone instance) => <String, dynamic>{
      'id': instance.id,
      'sort_id': instance.sortId,
      'name': instance.name,
      'utc_offset': instance.utcOffset,
      'abbreviation': instance.abbreviation,
    };
