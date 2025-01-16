import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/core.dart';
import '../../3_domain/models/models.dart';
import '../../3_domain/repositories/database_repository.dart';
import '../../3_domain/repositories/service_repository.dart';
import '../../failures/failures.dart';

part 'service_detail_event.dart';
part 'service_detail_state.dart';

class ServiceDetailBloc extends Bloc<ServiceDetailEvent, ServiceDetailState> {
  final ServiceRepository _serviceRepository;
  final DatabaseRepository _databaseRepository;

  ServiceDetailBloc({required ServiceRepository serviceRepository, required DatabaseRepository databaseRepository})
      : _serviceRepository = serviceRepository,
        _databaseRepository = databaseRepository,
        super(ServiceDetailState.initial()) {
    on<SetServiceDetailStateToInitialEvent>(_onSetServiceDetailStateToInitial);
    on<SetEmptyServiceOnCreateEvent>(_onSetEmptyServiceOnCreate);
    on<GetCurrentServiceEvent>(_onGetCurrentService);
    on<CreateServiceEvent>(_onCreateService);
    on<SaveServiceEvent>(_onSaveService);
    on<EditServiceEvent>(_onEditService);
    on<OnNetPriceChangedEvent>(_onNetPriceChanged);
    on<OnGrossPriceChangedEvent>(_onGrossPriceChanged);
    on<AddNewServiceSmartItemEvent>(_onAddNewServiceSmartItem);
    on<AddServiceSmartItemsFromTemplateEvent>(_onAddServiceSmartItemsFromTemplate);
    on<EditServiceSmartItemEvent>(_onEditServiceSmartItem);
    on<RemoveServiceSmartItemEvent>(_onRemoveServiceSmartItem);
    on<AddNewServiceTodoEvent>(_onAddNewServiceTodo);
    on<AddServiceTodosFromTemplateEvent>(_onAddServiceTodosFromTemplate);
    on<EditServiceTodoEvent>(_onEditServiceTodo);
    on<RemoveServiceTodoEvent>(_onRemoveServiceTodo);
    on<OnServiceCategorySelectedEvent>(_onServiceCategorySelected);
    on<ResetServiceCategoryEvent>(_onResetServiceCategory);
    on<UpdateServiceSmartItemPositionsEvent>(_onUpdateServiceSmartItemPositions);
    on<UpdateServiceTodoPositionsEvent>(_onUpdateServiceTodoPositions);
  }

  Future<void> _onSetServiceDetailStateToInitial(SetServiceDetailStateToInitialEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onSetServiceDetailStateToInitial wird ausgeführt ...');
    emit(ServiceDetailState.initial());
  }

  Future<void> _onSetEmptyServiceOnCreate(SetEmptyServiceOnCreateEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onSetEmptyServiceOnCreate wird ausgeführt ...');
    final fosTaxAndCurrency = await _databaseRepository.getTaxAndCurrencyFromSettings();
    if (fosTaxAndCurrency.isLeft()) emit(state.copyWith(failure: fosTaxAndCurrency.getLeft()));

    emit(state.copyWith(service: Service.empty().copyWith(tax: fosTaxAndCurrency.getRight().tax, currency: fosTaxAndCurrency.getRight().currency)));
  }

  Future<void> _onGetCurrentService(GetCurrentServiceEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onGetCurrentService wird ausgeführt ...');
    emit(state.copyWith(isLoadingServiceOnObserve: true));

    final fos = await _serviceRepository.getServiceById(event.serviceId);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (service) => emit(state.copyWith(
        service: service.sortAllLists(),
        netPriceController: TextEditingController(text: service.netPrice.toString()),
        grossPriceController: TextEditingController(text: service.grossPrice.toString()),
        resetFailure: true,
      )),
    );

