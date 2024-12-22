part of 'customers_overview_bloc.dart';

@immutable
sealed class CustomersOverviewEvent {}

class SetCustomersStateToInitialEvent extends CustomersOverviewEvent {}

class GetCustomersEvent extends CustomersOverviewEvent {
  final bool calcCount;
  final int currentPage;

  GetCustomersEvent({
    required this.calcCount,
    required this.currentPage,
  });
}

class GetCustomerByIdEvent extends CustomersOverviewEvent {
  final String customerId;

  GetCustomerByIdEvent({required this.customerId});
}

class DeleteCustomersEvent extends CustomersOverviewEvent {
  final List<String> customerIds;

  DeleteCustomersEvent({required this.customerIds});
}

//* --- Helper Pagination --- *//

class ItemsPerPageChangedEvent extends CustomersOverviewEvent {
  final int value;

  ItemsPerPageChangedEvent({required this.value});
}

class OnSearchFieldClearedEvent extends CustomersOverviewEvent {}
