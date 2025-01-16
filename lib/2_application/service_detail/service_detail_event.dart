part of 'service_detail_bloc.dart';

@immutable
sealed class ServiceDetailEvent {}

class SetServiceDetailStateToInitialEvent extends ServiceDetailEvent {}

class SetEmptyServiceOnCreateEvent extends ServiceDetailEvent {
  final BuildContext context;

  SetEmptyServiceOnCreateEvent({required this.context});
}

class GetCurrentServiceEvent extends ServiceDetailEvent {
  final String serviceId;

  GetCurrentServiceEvent({required this.serviceId});
}

class CreateServiceEvent extends ServiceDetailEvent {}

class SaveServiceEvent extends ServiceDetailEvent {}

class EditServiceEvent extends ServiceDetailEvent {
  final Service service;

  EditServiceEvent({required this.service});
}

class OnNetPriceChangedEvent extends ServiceDetailEvent {}

class OnGrossPriceChangedEvent extends ServiceDetailEvent {}

class AddNewServiceSmartItemEvent extends ServiceDetailEvent {
  final ServiceSmartItem serviceSmartItem;

  AddNewServiceSmartItemEvent({required this.serviceSmartItem});
}

class AddServiceSmartItemsFromTemplateEvent extends ServiceDetailEvent {
  final List<ServiceSmartItem> serviceSmartItems;

  AddServiceSmartItemsFromTemplateEvent({required this.serviceSmartItems});
}

class EditServiceSmartItemEvent extends ServiceDetailEvent {
  final ServiceSmartItem serviceSmartItem;
  final int index;

  EditServiceSmartItemEvent({required this.serviceSmartItem, required this.index});
}

class RemoveServiceSmartItemEvent extends ServiceDetailEvent {
  final ServiceSmartItem serviceSmartItem;
  final int index;

  RemoveServiceSmartItemEvent({required this.serviceSmartItem, required this.index});
}

class AddNewServiceTodoEvent extends ServiceDetailEvent {
  final ServiceTodo serviceTodo;

  AddNewServiceTodoEvent({required this.serviceTodo});
}

class AddServiceTodosFromTemplateEvent extends ServiceDetailEvent {
  final List<ServiceTodo> serviceTodos;

  AddServiceTodosFromTemplateEvent({required this.serviceTodos});
}

class EditServiceTodoEvent extends ServiceDetailEvent {
  final ServiceTodo serviceTodo;
  final int index;

  EditServiceTodoEvent({required this.serviceTodo, required this.index});
}

class RemoveServiceTodoEvent extends ServiceDetailEvent {
  final ServiceTodo serviceTodo;
  final int index;

  RemoveServiceTodoEvent({required this.serviceTodo, required this.index});
}

class OnServiceCategorySelectedEvent extends ServiceDetailEvent {
  final Category? category;

  OnServiceCategorySelectedEvent({required this.category});
}

class ResetServiceCategoryEvent extends ServiceDetailEvent {}

class UpdateServiceSmartItemPositionsEvent extends ServiceDetailEvent {
  final ServiceSmartItemType type;
  final int newIndex;
  final int oldIndex;

  UpdateServiceSmartItemPositionsEvent({required this.type, required this.newIndex, required this.oldIndex});
}

class UpdateServiceTodoPositionsEvent extends ServiceDetailEvent {
  final int newIndex;
  final int oldIndex;

  UpdateServiceTodoPositionsEvent({required this.newIndex, required this.oldIndex});
}
