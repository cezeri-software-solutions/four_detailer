import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable(explicitToJson: true)
class Country extends Equatable {
  final String id;
  @JsonKey(name: 'iso_code')
  final String isoCode;
  final String name;
  @JsonKey(name: 'name_english')
  final String nameEnglish;
  @JsonKey(name: 'dial_code')
  final String dialCode;
  @JsonKey(name: 'flag_url')
  final String flagUrl;

  Country({
    required this.id,
    required this.isoCode,
    required this.name,
    required this.nameEnglish,
    required this.dialCode,
  }) : flagUrl = isoCode.isEmpty ? '' : 'https://flagcdn.com/w640/${isoCode.toLowerCase()}.png';

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);

  factory Country.empty() {
    return Country(
      id: '',
      isoCode: '',
      name: '',
      nameEnglish: '',
      dialCode: '',
    );
  }

  Country copyWith({
    String? id,
    String? isoCode,
    String? name,
    String? nameEnglish,
    String? dialCode,
  }) {
    return Country(
      id: id ?? this.id,
      isoCode: isoCode ?? this.isoCode,
      name: name ?? this.name,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      dialCode: dialCode ?? this.dialCode,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
