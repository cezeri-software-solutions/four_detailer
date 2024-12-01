import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'time_zone.g.dart';

@JsonSerializable(explicitToJson: true)
class TimeZone extends Equatable {
  final String id;
  @JsonKey(name: 'sort_id')
  final int sortId;
  final String name;
  @JsonKey(name: 'utc_offset')
  final String utcOffset;
  final String abbreviation;

  const TimeZone({required this.id, required this.sortId, required this.name, required this.utcOffset, required this.abbreviation});

  factory TimeZone.fromJson(Map<String, dynamic> json) => _$TimeZoneFromJson(json);
  Map<String, dynamic> toJson() => _$TimeZoneToJson(this);

  factory TimeZone.empty() {
    return const TimeZone(id: '', sortId: 0, name: '', utcOffset: '', abbreviation: '');
  }

  TimeZone copyWith({
    String? id,
    int? sortId,
    String? name,
    String? utcOffset,
    String? abbreviation,
  }) {
    return TimeZone(
      id: id ?? this.id,
      sortId: sortId ?? this.sortId,
      name: name ?? this.name,
      utcOffset: utcOffset ?? this.utcOffset,
      abbreviation: abbreviation ?? this.abbreviation,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
