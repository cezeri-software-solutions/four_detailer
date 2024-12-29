import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_contamination_level.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryContaminationLevel extends Equatable {
  final String id;
  @JsonKey(name: 'category_id')
  final String categoryId;
  final String name;
  final int position;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', includeToJson: false)
  final DateTime updatedAt;

  const CategoryContaminationLevel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.position,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryContaminationLevel.fromJson(Map<String, dynamic> json) =>
      _$CategoryContaminationLevelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryContaminationLevelToJson(this);

  factory CategoryContaminationLevel.empty() {
    return CategoryContaminationLevel(
      id: '',
      categoryId: '',
      name: '',
      position: 0,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  CategoryContaminationLevel copyWith({
    String? id,
    String? categoryId,
    String? name,
    int? position,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryContaminationLevel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      position: position ?? this.position,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
} 