    emit(state.copyWith(isLoadingServiceOnObserve: false, fosServiceOnObserveOption: optionOf(fos)));
    emit(state.copyWith(fosServiceOnObserveOption: none()));
  }

  void _onCreateService(CreateServiceEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onCreateService wird ausgeführt ...');
    emit(state.copyWith(isLoadingServiceOnCreate: true));

    final fos = await _serviceRepository.createService(state.service!);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (service) => emit(state.copyWith(service: service, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingServiceOnCreate: false, fosServiceOnCreateOption: optionOf(fos)));
    emit(state.copyWith(fosServiceOnCreateOption: none()));
  }

  void _onSaveService(SaveServiceEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onSaveService wird ausgeführt ...');
    emit(state.copyWith(isLoadingServiceOnUpdate: true));

    final fos = await _serviceRepository.updateService(state.service!);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (service) => emit(state.copyWith(service: service.sortAllLists(), resetFailure: true)),
    );

    emit(state.copyWith(isLoadingServiceOnUpdate: false, fosServiceOnUpdateOption: optionOf(fos)));
    emit(state.copyWith(fosServiceOnUpdateOption: none()));
  }

  Future<void> _onEditService(EditServiceEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onEditService wird ausgeführt ...');
    emit(state.copyWith(
      service: event.service,
      resetFailure: true,
    ));
  }

  void _onNetPriceChanged(OnNetPriceChangedEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onNetPriceChanged wird ausgeführt ...');
    double grossPrice = 0.0;
    double netPrice = state.netPriceController.text.toMyDouble();

    if (netPrice > 0.0) grossPrice = (netPrice * state.service!.tax.toMyTaxToCalc()).toMyRoundedDouble();

    if (state.netPriceController.text.isEmpty) grossPrice = 0.0;

    emit(state.copyWith(
      grossPriceController: TextEditingController(text: grossPrice.toString()),
      service: state.service!.copyWith(grossPrice: grossPrice, netPrice: netPrice),
    ));
  }

  void _onGrossPriceChanged(OnGrossPriceChangedEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onGrossPriceChanged wird ausgeführt ...');
    double netPrice = 0.0;
    double grossPrice = state.grossPriceController.text.toMyDouble();

    if (grossPrice > 0.0) netPrice = (grossPrice / state.service!.tax.toMyTaxToCalc()).toMyRoundedDouble();

    if (state.grossPriceController.text.isEmpty) netPrice = 0.0;

    emit(state.copyWith(
      netPriceController: TextEditingController(text: netPrice.toString()),
      service: state.service!.copyWith(netPrice: netPrice, grossPrice: grossPrice),
    ));
  }

  void _onAddNewServiceSmartItem(AddNewServiceSmartItemEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onAddNewServiceSmartItem wird ausgeführt ...');
    final currentServiceSmartItems = List<ServiceSmartItem>.from(
      event.serviceSmartItem.type == ServiceSmartItemType.vehicleSize ? state.service!.vehicleSizes ?? [] : state.service!.contaminationLevels ?? [],
    );

    final deletedCount = currentServiceSmartItems.where((e) => e.isDeleted).length;

    final newServiceSmartItem = event.serviceSmartItem.copyWith(
      serviceId: state.service!.id,
      additionalNetPrice: (event.serviceSmartItem.additionalGrossPrice / state.service!.tax.toMyTaxToCalc()).toMyRoundedDouble(),
      additionalNetMaterialCosts: (event.serviceSmartItem.additionalGrossMaterialCosts / state.service!.tax.toMyTaxToCalc()).toMyRoundedDouble(),
      entityState: EntityState.created,
      position: currentServiceSmartItems.length + 1 - deletedCount,
    );

    currentServiceSmartItems.add(newServiceSmartItem);

    final updatedService = event.serviceSmartItem.type == ServiceSmartItemType.vehicleSize
        ? state.service!.copyWith(vehicleSizes: currentServiceSmartItems)
        : state.service!.copyWith(contaminationLevels: currentServiceSmartItems);

    emit(state.copyWith(service: updatedService.sortAllLists()));
  }

  void _onAddServiceSmartItemsFromTemplate(AddServiceSmartItemsFromTemplateEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onAddServiceSmartItemsFromTemplate wird ausgeführt ...');
    final currentServiceSmartItems = List<ServiceSmartItem>.from(
      event.serviceSmartItems.first.type == ServiceSmartItemType.vehicleSize
          ? state.service!.vehicleSizes ?? []
          : state.service!.contaminationLevels ?? [],
    );

    final deletedCount = currentServiceSmartItems.where((e) => e.isDeleted).length;

    for (final item in event.serviceSmartItems) {
      final newServiceSmartItem = item.copyWith(
        serviceId: state.service!.id,
        additionalNetPrice: (item.additionalGrossPrice / state.service!.tax.toMyTaxToCalc()).toMyRoundedDouble(),
        additionalNetMaterialCosts: (item.additionalGrossMaterialCosts / state.service!.tax.toMyTaxToCalc()).toMyRoundedDouble(),
        entityState: EntityState.created,
        position: currentServiceSmartItems.length + 1 - deletedCount,
      );

      currentServiceSmartItems.add(newServiceSmartItem);
    }

    final updatedService = event.serviceSmartItems.first.type == ServiceSmartItemType.vehicleSize
        ? state.service!.copyWith(vehicleSizes: currentServiceSmartItems)
        : state.service!.copyWith(contaminationLevels: currentServiceSmartItems);

    emit(state.copyWith(service: updatedService.sortAllLists()));
  }

  void _onEditServiceSmartItem(EditServiceSmartItemEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onEditServiceSmartItem wird ausgeführt ...');
    final currentServiceSmartItems = List<ServiceSmartItem>.from(
      event.serviceSmartItem.type == ServiceSmartItemType.vehicleSize ? state.service!.vehicleSizes ?? [] : state.service!.contaminationLevels ?? [],
    );

    currentServiceSmartItems[event.index] = event.serviceSmartItem.copyWith(
      additionalNetPrice: (event.serviceSmartItem.additionalGrossPrice / state.service!.tax.toMyTaxToCalc()).toMyRoundedDouble(),
      additionalNetMaterialCosts: (event.serviceSmartItem.additionalGrossMaterialCosts / state.service!.tax.toMyTaxToCalc()).toMyRoundedDouble(),
      entityState: event.serviceSmartItem.entityState != EntityState.created ? EntityState.edited : event.serviceSmartItem.entityState,
    );

    if (event.serviceSmartItem.type == ServiceSmartItemType.vehicleSize) {
      emit(state.copyWith(service: state.service!.copyWith(vehicleSizes: currentServiceSmartItems)));
    } else {
      emit(state.copyWith(service: state.service!.copyWith(contaminationLevels: currentServiceSmartItems)));
    }
  }

  void _onRemoveServiceSmartItem(RemoveServiceSmartItemEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onRemoveServiceSmartItem wird ausgeführt ...');
    final currentServiceSmartItems = List<ServiceSmartItem>.from(
      event.serviceSmartItem.type == ServiceSmartItemType.vehicleSize ? state.service!.vehicleSizes ?? [] : state.service!.contaminationLevels ?? [],
    ).where((e) => e.isDeleted == false).toList();

    if (currentServiceSmartItems[event.index].id.isEmpty) {
      currentServiceSmartItems.removeAt(event.index);
    } else {
      currentServiceSmartItems[event.index] = currentServiceSmartItems[event.index].copyWith(
        isDeleted: true,
        entityState: EntityState.deleted,
      );
    }

    int deletedCount = 0;
    for (int i = 0; i < currentServiceSmartItems.length; i++) {
      final curItem = currentServiceSmartItems[i];

      if (curItem.isDeleted) {
        deletedCount++;
        continue;
      }

      final position = i + 1 - deletedCount;
      currentServiceSmartItems[i] = curItem.copyWith(
        position: position,
        entityState: curItem.entityState != EntityState.created ? EntityState.edited : curItem.entityState,
      );
    }

    final updatedService = event.serviceSmartItem.type == ServiceSmartItemType.vehicleSize
        ? state.service!.copyWith(vehicleSizes: currentServiceSmartItems)
        : state.service!.copyWith(contaminationLevels: currentServiceSmartItems);

    emit(state.copyWith(service: updatedService.sortAllLists()));
  }

  void _onAddNewServiceTodo(AddNewServiceTodoEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onAddNewServiceTodo wird ausgeführt ...');
    final currentServiceTodos = List<ServiceTodo>.from(state.service!.todos ?? []);

    final deletedCount = currentServiceTodos.where((e) => e.isDeleted).length;

    final newServiceTodo = event.serviceTodo.copyWith(
      serviceId: state.service!.id,
      entityState: EntityState.created,
      position: currentServiceTodos.length + 1 - deletedCount,
    );

    currentServiceTodos.add(newServiceTodo);

    final updatedService = state.service!.copyWith(todos: currentServiceTodos);

    emit(state.copyWith(service: updatedService.sortAllLists()));
  }

  void _onAddServiceTodosFromTemplate(AddServiceTodosFromTemplateEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onAddServiceTodosFromTemplate wird ausgeführt ...');
    final currentServiceTodos = List<ServiceTodo>.from(state.service!.todos ?? []);

    final deletedCount = currentServiceTodos.where((e) => e.isDeleted).length;

    for (final item in event.serviceTodos) {
      final newServiceTodo = item.copyWith(
        serviceId: state.service!.id,
        entityState: EntityState.created,
        position: currentServiceTodos.length + 1 - deletedCount,
      );
      currentServiceTodos.add(newServiceTodo);
    }

    final updatedService = state.service!.copyWith(todos: currentServiceTodos);

    emit(state.copyWith(service: updatedService.sortAllLists()));
  }

  void _onEditServiceTodo(EditServiceTodoEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onEditServiceTodo wird ausgeführt ...');
    final currentServiceTodos = List<ServiceTodo>.from(state.service!.todos ?? []);
    final curTodo = currentServiceTodos[event.index];

    if (curTodo.id.isEmpty) {
      currentServiceTodos[event.index] = event.serviceTodo;
    } else {
      currentServiceTodos[event.index] = event.serviceTodo.copyWith(
        entityState: curTodo.entityState != EntityState.created ? EntityState.edited : curTodo.entityState,
      );
    }

    emit(state.copyWith(service: state.service!.copyWith(todos: currentServiceTodos)));
  }

  void _onRemoveServiceTodo(RemoveServiceTodoEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onRemoveServiceTodo wird ausgeführt ...');
    final currentServiceTodos = List<ServiceTodo>.from(state.service!.todos ?? []);

    if (currentServiceTodos[event.index].id.isEmpty) {
      currentServiceTodos.removeAt(event.index);
    } else {
      currentServiceTodos[event.index] = currentServiceTodos[event.index].copyWith(
        isDeleted: true,
        entityState: EntityState.deleted,
      );
    }

    int deletedCount = 0;
    for (int i = 0; i < currentServiceTodos.length; i++) {
      final curTodo = currentServiceTodos[i];

      if (curTodo.isDeleted) {
        deletedCount++;
        continue;
      }

      final position = i + 1 - deletedCount;
      currentServiceTodos[i] = curTodo.copyWith(
        position: position,
        entityState: curTodo.entityState != EntityState.created ? EntityState.edited : curTodo.entityState,
      );
    }

    final updatedService = state.service!.copyWith(todos: currentServiceTodos);

    emit(state.copyWith(service: updatedService.sortAllLists()));
  }

  void _onServiceCategorySelected(OnServiceCategorySelectedEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onServiceCategorySelected wird ausgeführt ...');
    emit(state.copyWith(
      service: event.category != null ? state.service!.copyWith(category: event.category) : state.service!.copyWith(resetCategory: true),
    ));
  }

  void _onResetServiceCategory(ResetServiceCategoryEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onResetServiceCategory wird ausgeführt ...');
    emit(state.copyWith(service: state.service!.copyWith(resetCategory: true)));
  }

  void _onUpdateServiceSmartItemPositions(UpdateServiceSmartItemPositionsEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onUpdateServiceSmartItemPositions wird ausgeführt ...');
    final currentServiceSmartItems = List<ServiceSmartItem>.from(
        event.type == ServiceSmartItemType.vehicleSize ? state.service!.vehicleSizes ?? [] : state.service!.contaminationLevels ?? []);

    int newIndex = event.newIndex;
    int oldIndex = event.oldIndex;

    if (newIndex > oldIndex) newIndex -= 1;

    final item = currentServiceSmartItems.removeAt(oldIndex);
    currentServiceSmartItems.insert(newIndex, item);

    for (int i = 0; i < currentServiceSmartItems.length; i++) {
      final curItem = currentServiceSmartItems[i];
      currentServiceSmartItems[i] = curItem.copyWith(
        position: i + 1,
        entityState: curItem.entityState != EntityState.created ? EntityState.edited : curItem.entityState,
      );
    }

    if (event.type == ServiceSmartItemType.vehicleSize) {
      emit(state.copyWith(service: state.service!.copyWith(vehicleSizes: currentServiceSmartItems)));
    } else {
      emit(state.copyWith(service: state.service!.copyWith(contaminationLevels: currentServiceSmartItems)));
    }
  }

  void _onUpdateServiceTodoPositions(UpdateServiceTodoPositionsEvent event, Emitter<ServiceDetailState> emit) async {
    debugPrint('_onUpdateServiceTodoPositions wird ausgeführt ...');
    final currentServiceTodos = List<ServiceTodo>.from(state.service!.todos ?? []);

    int newIndex = event.newIndex;
    int oldIndex = event.oldIndex;

    if (newIndex > oldIndex) newIndex -= 1;

    final item = currentServiceTodos.removeAt(oldIndex);
    currentServiceTodos.insert(newIndex, item);

    for (int i = 0; i < currentServiceTodos.length; i++) {
      final curTodo = currentServiceTodos[i];
      currentServiceTodos[i] = curTodo.copyWith(
        position: i + 1,
        entityState: curTodo.entityState != EntityState.created ? EntityState.edited : curTodo.entityState,
      );
    }

    emit(state.copyWith(service: state.service!.copyWith(todos: currentServiceTodos)));
  }
}

extension ServiceSortExtension on Service {
  Service sortAllLists() {
    debugPrint('ServiceSortExtension.sortAllLists wird ausgeführt ...');
    final sortedVehicleSizes = vehicleSizes?.toList()
      ?..sort((a, b) {
        if (a.isDeleted != b.isDeleted) return a.isDeleted ? 1 : -1;

        return a.position.compareTo(b.position);
      });

    final sortedContaminationLevels = contaminationLevels?.toList()
      ?..sort((a, b) {
        if (a.isDeleted != b.isDeleted) return a.isDeleted ? 1 : -1;

        return a.position.compareTo(b.position);
      });

    final sortedTodos = todos?.toList()
      ?..sort((a, b) {
        if (a.isDeleted != b.isDeleted) return a.isDeleted ? 1 : -1;

        return a.position.compareTo(b.position);
      });

    return copyWith(
      vehicleSizes: sortedVehicleSizes,
      contaminationLevels: sortedContaminationLevels,
      todos: sortedTodos,
    );
  }
}
