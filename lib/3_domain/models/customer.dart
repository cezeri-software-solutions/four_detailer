import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import '/core/core.dart';
import 'models.dart';

part 'customer.g.dart';

enum CustomerStatus {
  @JsonValue('prospect')
  prospect, //* Interessent
  @JsonValue('customer')
  customer, //* Kunden
}

enum CustomerType {
  @JsonValue('private')
  private,
  @JsonValue('business')
  business,
}

@JsonSerializable(explicitToJson: true)
class Customer extends Equatable {
  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(name: 'customer_number')
  final int customerNumber;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final Gender gender;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String name;
  final String email;
  final Address address;
  @JsonKey(name: 'tel_one')
  final String tel1;
  @JsonKey(name: 'tel_two')
  final String tel2;
  @JsonKey(name: 'customer_status')
  final CustomerStatus customerStatus;
  @JsonKey(name: 'customer_type')
  final CustomerType customerType;
  @JsonKey(name: 'company_name')
  final String companyName;
  @JsonKey(name: 'tax_number')
  final String taxNumber;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @JsonKey(name: 'vehicles')
  final List<Vehicle>? vehicles;
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', includeToJson: false)
  final DateTime updatedAt;

  Customer({
    required this.id,
    required this.ownerId,
    required this.customerNumber,
    required this.imageUrl,
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.tel1,
    required this.tel2,
    required this.customerStatus,
    required this.customerType,
    required this.companyName,
    required this.taxNumber,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.vehicles,
  }) : name = _createName(firstName, lastName);

  static String _createName(String firstName, String lastName) {
    final names = [firstName, lastName].where((element) => element.isNotEmpty);

    if (names.isEmpty) return '';
    return names.join(' ');
  }

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  factory Customer.empty() {
    return Customer(
      id: '',
      ownerId: '',
      customerNumber: 1,
      imageUrl: '',
      gender: Gender.empty,
      firstName: '',
      lastName: '',
      email: '',
      address: Address.empty(),
      tel1: '',
      tel2: '',
      customerStatus: CustomerStatus.customer,
      customerType: CustomerType.private,
      companyName: '',
      taxNumber: '',
      isActive: true,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Customer copyWith({
    String? id,
    String? ownerId,
    int? customerNumber,
    String? imageUrl,
    Gender? gender,
    String? firstName,
    String? lastName,
    String? email,
    Address? address,
    String? tel1,
    String? tel2,
    CustomerStatus? customerStatus,
    CustomerType? customerType,
    String? companyName,
    String? taxNumber,
    bool? isActive,
    bool? isDeleted,
    List<Vehicle>? vehicles,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      customerNumber: customerNumber ?? this.customerNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      address: address ?? this.address,
      tel1: tel1 ?? this.tel1,
      tel2: tel2 ?? this.tel2,
      customerStatus: customerStatus ?? this.customerStatus,
      customerType: customerType ?? this.customerType,
      companyName: companyName ?? this.companyName,
      taxNumber: taxNumber ?? this.taxNumber,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      vehicles: vehicles ?? this.vehicles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}

extension ConvertCustomerStatusToString on CustomerStatus {
  String convert(BuildContext context) {
    return switch (this) {
      CustomerStatus.prospect => context.l10n.enum_customerStatus_prospect,
      CustomerStatus.customer => context.l10n.enum_customerStatus_customer,
    };
  }
}

extension ConvertCustomerTypeToString on CustomerType {
  String convert(BuildContext context) {
    return switch (this) {
      CustomerType.private => context.l10n.enum_customerType_private,
      CustomerType.business => context.l10n.enum_customerType_business,
    };
  }
}
