part of 'customer_detail_bloc.dart';

@immutable
sealed class CustomerDetailEvent {}

class SetCustomerDetailStateToInitialEvnet extends CustomerDetailEvent {}

class SetEmptyCustomerOnCreateEvent extends CustomerDetailEvent {
  final BuildContext context;

  SetEmptyCustomerOnCreateEvent({required this.context});
}

class GetCurrentCustomerEvent extends CustomerDetailEvent {
  final String customerId;

  GetCurrentCustomerEvent({required this.customerId});
}

class UpdateCustomerEvent extends CustomerDetailEvent {
  final Customer customer;

  UpdateCustomerEvent({required this.customer});
}

class CreateCustomerEvent extends CustomerDetailEvent {}

class SaveCustomerEvent extends CustomerDetailEvent {}

class ShowAddEditVehicleContainerEvent extends CustomerDetailEvent {
  final bool value;

  ShowAddEditVehicleContainerEvent({required this.value});
}

class AddNewVehicleEvent extends CustomerDetailEvent {
  final Vehicle vehicle;

  AddNewVehicleEvent({required this.vehicle});
}

class EditVehicleEvent extends CustomerDetailEvent {
  final Vehicle vehicle;
  final int index;

  EditVehicleEvent({required this.vehicle, required this.index});
}

class RemoveVehicleEvent extends CustomerDetailEvent {
  final int index;

  RemoveVehicleEvent({required this.index});
}

// class ShowImageEditingChangedEvent extends CustomerDetailEvent {}

// class IsEditModeChangedEvent extends CustomerDetailEvent {}

// class IsPaymentEditModeChangedEvent extends CustomerDetailEvent {}

// class CustomerAddEditImageEvent extends CustomerDetailEvent {
//   final BuildContext context;
//   final MyImageSource source;

//   CustomerAddEditImageEvent({required this.context, required this.source});
// }

// class CustomerRemoveImageEvent extends CustomerDetailEvent {
//   final BuildContext context;

//   CustomerRemoveImageEvent({required this.context});
// }
