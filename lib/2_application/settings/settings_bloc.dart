import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/core.dart';
import '../../3_domain/models/models.dart';
import '../../3_domain/repositories/database_repository.dart';
import '../../3_domain/repositories/settings_repository.dart';
import '../../failures/failures.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;
  final DatabaseRepository _databaseRepository;

  SettingsBloc({required SettingsRepository settingsRepository, required DatabaseRepository databaseRepository})
      : _settingsRepository = settingsRepository,
        _databaseRepository = databaseRepository,
        super(SettingsState.initial()) {
    on<SetSettingsStateToInitialEvent>(_onSetSettingsStateToInitial);
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<SaveMainSettingsEvent>(_onSaveMainSettings);
  }

  void _onSetSettingsStateToInitial(SetSettingsStateToInitialEvent event, Emitter<SettingsState> emit) {
    emit(SettingsState.initial());
  }

  void _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoadingSettingsOnOserve: true));

    final fosCurrencies = await _databaseRepository.getCurrencies();
    if (fosCurrencies.isLeft()) {
      emit(state.copyWith(failure: fosCurrencies.getLeft()));
      return;
    }

    final availableCurrencies = fosCurrencies.getRight();

    final fos = await _settingsRepository.getSettings();
    if (fos.isLeft()) {
      emit(state.copyWith(failure: fos.getLeft()));
      return;
    }

    final settings = fos.getRight();

    emit(state.copyWith(
      isLoadingSettingsOnOserve: false,
      settings: settings,
      availableCurrencies: availableCurrencies,
      fosSettingsOnObserveOption: optionOf(fos),
    ));
    emit(state.copyWith(fosSettingsOnObserveOption: none()));
  }

  void _onUpdateSettings(UpdateSettingsEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(settings: event.settings));
  }

  void _onSaveMainSettings(SaveMainSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoadingSettingsOnUpdate: true));

    final fos = await _settingsRepository.updateSettings(state.settings!);
    if (fos.isLeft()) {
      emit(state.copyWith(failure: fos.getLeft()));
      return;
    }

    final settings = fos.getRight();

    emit(state.copyWith(
      isLoadingSettingsOnUpdate: false,
      settings: settings,
      fosSettingsOnUpdateOption: optionOf(fos),
    ));
    emit(state.copyWith(fosSettingsOnUpdateOption: none()));
  }
}
