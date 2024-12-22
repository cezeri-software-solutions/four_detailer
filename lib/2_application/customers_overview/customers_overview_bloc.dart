import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../3_domain/models/models.dart';
import '../../3_domain/repositories/customer_repository.dart';
import '../../failures/failures.dart';

part 'customers_overview_event.dart';
part 'customers_overview_state.dart';

class CustomersOverviewBloc extends Bloc<CustomersOverviewEvent, CustomersOverviewState> {
  final CustomerRepository _customerRepository;

  CustomersOverviewBloc({required CustomerRepository customerRepository})
      : _customerRepository = customerRepository,
        super(CustomersOverviewState.initial()) {
    on<SetCustomersStateToInitialEvent>(_onSetCustomersStateToInitial);
    on<GetCustomersEvent>(_onGetCustomers);
    on<GetCustomerByIdEvent>(_onGetCustomerById);
    on<DeleteCustomersEvent>(_onDeleteCustomers);
    on<ItemsPerPageChangedEvent>(_onItemsPerPageChanged);
    on<OnSearchFieldClearedEvent>(_onSearchFieldCleared);
  }

  void _onSetCustomersStateToInitial(SetCustomersStateToInitialEvent event, Emitter<CustomersOverviewState> emit) {
    emit(CustomersOverviewState.initial());
  }

  void _onGetCustomers(GetCustomersEvent event, Emitter<CustomersOverviewState> emit) async {
    emit(state.copyWith(isLoadingCustomers: true));

    final fos = await _customerRepository.getCustomers(
      searchTerm: state.searchController.text,
      itemsPerPage: state.itemsPerPage,
      currentPage: event.currentPage,
    );
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (itemsAndCount) => emit(state.copyWith(listOfCustomers: itemsAndCount.customers, totalQuantity: itemsAndCount.totalCount, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingCustomers: false, fosCustomersOption: optionOf(fos)));
    emit(state.copyWith(fosCustomersOption: none()));
  }

  void _onGetCustomerById(GetCustomerByIdEvent event, Emitter<CustomersOverviewState> emit) async {
    final fos = await _customerRepository.getCustomerById(event.customerId);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (customer) {
        final List<Customer> listOfCustomers = List.from(state.listOfCustomers ?? []);
        final index = listOfCustomers.indexWhere((e) => e.id == customer.id);

        if (index != -1) listOfCustomers[index] = customer;

        emit(state.copyWith(listOfCustomers: listOfCustomers, resetFailure: true));
      },
    );
  }

  void _onDeleteCustomers(DeleteCustomersEvent event, Emitter<CustomersOverviewState> emit) async {
    emit(state.copyWith(isLoadingDeleteCustomers: true));

    final fos = await _customerRepository.deleteCustomers(event.customerIds);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) {
        emit(state.copyWith(resetFailure: true));
        add(GetCustomersEvent(calcCount: true, currentPage: state.currentPage));
      },
    );

    emit(state.copyWith(isLoadingDeleteCustomers: false, fosDeleteCustomersOption: optionOf(fos)));
    emit(state.copyWith(fosDeleteCustomersOption: none()));
  }

  void _onItemsPerPageChanged(ItemsPerPageChangedEvent event, Emitter<CustomersOverviewState> emit) {
    emit(state.copyWith(itemsPerPage: event.value));
    add(GetCustomersEvent(calcCount: false, currentPage: 1));
  }

  void _onSearchFieldCleared(OnSearchFieldClearedEvent event, Emitter<CustomersOverviewState> emit) {
    emit(state.copyWith(searchController: SearchController()));
    add(GetCustomersEvent(calcCount: true, currentPage: 1));
  }
}
