import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_vehicle_size.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryVehicleSize extends Equatable {
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

  const CategoryVehicleSize({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.position,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryVehicleSize.fromJson(Map<String, dynamic> json) => _$CategoryVehicleSizeFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryVehicleSizeToJson(this);

  factory CategoryVehicleSize.empty() {
    return CategoryVehicleSize(
      id: '',
      categoryId: '',
      name: '',
      position: 0,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  CategoryVehicleSize copyWith({
    String? id,
    String? categoryId,
    String? name,
    int? position,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryVehicleSize(
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
