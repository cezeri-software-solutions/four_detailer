import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'country.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true)
class Address extends Equatable {
  final String id;
  final Country country;
  final String state;
  final String city;
  final String street;
  @JsonKey(name: 'postal_code')
  final String postalCode;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Address({
    required this.id,
    required this.country,
    required this.state,
    required this.city,
    required this.street,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  factory Address.empty() {
    return Address(
      id: '',
      country: Country.germany(),
      state: '',
      city: '',
      street: '',
      postalCode: '',
      latitude: 0.0,
      longitude: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Address copyWith({
    String? id,
    Country? country,
    String? state,
    String? city,
    String? street,
    String? postalCode,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
