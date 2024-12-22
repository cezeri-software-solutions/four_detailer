// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'customers_overview_bloc.dart';

@immutable
class CustomersOverviewState {
  final List<Customer>? listOfCustomers;
  final AbstractFailure? failure;
  final bool isLoadingCustomers;
  final bool isLoadingDeleteCustomers;
  final Option<Either<AbstractFailure, ({List<Customer> customers, int totalCount})>> fosCustomersOption;
  final Option<Either<AbstractFailure, Unit>> fosDeleteCustomersOption;

  //* Helper Pagination *//
  final int itemsPerPage;
  final int totalQuantity;
  final int currentPage;
  final SearchController searchController;

  const CustomersOverviewState({
    required this.listOfCustomers,
    required this.failure,
    required this.isLoadingCustomers,
    required this.isLoadingDeleteCustomers,
    required this.fosCustomersOption,
    required this.fosDeleteCustomersOption,
    required this.itemsPerPage,
    required this.totalQuantity,
    required this.currentPage,
    required this.searchController,
  });

  factory CustomersOverviewState.initial() => CustomersOverviewState(
        listOfCustomers: null,
        failure: null,
        isLoadingCustomers: true,
        isLoadingDeleteCustomers: false,
        fosCustomersOption: none(),
        fosDeleteCustomersOption: none(),
        itemsPerPage: 25,
        totalQuantity: 1,
        currentPage: 1,
        searchController: SearchController(),
      );

  CustomersOverviewState copyWith({
    List<Customer>? listOfCustomers,
    bool? resetFailure,
    AbstractFailure? failure,
    bool? isLoadingCustomers,
    bool? isLoadingDeleteCustomers,
    Option<Either<AbstractFailure, ({List<Customer> customers, int totalCount})>>? fosCustomersOption,
    Option<Either<AbstractFailure, Unit>>? fosDeleteCustomersOption,
    int? itemsPerPage,
    int? totalQuantity,
    int? currentPage,
    SearchController? searchController,
  }) {
    return CustomersOverviewState(
      listOfCustomers: listOfCustomers ?? this.listOfCustomers,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingCustomers: isLoadingCustomers ?? this.isLoadingCustomers,
      isLoadingDeleteCustomers: isLoadingDeleteCustomers ?? this.isLoadingDeleteCustomers,
      fosCustomersOption: fosCustomersOption ?? this.fosCustomersOption,
      fosDeleteCustomersOption: fosDeleteCustomersOption ?? this.fosDeleteCustomersOption,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      currentPage: currentPage ?? this.currentPage,
      searchController: searchController ?? this.searchController,
    );
  }
}
