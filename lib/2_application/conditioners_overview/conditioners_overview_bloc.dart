import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../3_domain/models/models.dart';
import '../../3_domain/repositories/conditioner_repository.dart';
import '../../failures/failures.dart';

part 'conditioners_overview_event.dart';
part 'conditioners_overview_state.dart';

class ConditionersOverviewBloc extends Bloc<ConditionersOverviewEvent, ConditionersOverviewState> {
  final ConditionerRepository _conditionerRepository;

  ConditionersOverviewBloc({required ConditionerRepository conditionerRepository})
      : _conditionerRepository = conditionerRepository,
        super(ConditionersOverviewState.initial()) {
    on<SetConditionersStateToInitialEvent>(_onSetConditionersStateToInitial);
    on<GetConditionersEvent>(_onGetConditioners);
    on<CreateNewConditionerEvent>(_onCreateNewConditioner);
  }

  void _onSetConditionersStateToInitial(SetConditionersStateToInitialEvent event, Emitter<ConditionersOverviewState> emit) {
    emit(ConditionersOverviewState.initial());
  }

  void _onGetConditioners(GetConditionersEvent event, Emitter<ConditionersOverviewState> emit) async {
    if (event.isLoading) emit(state.copyWith(isLoadingConditioners: true));

    final fos = await _conditionerRepository.getConditioners();
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (conditioners) => emit(state.copyWith(listOfConditioners: conditioners, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingConditioners: false, fosConditionersOption: optionOf(fos)));
    emit(state.copyWith(fosConditionersOption: none()));
  }

  void _onCreateNewConditioner(CreateNewConditionerEvent event, Emitter<ConditionersOverviewState> emit) async {
    emit(state.copyWith(isLoadingCreateConditioner: true));

    final fos = await _conditionerRepository.createNewConditioner(event.conditioner, event.password);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (unit) {
        add(GetConditionersEvent(isLoading: false));
      },
    );

    emit(state.copyWith(isLoadingCreateConditioner: false, fosCreateConditionerOption: optionOf(fos)));
    emit(state.copyWith(fosCreateConditionerOption: none()));
  }
}
