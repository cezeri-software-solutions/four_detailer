// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditioner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conditioner _$ConditionerFromJson(Map<String, dynamic> json) => Conditioner(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      conditionerPayment: ConditionerPayment.fromJson(json['conditioner_payment'] as Map<String, dynamic>),
      imageUrl: json['image_url'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      tel1: json['tel_one'] as String,
      tel2: json['tel_two'] as String,
      conditionerTyp: $enumDecode(_$ConditionerTypeEnumMap, json['conditioner_type']),
      employeeType: $enumDecode(_$EmployeeTypeEnumMap, json['employee_type']),
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ConditionerToJson(Conditioner instance) => <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'conditioner_payment': instance.conditionerPayment.toJson(),
      'image_url': instance.imageUrl,
      'gender': _$GenderEnumMap[instance.gender]!,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'address': instance.address.toJson(),
      'tel_one': instance.tel1,
      'tel_two': instance.tel2,
      'conditioner_type': _$ConditionerTypeEnumMap[instance.conditionerTyp]!,
      'employee_type': _$EmployeeTypeEnumMap[instance.employeeType]!,
      'is_active': instance.isActive,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.empty: 'empty',
};

const _$ConditionerTypeEnumMap = {
  ConditionerType.admin: 'admin',
  ConditionerType.owner: 'owner',
  ConditionerType.employee: 'employee',
};

const _$EmployeeTypeEnumMap = {
  EmployeeType.coOwner: 'co_owner',
  EmployeeType.office: 'office',
  EmployeeType.processor: 'processor',
};
