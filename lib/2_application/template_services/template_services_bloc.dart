import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../3_domain/models/models.dart';
import '../../3_domain/repositories/template_service_repository.dart';
import '../../failures/failures.dart';

part 'template_services_event.dart';
part 'template_services_state.dart';

class TemplateServicesBloc extends Bloc<TemplateServicesEvent, TemplateServicesState> {
  final TemplateServiceRepository _templateServiceRepository;

  TemplateServicesBloc({required TemplateServiceRepository templateServiceRepository})
      : _templateServiceRepository = templateServiceRepository,
        super(TemplateServicesState.initial()) {
    on<SetTemplateServicesStateToInitialEvent>(_onSetTemplateServicesStateToInitial);
    on<SetTemplateServiceTypeEvent>(_onSetTemplateServiceType);
    on<GetTemplateServicesEvent>(_onGetTemplateServices);
    on<CreateTemplateServiceEvent>(_onCreateTemplateService);
    on<CreateTemplateServiceItemEvent>(_onCreateTemplateServiceItem);
    on<UpdateTemplateServiceEvent>(_onUpdateTemplateService);
    on<UpdateTemplateServiceItemEvent>(_onUpdateTemplateServiceItem);
    on<UpdateTemplateServicePositionsEvent>(_onUpdateTemplateServicePositions);
    on<UpdateTemplateServiceItemPositionsEvent>(_onUpdateTemplateServiceItemPositions);
    on<DeleteTemplateServiceEvent>(_onDeleteTemplateService);
    on<DeleteTemplateServiceItemEvent>(_onDeleteTemplateServiceItem);
  }

  void _onSetTemplateServicesStateToInitial(SetTemplateServicesStateToInitialEvent event, Emitter<TemplateServicesState> emit) {
    emit(TemplateServicesState.initial());
  }

  void _onSetTemplateServiceType(SetTemplateServiceTypeEvent event, Emitter<TemplateServicesState> emit) {
    emit(state.copyWith(templateServiceType: event.templateServiceType));
  }

  void _onGetTemplateServices(GetTemplateServicesEvent event, Emitter<TemplateServicesState> emit) async {
    if (event.shouldRefresh) emit(state.copyWith(isLoadingTemplateServicesOnObserve: true));

    final fos = await _templateServiceRepository.getTemplateServices(state.templateServiceType);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (templateServices) => emit(state.copyWith(listOfTemplateServices: templateServices, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingTemplateServicesOnObserve: false, fosTemplateServicesOnObserveOption: optionOf(fos)));
    emit(state.copyWith(fosTemplateServicesOnObserveOption: none()));
  }

  void _onCreateTemplateService(CreateTemplateServiceEvent event, Emitter<TemplateServicesState> emit) async {
    emit(state.copyWith(isLoadingTemplateServicesOnCreate: true));

    final newTemplateService = event.templateService.copyWith(position: state.listOfTemplateServices!.length + 1, type: state.templateServiceType);

    final fos = await _templateServiceRepository.createTemplateService(newTemplateService);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (addedTemplateService) {
        emit(state.copyWith(listOfTemplateServices: [...state.listOfTemplateServices!, addedTemplateService], resetFailure: true));
      },
    );

