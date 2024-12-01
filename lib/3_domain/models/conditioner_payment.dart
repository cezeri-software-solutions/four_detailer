import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conditioner_payment.g.dart';

enum PaymentType {
  @JsonValue('hourly')
  hourly,
  @JsonValue('task_based')
  taskBased,
  @JsonValue('combined')
  combined,
}

@JsonSerializable(explicitToJson: true)
class ConditionerPayment extends Equatable {
  final String id;
  @JsonKey(name: 'conditioner_id')
  final String conditionerId;
  @JsonKey(name: 'payment_type')
  final PaymentType paymentType; // Sollte in der App als Enum gehandhabt werden
  @JsonKey(name: 'hourly_rate')
  final double hourlyRate;
  @JsonKey(name: 'service_percentage')
  final double servicePercentage;
  @JsonKey(name: 'weekly_hours')
  final double weeklyHours;
  @JsonKey(name: 'is_current')
  final bool isCurrent;
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const ConditionerPayment({
    required this.id,
    required this.conditionerId,
    required this.paymentType,
    required this.hourlyRate,
    required this.servicePercentage,
    required this.weeklyHours,
    required this.isCurrent,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConditionerPayment.fromJson(Map<String, dynamic> json) => _$ConditionerPaymentFromJson(json);
  Map<String, dynamic> toJson() => _$ConditionerPaymentToJson(this);

  factory ConditionerPayment.empty() {
    return ConditionerPayment(
      id: '',
      conditionerId: '',
      paymentType: PaymentType.hourly,
      hourlyRate: 0.0,
      servicePercentage: 0.0,
      weeklyHours: 0.0,
      isCurrent: true,
      endDate: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  ConditionerPayment copyWith({
    String? id,
    String? ownerId,
    String? conditionerId,
    PaymentType? paymentType,
    double? hourlyRate,
    double? servicePercentage,
    double? weeklyHours,
    bool? isCurrent,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConditionerPayment(
      id: id ?? this.id,
      conditionerId: conditionerId ?? this.conditionerId,
      paymentType: paymentType ?? this.paymentType,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      servicePercentage: servicePercentage ?? this.servicePercentage,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      isCurrent: isCurrent ?? this.isCurrent,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
