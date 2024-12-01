import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models.dart';

part 'transaction.g.dart';

enum TransactionType { income, expense }

@JsonSerializable(explicitToJson: true)
class Transaction extends Equatable {
  final String id;
  @JsonKey(name: 'transaction_type')
  final TransactionType transactionType;
  @JsonKey(name: 'cash_register_id')
  final String cashRegisterId;
  @JsonKey(name: 'cash_register')
  final CashRegister? cashRegister; // Falls ich den CashRegister mitladen will
  @JsonKey(name: 'payment_method')
  final PaymentMethod paymentMethod;
  final double amount;
  final String description;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.transactionType,
    required this.cashRegisterId,
    required this.cashRegister,
    required this.paymentMethod,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  factory Transaction.empty() {
    return Transaction(
      id: '',
      transactionType: TransactionType.income,
      cashRegisterId: '',
      cashRegister: null,
      paymentMethod: PaymentMethod.empty(),
      amount: 0.0,
      description: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Transaction copyWith({
    String? id,
    TransactionType? transactionType,
    String? cashRegisterId,
    CashRegister? cashRegister,
    PaymentMethod? paymentMethod,
    double? amount,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      transactionType: transactionType ?? this.transactionType,
      cashRegisterId: cashRegisterId ?? this.cashRegisterId,
      cashRegister: cashRegister ?? this.cashRegister,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
