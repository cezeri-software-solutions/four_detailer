import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'template_service.g.dart';

enum TemplateServiceType {
  @JsonValue('vehicle_size')
  vehicleSize,
  @JsonValue('contamination_level')
  contaminationLevel,
  @JsonValue('todo')
  todo,
}

@JsonSerializable(explicitToJson: true)
class TemplateService extends Equatable {
  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(name: 'branch_id')
  final String branchId;
  final String name;
  final String description;
  final int position;
  final TemplateServiceType type;
  final List<TemplateServiceItem>? items;
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', includeToJson: false)
  final DateTime updatedAt;

  const TemplateService({
    required this.id,
    required this.ownerId,
    required this.branchId,
    required this.name,
    required this.description,
    required this.position,
    required this.type,
    this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TemplateService.fromJson(Map<String, dynamic> json) => _$TemplateServiceFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateServiceToJson(this);

  factory TemplateService.empty() {
    return TemplateService(
      id: '',
      ownerId: '',
      branchId: '',
      name: '',
      description: '',
      position: 0,
      type: TemplateServiceType.todo,
      items: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  TemplateService copyWith({
    String? id,
    String? ownerId,
    String? branchId,
    String? name,
    String? description,
    int? position,
    TemplateServiceType? type,
    List<TemplateServiceItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TemplateService(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      description: description ?? this.description,
      position: position ?? this.position,
      type: type ?? this.type,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, type, items, position];

  @override
  bool get stringify => true;
}

@JsonSerializable(explicitToJson: true)
class TemplateServiceItem extends Equatable {
  final String id;
  @JsonKey(name: 'template_service_id')
  final String templateServiceId;
  final String name;
  final String description;
  final int position;

  const TemplateServiceItem({
    required this.id,
    required this.templateServiceId,
    required this.name,
    required this.description,
    required this.position,
  });

  factory TemplateServiceItem.fromJson(Map<String, dynamic> json) => _$TemplateServiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateServiceItemToJson(this);

  factory TemplateServiceItem.empty() {
    return const TemplateServiceItem(
      id: '',
      templateServiceId: '',
      name: '',
      description: '',
      position: 0,
    );
  }

  TemplateServiceItem copyWith({
    String? id,
    String? templateServiceId,
    String? name,
    String? description,
    int? position,
  }) {
    return TemplateServiceItem(
      id: id ?? this.id,
      templateServiceId: templateServiceId ?? this.templateServiceId,
      name: name ?? this.name,
      description: description ?? this.description,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [id, templateServiceId, name, description, position];

  @override
  bool get stringify => true;
}

extension ConvertTemplateServiceTypeStringToEnum on String {
  TemplateServiceType toEnumTST() {
    return switch (this) {
      'vehicleSize' => TemplateServiceType.vehicleSize,
      'contaminationLevel' => TemplateServiceType.contaminationLevel,
      'todo' => TemplateServiceType.todo,
      _ => TemplateServiceType.todo,
    };
  }
}

extension ConvertTemplateServiceTypeStringToJsonString on TemplateServiceType {
  String toJsonString() {
    return switch (this) {
      TemplateServiceType.vehicleSize => 'vehicle_size',
      TemplateServiceType.contaminationLevel => 'contamination_level',
      TemplateServiceType.todo => 'todo',
    };
  }
}
