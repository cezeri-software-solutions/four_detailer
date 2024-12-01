import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank_details.g.dart';

@JsonSerializable(explicitToJson: true)
class BankDetails extends Equatable {
  final String id;
  @JsonKey(name: 'settings_id')
  final String settingsId;
  @JsonKey(name: 'bank_name')
  final String bankName; // Name der Bank
  @JsonKey(name: 'account_holder')
  final String accountHolder; // Kontoinhaber
  final String iban;
  final String bic;
  @JsonKey(name: 'paypal_email')
  final String paypalEmail;

  const BankDetails({
    required this.id,
    required this.settingsId,
    required this.bankName,
    required this.accountHolder,
    required this.iban,
    required this.bic,
    required this.paypalEmail,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) => _$BankDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$BankDetailsToJson(this);

  factory BankDetails.empty() {
    return const BankDetails(id: '', settingsId: '', bankName: '', accountHolder: '', iban: '', bic: '', paypalEmail: '');
  }

  BankDetails copyWith({
    String? id,
    String? settingsId,
    String? bankName,
    String? accountHolder,
    String? iban,
    String? bic,
    String? paypalEmail,
  }) {
    return BankDetails(
      id: id ?? this.id,
      settingsId: settingsId ?? this.settingsId,
      bankName: bankName ?? this.bankName,
      accountHolder: accountHolder ?? this.accountHolder,
      iban: iban ?? this.iban,
      bic: bic ?? this.bic,
      paypalEmail: paypalEmail ?? this.paypalEmail,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
