// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_praefixes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentPraefixes _$DocumentPraefixesFromJson(Map<String, dynamic> json) => DocumentPraefixes(
      id: json['id'] as String,
      offerPraefix: json['offer_praefix'] as String,
      appointmentPraefix: json['appointment_praefix'] as String,
      invoicePraefix: json['invoice_praefix'] as String,
      creditPraefix: json['credit_praefix'] as String,
      incomingInvoicePraefix: json['incoming_invoice_praefix'] as String,
    );

Map<String, dynamic> _$DocumentPraefixesToJson(DocumentPraefixes instance) => <String, dynamic>{
      'id': instance.id,
      'offer_praefix': instance.offerPraefix,
      'appointment_praefix': instance.appointmentPraefix,
      'invoice_praefix': instance.invoicePraefix,
      'credit_praefix': instance.creditPraefix,
      'incoming_invoice_praefix': instance.incomingInvoicePraefix,
    };
