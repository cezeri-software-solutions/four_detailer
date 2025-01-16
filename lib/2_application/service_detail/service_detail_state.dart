part of 'service_detail_bloc.dart';

@immutable
class ServiceDetailState {
  final Service? service;
  final AbstractFailure? failure;
  final bool isLoadingServiceOnObserve;
  final bool isLoadingServiceOnCreate;
  final bool isLoadingServiceOnUpdate;
  final bool isLoadingServiceOnDelete;
  final Option<Either<AbstractFailure, Service>> fosServiceOnObserveOption;
  final Option<Either<AbstractFailure, Service>> fosServiceOnCreateOption;
  final Option<Either<AbstractFailure, Service>> fosServiceOnUpdateOption;
  final Option<Either<AbstractFailure, Unit>> fosServiceOnDeleteOption;

  //* Helpers
  final TextEditingController netPriceController;
  final TextEditingController grossPriceController;

  const ServiceDetailState({
    required this.service,
    required this.failure,
    required this.isLoadingServiceOnObserve,
    required this.isLoadingServiceOnCreate,
    required this.isLoadingServiceOnUpdate,
    required this.isLoadingServiceOnDelete,
    required this.fosServiceOnObserveOption,
    required this.fosServiceOnCreateOption,
    required this.fosServiceOnUpdateOption,
    required this.fosServiceOnDeleteOption,
    required this.netPriceController,
    required this.grossPriceController,
  });

  factory ServiceDetailState.initial() => ServiceDetailState(
        service: null,
        failure: null,
        isLoadingServiceOnObserve: false,
        isLoadingServiceOnCreate: false,
        isLoadingServiceOnUpdate: false,
        isLoadingServiceOnDelete: false,
        fosServiceOnObserveOption: none(),
        fosServiceOnCreateOption: none(),
        fosServiceOnUpdateOption: none(),
        fosServiceOnDeleteOption: none(),
        netPriceController: TextEditingController(text: '0.00'),
        grossPriceController: TextEditingController(text: '0.00'),
      );

  ServiceDetailState copyWith({
    Service? service,
    bool? resetFailure,
    AbstractFailure? failure,
    bool? isLoadingServiceOnObserve,
    bool? isLoadingServiceOnCreate,
    bool? isLoadingServiceOnUpdate,
    bool? isLoadingServiceOnDelete,
    Option<Either<AbstractFailure, Service>>? fosServiceOnObserveOption,
    Option<Either<AbstractFailure, Service>>? fosServiceOnCreateOption,
    Option<Either<AbstractFailure, Service>>? fosServiceOnUpdateOption,
    Option<Either<AbstractFailure, Unit>>? fosServiceOnDeleteOption,
    TextEditingController? netPriceController,
    TextEditingController? grossPriceController,
  }) {
    return ServiceDetailState(
      service: service ?? this.service,
      failure: resetFailure != null ? null : failure ?? this.failure,
      isLoadingServiceOnObserve: isLoadingServiceOnObserve ?? this.isLoadingServiceOnObserve,
      isLoadingServiceOnCreate: isLoadingServiceOnCreate ?? this.isLoadingServiceOnCreate,
      isLoadingServiceOnUpdate: isLoadingServiceOnUpdate ?? this.isLoadingServiceOnUpdate,
      isLoadingServiceOnDelete: isLoadingServiceOnDelete ?? this.isLoadingServiceOnDelete,
      fosServiceOnObserveOption: fosServiceOnObserveOption ?? this.fosServiceOnObserveOption,
      fosServiceOnCreateOption: fosServiceOnCreateOption ?? this.fosServiceOnCreateOption,
      fosServiceOnUpdateOption: fosServiceOnUpdateOption ?? this.fosServiceOnUpdateOption,
      fosServiceOnDeleteOption: fosServiceOnDeleteOption ?? this.fosServiceOnDeleteOption,
      netPriceController: netPriceController ?? this.netPriceController,
      grossPriceController: grossPriceController ?? this.grossPriceController,
    );
  }
}
