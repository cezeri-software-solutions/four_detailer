import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tax.g.dart';

@JsonSerializable(explicitToJson: true)
class Tax extends Equatable {
  final String id;
  final double rate;
  @JsonKey(name: 'is_reduced')
  final bool isReduced;
  @JsonKey(name: 'country_codes')
  final List<String> countryCodes;

  const Tax({required this.id, required this.rate, required this.isReduced, required this.countryCodes});

  factory Tax.fromJson(Map<String, dynamic> json) => _$TaxFromJson(json);
  Map<String, dynamic> toJson() => _$TaxToJson(this);

  factory Tax.empty() => const Tax(id: '', rate: 0, isReduced: false, countryCodes: []);

  Tax copyWith({
    String? id,
    double? rate,
    bool? isReduced,
    List<String>? countryCodes,
  }) {
    return Tax(
      id: id ?? this.id,
      rate: rate ?? this.rate,
      isReduced: isReduced ?? this.isReduced,
      countryCodes: countryCodes ?? this.countryCodes,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
