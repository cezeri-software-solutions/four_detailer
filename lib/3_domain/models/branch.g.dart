// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Branch _$BranchFromJson(Map<String, dynamic> json) => Branch(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      branchNumber: (json['branch_number'] as num).toInt(),
      branchName: json['branch_name'] as String,
      tel1: json['tel_one'] as String,
      tel2: json['tel_two'] as String,
      email: json['email'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      branchLogo: json['branch_logo'] as String?,
      homepage: json['homepage'] as String?,
      uidNumber: json['uid_number'] as String?,
      districtCourt: json['district_court'] as String?,
      commercialRegister: json['commercial_register'] as String?,
      isMainBranch: json['is_main_branch'] as bool,
      isActive: json['is_active'] as bool,
      serviceType: $enumDecode(_$ServiceTypeEnumMap, json['service_type']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'branch_number': instance.branchNumber,
      'branch_name': instance.branchName,
      'tel_one': instance.tel1,
      'tel_two': instance.tel2,
      'email': instance.email,
      'address': instance.address.toJson(),
      'branch_logo': instance.branchLogo,
      'homepage': instance.homepage,
      'uid_number': instance.uidNumber,
      'district_court': instance.districtCourt,
      'commercial_register': instance.commercialRegister,
      'is_main_branch': instance.isMainBranch,
      'is_active': instance.isActive,
      'service_type': _$ServiceTypeEnumMap[instance.serviceType]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ServiceTypeEnumMap = {
  ServiceType.stationary: 'stationary',
  ServiceType.mobile: 'mobile',
  ServiceType.both: 'both',
};
