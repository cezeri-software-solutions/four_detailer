import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'address.dart';

part 'branch.g.dart';

enum ServiceType { stationary, mobile, both }

@JsonSerializable(explicitToJson: true)
class Branch extends Equatable {
  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(name: 'branch_number')
  final int branchNumber;
  @JsonKey(name: 'branch_name')
  final String branchName;
  @JsonKey(name: 'tel_one')
  final String tel1;
  @JsonKey(name: 'tel_two')
  final String tel2;
  final String email;
  final Address address;
  @JsonKey(name: 'branch_logo')
  final String? branchLogo;
  final String? homepage;
  @JsonKey(name: 'uid_number')
  final String? uidNumber;
  @JsonKey(name: 'district_court')
  final String? districtCourt; // Amtsgericht
  @JsonKey(name: 'commercial_register')
  final String? commercialRegister; // Handelsregister
  @JsonKey(name: 'is_main_branch')
  final bool isMainBranch;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'service_type')
  final ServiceType serviceType;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Branch({
    required this.id,
    required this.ownerId,
    required this.branchNumber,
    required this.branchName,
    required this.tel1,
    required this.tel2,
    required this.email,
    required this.address,
    required this.branchLogo,
    required this.homepage,
    required this.uidNumber,
    required this.districtCourt,
    required this.commercialRegister,
    required this.isMainBranch,
    required this.isActive,
    required this.serviceType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
  Map<String, dynamic> toJson() => _$BranchToJson(this);

  factory Branch.empty() {
    return Branch(
      id: '',
      ownerId: '',
      branchNumber: 0,
      branchName: '',
      tel1: '',
      tel2: '',
      email: '',
      address: Address.empty(),
      branchLogo: '',
      homepage: '',
      uidNumber: '',
      districtCourt: '',
      commercialRegister: '',
      isMainBranch: false,
      isActive: true,
      serviceType: ServiceType.stationary,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Branch copyWith({
    String? id,
    String? ownerId,
    int? branchNumber,
    String? branchName,
    String? tel1,
    String? tel2,
    String? email,
    Address? address,
    String? branchLogo,
    String? homepage,
    String? uidNumber,
    String? districtCourt,
    String? commercialRegister,
    bool? isMainBranch,
    bool? isActive,
    ServiceType? serviceType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Branch(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      branchNumber: branchNumber ?? this.branchNumber,
      branchName: branchName ?? this.branchName,
      tel1: tel1 ?? this.tel1,
      tel2: tel2 ?? this.tel2,
      email: email ?? this.email,
      address: address ?? this.address,
      branchLogo: branchLogo ?? this.branchLogo,
      homepage: homepage ?? this.homepage,
      uidNumber: uidNumber ?? this.uidNumber,
      districtCourt: districtCourt ?? this.districtCourt,
      commercialRegister: commercialRegister ?? this.commercialRegister,
      isMainBranch: isMainBranch ?? this.isMainBranch,
      isActive: isActive ?? this.isActive,
      serviceType: serviceType ?? this.serviceType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
