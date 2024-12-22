import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:four_detailer/core/extensions/context_extensions.dart';
import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'conditioner.g.dart';

enum ConditionerType { admin, owner, employee }

enum EmployeeType {
  @JsonValue('co_owner')
  coOwner,
  @JsonValue('office')
  office,
  @JsonValue('processor')
  processor,
}

@JsonSerializable(explicitToJson: true)
class Conditioner extends Equatable {
  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(name: 'conditioner_payment')
  final ConditionerPayment conditionerPayment;
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
  @JsonKey(name: 'conditioner_type')
  final ConditionerType conditionerTyp;
  @JsonKey(name: 'employee_type')
  final EmployeeType employeeType;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', includeToJson: false)
  final DateTime updatedAt;

  Conditioner({
    required this.id,
    required this.ownerId,
    required this.conditionerPayment,
    required this.imageUrl,
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.tel1,
    required this.tel2,
    required this.conditionerTyp,
    required this.employeeType,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  }) : name = _createName(firstName, lastName);

  static String _createName(String firstName, String lastName) {
    final names = [firstName, lastName].where((element) => element.isNotEmpty);

    if (names.isEmpty) return '';
    return names.join(' ');
  }

  factory Conditioner.fromJson(Map<String, dynamic> json) => _$ConditionerFromJson(json);
  Map<String, dynamic> toJson() => _$ConditionerToJson(this);

  factory Conditioner.empty() {
    return Conditioner(
      id: '',
      ownerId: '',
      conditionerPayment: ConditionerPayment.empty(),
      imageUrl: '',
      gender: Gender.empty,
      firstName: '',
      lastName: '',
      email: '',
      address: Address.empty(),
      tel1: '',
      tel2: '',
      conditionerTyp: ConditionerType.employee,
      employeeType: EmployeeType.coOwner,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Conditioner copyWith({
    String? id,
    String? ownerId,
    ConditionerPayment? conditionerPayment,
    String? imageUrl,
    Gender? gender,
    String? firstName,
    String? lastName,
    String? email,
    Address? address,
    String? tel1,
    String? tel2,
    ConditionerType? conditionerTyp,
    EmployeeType? employeeType,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conditioner(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      conditionerPayment: conditionerPayment ?? this.conditionerPayment,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      address: address ?? this.address,
      tel1: tel1 ?? this.tel1,
      tel2: tel2 ?? this.tel2,
      conditionerTyp: conditionerTyp ?? this.conditionerTyp,
      employeeType: employeeType ?? this.employeeType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}

extension ConvertGenderToString on Gender {
  String convert(BuildContext context) {
    return switch (this) {
      Gender.empty => '',
      Gender.male => context.l10n.gender_male,
      Gender.female => context.l10n.gender_female,
    };
  }
}
