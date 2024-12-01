import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable(explicitToJson: true)
class Currency extends Equatable {
  final String id;
  final String code;
  final String name;
  final String symbol;
  @JsonKey(name: 'is_crypto')
  final bool isCrypto;
  @JsonKey(name: 'is_active')
  final bool isActive;

  const Currency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.isCrypto,
    required this.isActive,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyToJson(this);

  factory Currency.main() {
    return const Currency(
      id: '8167b584-bcf4-4cdf-9fd9-6025470d51cc',
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      isCrypto: false,
      isActive: true,
    );
  }

  Currency copyWith({
    String? id,
    String? code,
    String? name,
    String? symbol,
    bool? isCrypto,
    bool? isActive,
  }) {
    return Currency(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      isCrypto: isCrypto ?? this.isCrypto,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
