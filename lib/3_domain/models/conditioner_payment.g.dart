// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditioner_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConditionerPayment _$ConditionerPaymentFromJson(Map<String, dynamic> json) =>
    ConditionerPayment(
      id: json['id'] as String,
      conditionerId: json['conditioner_id'] as String,
      paymentType: $enumDecode(_$PaymentTypeEnumMap, json['payment_type']),
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      servicePercentage: (json['service_percentage'] as num).toDouble(),
      weeklyHours: (json['weekly_hours'] as num).toDouble(),
      isCurrent: json['is_current'] as bool,
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ConditionerPaymentToJson(ConditionerPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conditioner_id': instance.conditionerId,
      'payment_type': _$PaymentTypeEnumMap[instance.paymentType]!,
      'hourly_rate': instance.hourlyRate,
      'service_percentage': instance.servicePercentage,
      'weekly_hours': instance.weeklyHours,
      'is_current': instance.isCurrent,
      'end_date': instance.endDate?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$PaymentTypeEnumMap = {
  PaymentType.hourly: 'hourly',
  PaymentType.taskBased: 'task_based',
  PaymentType.combined: 'combined',
};
