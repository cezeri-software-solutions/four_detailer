part of 'customer_detail_bloc.dart';

@immutable
class CustomerDetailState {
  final Customer? customer;
  final AbstractFailure? failure;
  final bool isLoadingCustomerOnCreate;
  final bool isLoadingCustomerOnObserve;
  final bool isLoadingCustomerOnUpdate;
  final Option<Either<AbstractFailure, Customer>> fosCustomerOnCreateOption;
  final Option<Either<AbstractFailure, Customer>> fosCustomerOnObserveOption;
  final Option<Either<AbstractFailure, Customer>> fosCustomerOnUpdateOption;
  //* Helper
  final bool showImageEditing;
  final bool isInEditMode;
  final bool isInPaymentEditMode;

  //* Add Edit Vehicle
  final Vehicle? vehicle;
  final int? vehicleIndex;
  final bool showAddEditVehicleContainer;

  const CustomerDetailState({
    required this.customer,
    required this.failure,
    required this.isLoadingCustomerOnCreate,
    required this.isLoadingCustomerOnObserve,
    required this.isLoadingCustomerOnUpdate,
    required this.fosCustomerOnCreateOption,
    required this.fosCustomerOnObserveOption,
    required this.fosCustomerOnUpdateOption,
    required this.showImageEditing,
    required this.isInEditMode,
    required this.isInPaymentEditMode,
    required this.vehicle,
    required this.vehicleIndex,
    required this.showAddEditVehicleContainer,
  });

  factory CustomerDetailState.initial() => CustomerDetailState(
        customer: null,
        failure: null,
        isLoadingCustomerOnObserve: false,
        isLoadingCustomerOnUpdate: false,
        isLoadingCustomerOnCreate: false,
        fosCustomerOnObserveOption: none(),
        fosCustomerOnUpdateOption: none(),
        fosCustomerOnCreateOption: none(),
        showImageEditing: false,
        isInEditMode: false,
        isInPaymentEditMode: false,
        vehicle: null,
        vehicleIndex: null,
        showAddEditVehicleContainer: false,
      );

  CustomerDetailState copyWith({
    Customer? customer,
    AbstractFailure? failure,
    bool? resetFailure,
    bool? isLoadingCustomerOnObserve,
    bool? isLoadingCustomerOnUpdate,
    bool? isLoadingCustomerOnCreate,
    Option<Either<AbstractFailure, Customer>>? fosCustomerOnObserveOption,
    Option<Either<AbstractFailure, Customer>>? fosCustomerOnUpdateOption,
    Option<Either<AbstractFailure, Customer>>? fosCustomerOnCreateOption,
    bool? showImageEditing,
    bool? isInEditMode,
    bool? isInPaymentEditMode,
    bool? resetEditVehicle,
    Vehicle? vehicle,
    int? vehicleIndex,
    bool? showAddEditVehicleContainer,
  }) {
    return CustomerDetailState(
      customer: customer ?? this.customer,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingCustomerOnObserve: isLoadingCustomerOnObserve ?? this.isLoadingCustomerOnObserve,
      isLoadingCustomerOnUpdate: isLoadingCustomerOnUpdate ?? this.isLoadingCustomerOnUpdate,
      isLoadingCustomerOnCreate: isLoadingCustomerOnCreate ?? this.isLoadingCustomerOnCreate,
      fosCustomerOnObserveOption: fosCustomerOnObserveOption ?? this.fosCustomerOnObserveOption,
      fosCustomerOnUpdateOption: fosCustomerOnUpdateOption ?? this.fosCustomerOnUpdateOption,
      fosCustomerOnCreateOption: fosCustomerOnCreateOption ?? this.fosCustomerOnCreateOption,
      showImageEditing: showImageEditing ?? this.showImageEditing,
      isInEditMode: isInEditMode ?? this.isInEditMode,
      isInPaymentEditMode: isInPaymentEditMode ?? this.isInPaymentEditMode,
      vehicle: resetEditVehicle == true ? null : vehicle ?? this.vehicle,
      vehicleIndex: resetEditVehicle == true ? null : vehicleIndex ?? this.vehicleIndex,
      showAddEditVehicleContainer: showAddEditVehicleContainer ?? this.showAddEditVehicleContainer,
    );
  }
}
