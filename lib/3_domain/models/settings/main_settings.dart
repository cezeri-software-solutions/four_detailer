import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models.dart';

part 'main_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class MainSettings extends Equatable {
  final String id;
  @JsonKey(name: 'document_praefixes')
  final DocumentPraefixes documentPraefixes;
  @JsonKey(name: 'document_texts')
  final DocumentTexts documentTexts;
  @JsonKey(name: 'number_counters')
  final NumberCounters numberCounters;
  @JsonKey(name: 'bank_details')
  final BankDetails bankDetails;
  // @JsonKey(toJson: _customCurrencyToJson)
  final Currency currency;
  @JsonKey(name: 'is_small_business')
  final bool isSmallBusiness;
  final double tax;
  @JsonKey(name: 'payment_deadline')
  final int paymentDeadline; // Bei offenen Rechnungen in Tagen
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', includeToJson: false)
  final DateTime updatedAt;

  const MainSettings({
    required this.id,
    required this.documentPraefixes,
    required this.documentTexts,
    required this.numberCounters,
    required this.bankDetails,
    required this.currency,
    required this.isSmallBusiness,
    required this.tax,
    required this.paymentDeadline,
    required this.createdAt,
    required this.updatedAt,
  });

  // static Map<String, dynamic> _customCurrencyToJson(Currency currency) => {'id': currency.id};

  factory MainSettings.fromJson(Map<String, dynamic> json) => _$MainSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$MainSettingsToJson(this);

  factory MainSettings.empty() {
    return MainSettings(
      id: '',
      documentPraefixes: DocumentPraefixes.empty(),
      documentTexts: DocumentTexts.empty(),
      numberCounters: NumberCounters.empty(),
      bankDetails: BankDetails.empty(),
      currency: Currency.main(),
      isSmallBusiness: false,
      tax: 20.0,
      paymentDeadline: 14,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  MainSettings copyWith({
    String? id,
    DocumentPraefixes? documentPraefixes,
    DocumentTexts? documentTexts,
    NumberCounters? numberCounters,
    BankDetails? bankDetails,
    Currency? currency,
    bool? isSmallBusiness,
    double? tax,
    int? paymentDeadline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MainSettings(
      id: id ?? this.id,
      documentPraefixes: documentPraefixes ?? this.documentPraefixes,
      documentTexts: documentTexts ?? this.documentTexts,
      numberCounters: numberCounters ?? this.numberCounters,
      bankDetails: bankDetails ?? this.bankDetails,
      currency: currency ?? this.currency,
      isSmallBusiness: isSmallBusiness ?? this.isSmallBusiness,
      tax: tax ?? this.tax,
      paymentDeadline: paymentDeadline ?? this.paymentDeadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
