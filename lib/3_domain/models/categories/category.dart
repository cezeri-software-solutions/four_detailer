import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category extends Equatable {
  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(name: 'branch_id')
  final String branchId;
  final String title;
  final String description;
  final int position;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', includeToJson: false)
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.ownerId,
    required this.branchId,
    required this.title,
    required this.description,
    required this.position,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  factory Category.empty() {
    return Category(
      id: '',
      ownerId: '',
      branchId: '',
      title: '',
      description: '',
      position: 0,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Category copyWith({
    String? id,
    String? ownerId,
    String? branchId,
    String? title,
    String? description,
    int? position,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      branchId: branchId ?? this.branchId,
      title: title ?? this.title,
      description: description ?? this.description,
      position: position ?? this.position,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, position];

  @override
  bool get stringify => true;
}
