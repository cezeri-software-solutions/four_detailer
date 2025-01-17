// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_counters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NumberCounters _$NumberCountersFromJson(Map<String, dynamic> json) => NumberCounters(
      id: json['id'] as String,
      nextOfferNumber: (json['next_offer_number'] as num).toInt(),
      nextAppointmentNumber: (json['next_appointment_number'] as num).toInt(),
      nextInvoiceNumber: (json['next_invoice_number'] as num).toInt(),
      nextIncomingInvoiceNumber: (json['next_incoming_invoice_number'] as num).toInt(),
      nextBranchNumber: (json['next_branch_number'] as num).toInt(),
      nextCustomerNumber: (json['next_customer_number'] as num).toInt(),
    );

Map<String, dynamic> _$NumberCountersToJson(NumberCounters instance) => <String, dynamic>{
      'id': instance.id,
      'next_offer_number': instance.nextOfferNumber,
      'next_appointment_number': instance.nextAppointmentNumber,
      'next_invoice_number': instance.nextInvoiceNumber,
      'next_incoming_invoice_number': instance.nextIncomingInvoiceNumber,
      'next_branch_number': instance.nextBranchNumber,
      'next_customer_number': instance.nextCustomerNumber,
    };
