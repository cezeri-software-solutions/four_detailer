import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/3_domain/models/models.dart';
import '/3_domain/repositories/service_repository.dart';
import '/failures/failures.dart';

part 'services_overview_event.dart';
part 'services_overview_state.dart';

class ServicesOverviewBloc extends Bloc<ServicesOverviewEvent, ServicesOverviewState> {
  final ServiceRepository _serviceRepository;

  ServicesOverviewBloc({required ServiceRepository serviceRepository})
      : _serviceRepository = serviceRepository,
        super(ServicesOverviewState.initial()) {
    on<SetServicesStateToInitialEvent>(_onSetServicesStateToInitial);
    on<GetServiceByIdEvent>(_onGetServiceById);
    on<GetServicesEvent>(_onGetServices);
    on<CreateServiceEvent>(_onCreateService);
    on<UpdateServiceEvent>(_onUpdateService);
    on<DeleteServiceEvent>(_onDeleteService);
    on<UpdateServicePositionsEvent>(_onUpdateServicePositions);
    on<ItemsPerPageChangedEvent>(_onItemsPerPageChanged);
    on<OnSearchFieldClearedEvent>(_onSearchFieldCleared);
  }

  void _onSetServicesStateToInitial(SetServicesStateToInitialEvent event, Emitter<ServicesOverviewState> emit) {
    emit(ServicesOverviewState.initial());
  }

  void _onGetServiceById(GetServiceByIdEvent event, Emitter<ServicesOverviewState> emit) async {
    final fos = await _serviceRepository.getServiceById(event.serviceId);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (service) {
        final List<Service> listOfServices = List.from(state.listOfServices ?? []);
        final index = listOfServices.indexWhere((e) => e.id == service.id);

        if (index != -1) listOfServices[index] = service;

        emit(state.copyWith(listOfServices: listOfServices, resetFailure: true));
      },
    );
  }

  void _onGetServices(GetServicesEvent event, Emitter<ServicesOverviewState> emit) async {
    emit(state.copyWith(isLoadingServicesOnObserve: true));

    final fos = await _serviceRepository.getServices(
      searchTerm: state.searchController.text,
      itemsPerPage: state.itemsPerPage,
      currentPage: event.currentPage,
    );
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (services) => emit(state.copyWith(
        listOfServices: services.services,
        totalQuantity: event.calcCount ? services.totalCount : state.totalQuantity,
        currentPage: event.currentPage,
        resetFailure: true,
      )),
    );

    emit(state.copyWith(isLoadingServicesOnObserve: false, fosServicesOnObserveOption: optionOf(fos)));
    emit(state.copyWith(fosServicesOnObserveOption: none()));
  }

  void _onCreateService(CreateServiceEvent event, Emitter<ServicesOverviewState> emit) async {
    emit(state.copyWith(isLoadingServicesOnCreate: true));

    final newService = event.service.copyWith(position: state.listOfServices!.length + 1);

    final fos = await _serviceRepository.createService(newService);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (addedService) {
        emit(state.copyWith(listOfServices: [...state.listOfServices!, addedService], resetFailure: true));
      },
    );

    emit(state.copyWith(isLoadingServicesOnCreate: false, fosServicesOnCreateOption: optionOf(fos)));
    emit(state.copyWith(fosServicesOnCreateOption: none()));
  }

  void _onUpdateService(UpdateServiceEvent event, Emitter<ServicesOverviewState> emit) async {
    emit(state.copyWith(isLoadingServicesOnUpdate: true));

    final fos = await _serviceRepository.updateService(event.service);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (updatedService) {
        final List<Service> listOfServices = List.from(state.listOfServices!);
        final index = listOfServices.indexWhere((service) => service.id == updatedService.id);
        listOfServices[index] = updatedService;

        emit(state.copyWith(listOfServices: listOfServices, resetFailure: true));
      },
    );

    emit(state.copyWith(isLoadingServicesOnUpdate: false, fosServicesOnUpdateOption: optionOf(fos)));
    emit(state.copyWith(fosServicesOnUpdateOption: none()));
  }

  void _onDeleteService(DeleteServiceEvent event, Emitter<ServicesOverviewState> emit) async {
    emit(state.copyWith(isLoadingServicesOnDelete: true));

    final fos = await _serviceRepository.deleteService(event.serviceId);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) {
        emit(state.copyWith(resetFailure: true));
        add(GetServicesEvent(calcCount: true, currentPage: state.currentPage));
      },
    );

    emit(state.copyWith(isLoadingServicesOnDelete: false, fosServicesOnDeleteOption: optionOf(fos)));
    emit(state.copyWith(fosServicesOnDeleteOption: none()));
  }

  void _onUpdateServicePositions(UpdateServicePositionsEvent event, Emitter<ServicesOverviewState> emit) async {
    List<Service> listOfServices = List.from(state.listOfServices!);

    int newIndex = event.newIndex;
    int oldIndex = event.oldIndex;

    if (newIndex > oldIndex) newIndex -= 1;

    final item = listOfServices.removeAt(oldIndex);
    listOfServices.insert(newIndex, item);

    for (int i = 0; i < listOfServices.length; i++) {
      listOfServices[i] = listOfServices[i].copyWith(position: i + 1);
    }

    emit(state.copyWith(listOfServices: listOfServices, resetFailure: true));

    final fos = await _serviceRepository.updatePositionsOfServices(listOfServices);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) {
        emit(state.copyWith(listOfServices: listOfServices, resetFailure: true));
        // add(GetServicesEvent(calcCount: true, currentPage: state.currentPage));
      },
    );
  }

  void _onItemsPerPageChanged(ItemsPerPageChangedEvent event, Emitter<ServicesOverviewState> emit) {
    emit(state.copyWith(itemsPerPage: event.value));
    add(GetServicesEvent(calcCount: false, currentPage: 1));
  }

  void _onSearchFieldCleared(OnSearchFieldClearedEvent event, Emitter<ServicesOverviewState> emit) {
    emit(state.copyWith(searchController: SearchController()));
    add(GetServicesEvent(calcCount: true, currentPage: 1));
  }
}
