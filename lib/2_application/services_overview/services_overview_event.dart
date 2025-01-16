part of 'services_overview_bloc.dart';

@immutable
sealed class ServicesOverviewEvent {}

class SetServicesStateToInitialEvent extends ServicesOverviewEvent {}

class GetServiceByIdEvent extends ServicesOverviewEvent {
  final String serviceId;

  GetServiceByIdEvent({required this.serviceId});
}

class GetServicesEvent extends ServicesOverviewEvent {
  final bool calcCount;
  final int currentPage;

  GetServicesEvent({required this.calcCount, required this.currentPage});
}

class CreateServiceEvent extends ServicesOverviewEvent {
  final Service service;

  CreateServiceEvent({required this.service});
}

class UpdateServiceEvent extends ServicesOverviewEvent {
  final Service service;

  UpdateServiceEvent({required this.service});
}

class DeleteServiceEvent extends ServicesOverviewEvent {
  final String serviceId;

  DeleteServiceEvent({required this.serviceId});
}

class UpdateServicePositionsEvent extends ServicesOverviewEvent {
  final int newIndex;
  final int oldIndex;

  UpdateServicePositionsEvent({required this.newIndex, required this.oldIndex});
}

//* --- Helper Pagination --- *//

class ItemsPerPageChangedEvent extends ServicesOverviewEvent {
  final int value;

  ItemsPerPageChangedEvent({required this.value});
}

class OnSearchFieldClearedEvent extends ServicesOverviewEvent {}
