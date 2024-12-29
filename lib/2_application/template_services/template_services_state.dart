// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'template_services_bloc.dart';

@immutable
class TemplateServicesState {
  final TemplateServiceType templateServiceType;
  final List<TemplateService>? listOfTemplateServices;
  final AbstractFailure? failure;
  final bool isLoadingTemplateServicesOnObserve;
  final bool isLoadingTemplateServiceItemsOnObserve;
  final bool isLoadingTemplateServicesOnCreate;
  final bool isLoadingTemplateServiceItemsOnCreate;
  final bool isLoadingTemplateServicesOnUpdate;
  final bool isLoadingTemplateServiceItemsOnUpdate;
  final bool isLoadingTemplateServicesOnDelete;
  final bool isLoadingTemplateServiceItemsOnDelete;
  final Option<Either<AbstractFailure, List<TemplateService>>> fosTemplateServicesOnObserveOption;
  final Option<Either<AbstractFailure, dynamic>> fosTemplateServicesOnCreateOption;
  final Option<Either<AbstractFailure, dynamic>> fosTemplateServicesOnUpdateOption;
  final Option<Either<AbstractFailure, Unit>> fosTemplateServicesOnDeleteOption;

  const TemplateServicesState({
    required this.templateServiceType,
    required this.listOfTemplateServices,
    required this.failure,
    required this.isLoadingTemplateServicesOnObserve,
    required this.isLoadingTemplateServiceItemsOnObserve,
    required this.isLoadingTemplateServicesOnCreate,
    required this.isLoadingTemplateServiceItemsOnCreate,
    required this.isLoadingTemplateServicesOnUpdate,
    required this.isLoadingTemplateServiceItemsOnUpdate,
    required this.isLoadingTemplateServicesOnDelete,
    required this.isLoadingTemplateServiceItemsOnDelete,
    required this.fosTemplateServicesOnObserveOption,
    required this.fosTemplateServicesOnCreateOption,
    required this.fosTemplateServicesOnUpdateOption,
    required this.fosTemplateServicesOnDeleteOption,
  });

  factory TemplateServicesState.initial() => TemplateServicesState(
        templateServiceType: TemplateServiceType.vehicleSize,
        listOfTemplateServices: null,
        failure: null,
        isLoadingTemplateServicesOnObserve: true,
        isLoadingTemplateServiceItemsOnObserve: false,
        isLoadingTemplateServicesOnCreate: false,
        isLoadingTemplateServiceItemsOnCreate: false,
        isLoadingTemplateServicesOnUpdate: false,
        isLoadingTemplateServiceItemsOnUpdate: false,
        isLoadingTemplateServicesOnDelete: false,
        isLoadingTemplateServiceItemsOnDelete: false,
        fosTemplateServicesOnObserveOption: none(),
        fosTemplateServicesOnCreateOption: none(),
        fosTemplateServicesOnUpdateOption: none(),
        fosTemplateServicesOnDeleteOption: none(),
      );

  TemplateServicesState copyWith({
    TemplateServiceType? templateServiceType,
    List<TemplateService>? listOfTemplateServices,
    bool? resetFailure,
    AbstractFailure? failure,
    bool? isLoadingTemplateServicesOnObserve,
    bool? isLoadingTemplateServiceItemsOnObserve,
    bool? isLoadingTemplateServicesOnCreate,
    bool? isLoadingTemplateServiceItemsOnCreate,
    bool? isLoadingTemplateServicesOnUpdate,
    bool? isLoadingTemplateServiceItemsOnUpdate,
    bool? isLoadingTemplateServicesOnDelete,
    bool? isLoadingTemplateServiceItemsOnDelete,
    Option<Either<AbstractFailure, List<TemplateService>>>? fosTemplateServicesOnObserveOption,
    Option<Either<AbstractFailure, dynamic>>? fosTemplateServicesOnCreateOption,
    Option<Either<AbstractFailure, dynamic>>? fosTemplateServicesOnUpdateOption,
    Option<Either<AbstractFailure, Unit>>? fosTemplateServicesOnDeleteOption,
  }) {
    return TemplateServicesState(
      templateServiceType: templateServiceType ?? this.templateServiceType,
      listOfTemplateServices: listOfTemplateServices ?? this.listOfTemplateServices,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingTemplateServicesOnObserve: isLoadingTemplateServicesOnObserve ?? this.isLoadingTemplateServicesOnObserve,
      isLoadingTemplateServiceItemsOnObserve: isLoadingTemplateServiceItemsOnObserve ?? this.isLoadingTemplateServiceItemsOnObserve,
      isLoadingTemplateServicesOnCreate: isLoadingTemplateServicesOnCreate ?? this.isLoadingTemplateServicesOnCreate,
      isLoadingTemplateServiceItemsOnCreate: isLoadingTemplateServiceItemsOnCreate ?? this.isLoadingTemplateServiceItemsOnCreate,
      isLoadingTemplateServicesOnUpdate: isLoadingTemplateServicesOnUpdate ?? this.isLoadingTemplateServicesOnUpdate,
      isLoadingTemplateServiceItemsOnUpdate: isLoadingTemplateServiceItemsOnUpdate ?? this.isLoadingTemplateServiceItemsOnUpdate,
      isLoadingTemplateServicesOnDelete: isLoadingTemplateServicesOnDelete ?? this.isLoadingTemplateServicesOnDelete,
      isLoadingTemplateServiceItemsOnDelete: isLoadingTemplateServiceItemsOnDelete ?? this.isLoadingTemplateServiceItemsOnDelete,
      fosTemplateServicesOnObserveOption: fosTemplateServicesOnObserveOption ?? this.fosTemplateServicesOnObserveOption,
      fosTemplateServicesOnCreateOption: fosTemplateServicesOnCreateOption ?? this.fosTemplateServicesOnCreateOption,
      fosTemplateServicesOnUpdateOption: fosTemplateServicesOnUpdateOption ?? this.fosTemplateServicesOnUpdateOption,
      fosTemplateServicesOnDeleteOption: fosTemplateServicesOnDeleteOption ?? this.fosTemplateServicesOnDeleteOption,
    );
  }
}