    emit(state.copyWith(isLoadingTemplateServicesOnCreate: false, fosTemplateServicesOnCreateOption: optionOf(fos)));
    emit(state.copyWith(fosTemplateServicesOnCreateOption: none()));
  }

  void _onCreateTemplateServiceItem(CreateTemplateServiceItemEvent event, Emitter<TemplateServicesState> emit) async {
    emit(state.copyWith(isLoadingTemplateServiceItemsOnCreate: true));

    final newTemplateServiceItem = event.templateServiceItem.copyWith(position: event.templateService.items!.length + 1);

    final fos = await _templateServiceRepository.createTemplateServiceItem(newTemplateServiceItem, event.templateService.id);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (addedTemplateServiceItem) {
        final List<TemplateService> listOfTemplateServices = List.from(state.listOfTemplateServices!);
        final index = listOfTemplateServices.indexWhere((templateService) => templateService.id == event.templateService.id);
        if (index != -1) {
          listOfTemplateServices[index] =
              listOfTemplateServices[index].copyWith(items: [...listOfTemplateServices[index].items!, addedTemplateServiceItem]);
        }
        emit(state.copyWith(listOfTemplateServices: listOfTemplateServices, resetFailure: true));
      },
    );

    emit(state.copyWith(isLoadingTemplateServiceItemsOnCreate: false, fosTemplateServicesOnCreateOption: optionOf(fos)));
    emit(state.copyWith(fosTemplateServicesOnCreateOption: none()));
  }

  void _onUpdateTemplateService(UpdateTemplateServiceEvent event, Emitter<TemplateServicesState> emit) async {
    emit(state.copyWith(isLoadingTemplateServicesOnUpdate: true));

    final fos = await _templateServiceRepository.updateTemplateService(event.templateService);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (updatedTemplateService) {
        final List<TemplateService> listOfTemplateServices = List.from(state.listOfTemplateServices!);
        final index = listOfTemplateServices.indexWhere((templateService) => templateService.id == updatedTemplateService.id);
        listOfTemplateServices[index] = updatedTemplateService;

        emit(state.copyWith(listOfTemplateServices: listOfTemplateServices, resetFailure: true));
      },
    );

    emit(state.copyWith(isLoadingTemplateServicesOnUpdate: false, fosTemplateServicesOnUpdateOption: optionOf(fos)));
    emit(state.copyWith(fosTemplateServicesOnUpdateOption: none()));
  }

  void _onUpdateTemplateServiceItem(UpdateTemplateServiceItemEvent event, Emitter<TemplateServicesState> emit) async {
    emit(state.copyWith(isLoadingTemplateServiceItemsOnUpdate: true));

    final fos = await _templateServiceRepository.updateTemplateServiceItem(event.templateServiceItem);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (updatedTemplateServiceItem) {
        final List<TemplateService> listOfTemplateServices = List.from(state.listOfTemplateServices!);
        final indexTS = listOfTemplateServices.indexWhere((templateService) => templateService.id == updatedTemplateServiceItem.templateServiceId);

        if (indexTS != -1) {
          final indexTSI = listOfTemplateServices[indexTS].items!.indexWhere((item) => item.id == updatedTemplateServiceItem.id);
          if (indexTSI != -1) {
            listOfTemplateServices[indexTS].items![indexTSI] = updatedTemplateServiceItem;
          }
        }

        emit(state.copyWith(listOfTemplateServices: listOfTemplateServices, resetFailure: true));
      },
    );

    emit(state.copyWith(isLoadingTemplateServiceItemsOnUpdate: false, fosTemplateServicesOnUpdateOption: optionOf(fos)));
    emit(state.copyWith(fosTemplateServicesOnUpdateOption: none()));
  }

  void _onUpdateTemplateServicePositions(UpdateTemplateServicePositionsEvent event, Emitter<TemplateServicesState> emit) async {
    List<TemplateService> listOfTemplateServices = List.from(state.listOfTemplateServices!);

    int newIndex = event.newIndex;
    int oldIndex = event.oldIndex;

    if (newIndex > oldIndex) newIndex -= 1;

    final item = listOfTemplateServices.removeAt(oldIndex);
    listOfTemplateServices.insert(newIndex, item);

    for (int i = 0; i < listOfTemplateServices.length; i++) {
      listOfTemplateServices[i] = listOfTemplateServices[i].copyWith(position: i + 1);
    }

    emit(state.copyWith(listOfTemplateServices: listOfTemplateServices, resetFailure: true));

    final fos = await _templateServiceRepository.updatePositionsOfTemplateServices(listOfTemplateServices);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) {
        emit(state.copyWith(listOfTemplateServices: listOfTemplateServices, resetFailure: true));
      },
    );
  }

  void _onUpdateTemplateServiceItemPositions(UpdateTemplateServiceItemPositionsEvent event, Emitter<TemplateServicesState> emit) async {
    List<TemplateService> listOfTemplateServices = List.from(state.listOfTemplateServices!);
    List<TemplateServiceItem> listOfTemplateServiceItems = List.from(event.templateService.items!);

    int newIndex = event.newIndex;
    int oldIndex = event.oldIndex;

    if (newIndex > oldIndex) newIndex -= 1;

    final item = listOfTemplateServiceItems.removeAt(oldIndex);
    listOfTemplateServiceItems.insert(newIndex, item);

    for (int i = 0; i < listOfTemplateServiceItems.length; i++) {
      listOfTemplateServiceItems[i] = listOfTemplateServiceItems[i].copyWith(position: i + 1);
    }

    final index = listOfTemplateServices.indexWhere((templateService) => templateService.id == event.templateService.id);
    if (index != -1) {
      listOfTemplateServices[index] = listOfTemplateServices[index].copyWith(items: listOfTemplateServiceItems);
    }

    emit(state.copyWith(listOfTemplateServices: listOfTemplateServices, resetFailure: true));

    final fos = await _templateServiceRepository.updatePositionsOfTemplateServiceItems(listOfTemplateServiceItems);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) {
        emit(state.copyWith(listOfTemplateServices: listOfTemplateServices, resetFailure: true));
      },
    );
  }

  void _onDeleteTemplateService(DeleteTemplateServiceEvent event, Emitter<TemplateServicesState> emit) async {
    emit(state.copyWith(isLoadingTemplateServicesOnDelete: true));

    final fos = await _templateServiceRepository.deleteTemplateService(event.templateServiceId);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) {
        emit(state.copyWith(resetFailure: true));
        add(GetTemplateServicesEvent(shouldRefresh: false));
      },
    );

    emit(state.copyWith(isLoadingTemplateServicesOnDelete: false, fosTemplateServicesOnDeleteOption: optionOf(fos)));
    emit(state.copyWith(fosTemplateServicesOnDeleteOption: none()));
  }

  void _onDeleteTemplateServiceItem(DeleteTemplateServiceItemEvent event, Emitter<TemplateServicesState> emit) async {
    emit(state.copyWith(isLoadingTemplateServiceItemsOnDelete: true));

    final fos = await _templateServiceRepository.deleteTemplateServiceItem(event.templateServiceItemId);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) {
        emit(state.copyWith(resetFailure: true));
        add(GetTemplateServicesEvent(shouldRefresh: false));
      },
    );

    emit(state.copyWith(isLoadingTemplateServiceItemsOnDelete: false, fosTemplateServicesOnDeleteOption: optionOf(fos)));
    emit(state.copyWith(fosTemplateServicesOnDeleteOption: none()));
  }
}
