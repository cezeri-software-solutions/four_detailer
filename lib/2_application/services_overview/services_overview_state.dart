part of 'services_overview_bloc.dart';

@immutable
class ServicesOverviewState {
  final List<Service>? listOfServices;
  final List<Category> listOfCategories;
  final AbstractFailure? failure;
  final bool isLoadingServicesOnObserve;
  final bool isLoadingServicesOnCreate;
  final bool isLoadingServicesOnUpdate;
  final bool isLoadingServicesOnDelete;
  final Option<Either<AbstractFailure, ({List<Service> services, int totalCount})>> fosServicesOnObserveOption;
  final Option<Either<AbstractFailure, Service>> fosServicesOnCreateOption;
  final Option<Either<AbstractFailure, Service>> fosServicesOnUpdateOption;
  final Option<Either<AbstractFailure, Unit>> fosServicesOnDeleteOption;

  //* Helper Pagination *//
  final int itemsPerPage;
  final int totalQuantity;
  final int currentPage;
  final SearchController searchController;

  const ServicesOverviewState({
    required this.listOfServices,
    required this.listOfCategories,
    required this.failure,
    required this.isLoadingServicesOnObserve,
    required this.isLoadingServicesOnCreate,
    required this.isLoadingServicesOnUpdate,
    required this.isLoadingServicesOnDelete,
    required this.fosServicesOnObserveOption,
    required this.fosServicesOnCreateOption,
    required this.fosServicesOnUpdateOption,
    required this.fosServicesOnDeleteOption,
    required this.itemsPerPage,
    required this.totalQuantity,
    required this.currentPage,
    required this.searchController,
  });

  factory ServicesOverviewState.initial() => ServicesOverviewState(
        listOfServices: null,
        listOfCategories: const [],
        failure: null,
        isLoadingServicesOnObserve: true,
        isLoadingServicesOnCreate: false,
        isLoadingServicesOnUpdate: false,
        isLoadingServicesOnDelete: false,
        fosServicesOnObserveOption: none(),
        fosServicesOnCreateOption: none(),
        fosServicesOnUpdateOption: none(),
        fosServicesOnDeleteOption: none(),
        itemsPerPage: 25,
        totalQuantity: 1,
        currentPage: 1,
        searchController: SearchController(),
      );

  ServicesOverviewState copyWith({
    List<Service>? listOfServices,
    List<Category>? listOfCategories,
    bool? resetFailure,
    AbstractFailure? failure,
    bool? isLoadingServicesOnObserve,
    bool? isLoadingServicesOnCreate,
    bool? isLoadingServicesOnUpdate,
    bool? isLoadingServicesOnDelete,
    Option<Either<AbstractFailure, ({List<Service> services, int totalCount})>>? fosServicesOnObserveOption,
    Option<Either<AbstractFailure, Service>>? fosServicesOnCreateOption,
    Option<Either<AbstractFailure, Service>>? fosServicesOnUpdateOption,
    Option<Either<AbstractFailure, Unit>>? fosServicesOnDeleteOption,
    int? itemsPerPage,
    int? totalQuantity,
    int? currentPage,
    SearchController? searchController,
  }) {
    return ServicesOverviewState(
      listOfServices: listOfServices ?? this.listOfServices,
      listOfCategories: listOfCategories ?? this.listOfCategories,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingServicesOnObserve: isLoadingServicesOnObserve ?? this.isLoadingServicesOnObserve,
      isLoadingServicesOnCreate: isLoadingServicesOnCreate ?? this.isLoadingServicesOnCreate,
      isLoadingServicesOnUpdate: isLoadingServicesOnUpdate ?? this.isLoadingServicesOnUpdate,
      isLoadingServicesOnDelete: isLoadingServicesOnDelete ?? this.isLoadingServicesOnDelete,
      fosServicesOnObserveOption: fosServicesOnObserveOption ?? this.fosServicesOnObserveOption,
      fosServicesOnCreateOption: fosServicesOnCreateOption ?? this.fosServicesOnCreateOption,
      fosServicesOnUpdateOption: fosServicesOnUpdateOption ?? this.fosServicesOnUpdateOption,
      fosServicesOnDeleteOption: fosServicesOnDeleteOption ?? this.fosServicesOnDeleteOption,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      currentPage: currentPage ?? this.currentPage,
      searchController: searchController ?? this.searchController,
    );
  }
}
