import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'number_counters.g.dart';

@JsonSerializable(explicitToJson: true)
class NumberCounters extends Equatable {
  final String id;
  @JsonKey(name: 'next_offer_number')
  final int nextOfferNumber;
  @JsonKey(name: 'next_appointment_number')
  final int nextAppointmentNumber;
  @JsonKey(name: 'next_invoice_number')
  final int nextInvoiceNumber;
  @JsonKey(name: 'next_incoming_invoice_number')
  final int nextIncomingInvoiceNumber;
  @JsonKey(name: 'next_branch_number')
  final int nextBranchNumber;
  @JsonKey(name: 'next_customer_number')
  final int nextCustomerNumber;

  const NumberCounters({
    required this.id,
    required this.nextOfferNumber,
    required this.nextAppointmentNumber,
    required this.nextInvoiceNumber,
    required this.nextIncomingInvoiceNumber,
    required this.nextBranchNumber,
    required this.nextCustomerNumber,
  });

  factory NumberCounters.fromJson(Map<String, dynamic> json) => _$NumberCountersFromJson(json);
  Map<String, dynamic> toJson() => _$NumberCountersToJson(this);

  factory NumberCounters.empty() {
    return const NumberCounters(
      id: '',
      nextOfferNumber: 1001,
      nextAppointmentNumber: 2001,
      nextInvoiceNumber: 3001,
      nextIncomingInvoiceNumber: 4001,
      nextBranchNumber: 2,
      nextCustomerNumber: 1001,
    );
  }

  NumberCounters copyWith({
    String? id,
    int? nextOfferNumber,
    int? nextAppointmentNumber,
    int? nextInvoiceNumber,
    int? nextIncomingInvoiceNumber,
    int? nextBranchNumber,
    int? nextCustomerNumber,
  }) {
    return NumberCounters(
      id: id ?? this.id,
      nextOfferNumber: nextOfferNumber ?? this.nextOfferNumber,
      nextAppointmentNumber: nextAppointmentNumber ?? this.nextAppointmentNumber,
      nextInvoiceNumber: nextInvoiceNumber ?? this.nextInvoiceNumber,
      nextIncomingInvoiceNumber: nextIncomingInvoiceNumber ?? this.nextIncomingInvoiceNumber,
      nextBranchNumber: nextBranchNumber ?? this.nextBranchNumber,
      nextCustomerNumber: nextCustomerNumber ?? this.nextCustomerNumber,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
