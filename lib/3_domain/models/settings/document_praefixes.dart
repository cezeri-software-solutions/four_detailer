import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_praefixes.g.dart';

@JsonSerializable(explicitToJson: true)
class DocumentPraefixes extends Equatable {
  final String id;
  @JsonKey(name: 'offer_praefix')
  final String offerPraefix;
  @JsonKey(name: 'appointment_praefix')
  final String appointmentPraefix;
  @JsonKey(name: 'invoice_praefix')
  final String invoicePraefix;
  @JsonKey(name: 'credit_praefix')
  final String creditPraefix;
  @JsonKey(name: 'incoming_invoice_praefix')
  final String incomingInvoicePraefix;

  const DocumentPraefixes({
    required this.id,
    required this.offerPraefix,
    required this.appointmentPraefix,
    required this.invoicePraefix,
    required this.creditPraefix,
    required this.incomingInvoicePraefix,
  });

  factory DocumentPraefixes.fromJson(Map<String, dynamic> json) => _$DocumentPraefixesFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentPraefixesToJson(this);

  factory DocumentPraefixes.empty() {
    return const DocumentPraefixes(
      id: '',
      offerPraefix: 'AG-',
      appointmentPraefix: 'AT-',
      invoicePraefix: 'RE-',
      creditPraefix: 'RK-',
      incomingInvoicePraefix: 'ER-',
    );
  }

  DocumentPraefixes copyWith({
    String? id,
    String? offerPraefix,
    String? appointmentPraefix,
    String? invoicePraefix,
    String? creditPraefix,
    String? incomingInvoicePraefix,
  }) {
    return DocumentPraefixes(
      id: id ?? this.id,
      offerPraefix: offerPraefix ?? this.offerPraefix,
      appointmentPraefix: appointmentPraefix ?? this.appointmentPraefix,
      invoicePraefix: invoicePraefix ?? this.invoicePraefix,
      creditPraefix: creditPraefix ?? this.creditPraefix,
      incomingInvoicePraefix: incomingInvoicePraefix ?? this.incomingInvoicePraefix,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
