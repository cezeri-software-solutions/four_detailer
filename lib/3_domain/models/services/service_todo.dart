import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models.dart';

part 'service_todo.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceTodo extends Equatable {
  final String id;
  @JsonKey(name: 'service_id')
  final String serviceId;
  final String name;
  final String description;
  final int position;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', includeToJson: false)
  final DateTime updatedAt;
  @JsonKey(name: 'entity_state', includeFromJson: false, includeToJson: true)
  final EntityState entityState;

  const ServiceTodo({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.description,
    required this.position,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.entityState = EntityState.none,
  });

  factory ServiceTodo.fromJson(Map<String, dynamic> json) {
    final serviceTodo = _$ServiceTodoFromJson(json);
    return serviceTodo.copyWith(entityState: EntityState.none);
  }
  Map<String, dynamic> toJson() => _$ServiceTodoToJson(this);

  factory ServiceTodo.empty() {
    return ServiceTodo(
        id: '',
        serviceId: '',
        name: '',
        description: '',
        position: 0,
        isDeleted: false,
        entityState: EntityState.none,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
  }

  ServiceTodo copyWith({
    String? id,
    String? serviceId,
    String? name,
    String? description,
    int? position,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    EntityState? entityState,
  }) {
    return ServiceTodo(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      name: name ?? this.name,
      description: description ?? this.description,
      position: position ?? this.position,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      entityState: entityState ?? this.entityState,
    );
  }

  @override
  List<Object?> get props => [id, serviceId, name, description, position, isDeleted];

  @override
  bool get stringify => true;
}
