import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_texts.g.dart';

@JsonSerializable(explicitToJson: true)
class DocumentTexts extends Equatable {
  final String id;
  @JsonKey(name: 'offer_document_text')
  final String offerDocumentText;
  @JsonKey(name: 'appointment_document_text')
  final String appointmentDocumentText;
  @JsonKey(name: 'invoice_document_text')
  final String invoiceDocumentText;
  @JsonKey(name: 'credit_document_text')
  final String creditDocumentText;

  const DocumentTexts({
    required this.id,
    required this.offerDocumentText,
    required this.appointmentDocumentText,
    required this.invoiceDocumentText,
    required this.creditDocumentText,
  });

  factory DocumentTexts.fromJson(Map<String, dynamic> json) => _$DocumentTextsFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentTextsToJson(this);

  factory DocumentTexts.empty() {
    return const DocumentTexts(id: '', offerDocumentText: '', appointmentDocumentText: '', invoiceDocumentText: '', creditDocumentText: '');
  }

  DocumentTexts copyWith({
    String? id,
    String? offerDocumentText,
    String? appointmentDocumentText,
    String? invoiceDocumentText,
    String? creditDocumentText,
  }) {
    return DocumentTexts(
      id: id ?? this.id,
      offerDocumentText: offerDocumentText ?? this.offerDocumentText,
      appointmentDocumentText: appointmentDocumentText ?? this.appointmentDocumentText,
      invoiceDocumentText: invoiceDocumentText ?? this.invoiceDocumentText,
      creditDocumentText: creditDocumentText ?? this.creditDocumentText,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
