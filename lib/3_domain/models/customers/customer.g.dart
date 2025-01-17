// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      customerNumber: (json['customer_number'] as num).toInt(),
      imageUrl: json['image_url'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      tel1: json['tel_one'] as String,
      tel2: json['tel_two'] as String,
      customerStatus: $enumDecode(_$CustomerStatusEnumMap, json['customer_status']),
      customerType: $enumDecode(_$CustomerTypeEnumMap, json['customer_type']),
      companyName: json['company_name'] as String,
      taxNumber: json['tax_number'] as String,
      isActive: json['is_active'] as bool,
      isDeleted: json['is_deleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      vehicles: (json['vehicles'] as List<dynamic>?)?.map((e) => Vehicle.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'customer_number': instance.customerNumber,
      'image_url': instance.imageUrl,
      'gender': _$GenderEnumMap[instance.gender]!,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'address': instance.address.toJson(),
      'tel_one': instance.tel1,
      'tel_two': instance.tel2,
      'customer_status': _$CustomerStatusEnumMap[instance.customerStatus]!,
      'customer_type': _$CustomerTypeEnumMap[instance.customerType]!,
      'company_name': instance.companyName,
      'tax_number': instance.taxNumber,
      'is_active': instance.isActive,
      'is_deleted': instance.isDeleted,
      'vehicles': instance.vehicles?.map((e) => e.toJson()).toList(),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.empty: 'empty',
};

const _$CustomerStatusEnumMap = {
  CustomerStatus.prospect: 'prospect',
  CustomerStatus.customer: 'customer',
};

const _$CustomerTypeEnumMap = {
  CustomerType.private: 'private',
  CustomerType.business: 'business',
};
