// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_texts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentTexts _$DocumentTextsFromJson(Map<String, dynamic> json) =>
    DocumentTexts(
      id: json['id'] as String,
      offerDocumentText: json['offer_document_text'] as String,
      appointmentDocumentText: json['appointment_document_text'] as String,
      invoiceDocumentText: json['invoice_document_text'] as String,
      creditDocumentText: json['credit_document_text'] as String,
    );

Map<String, dynamic> _$DocumentTextsToJson(DocumentTexts instance) =>
    <String, dynamic>{
      'id': instance.id,
      'offer_document_text': instance.offerDocumentText,
      'appointment_document_text': instance.appointmentDocumentText,
      'invoice_document_text': instance.invoiceDocumentText,
      'credit_document_text': instance.creditDocumentText,
    };
