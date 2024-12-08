import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../3_domain/models/models.dart';
import '../../3_domain/repositories/branch_repository.dart';
import '../../failures/failures.dart';

part 'branches_overview_event.dart';
part 'branches_overview_state.dart';

class BranchesOverviewBloc extends Bloc<BranchesOverviewEvent, BranchesOverviewState> {
  final BranchRepository _branchRepository;

  BranchesOverviewBloc({required BranchRepository branchRepository})
      : _branchRepository = branchRepository,
        super(BranchesOverviewState.initial()) {
    on<SetBranchesStateToInitialEvent>(_onSetBranchesStateToInitial);
    on<GetBranchesEvent>(_onGetBranches);
  }

  void _onSetBranchesStateToInitial(SetBranchesStateToInitialEvent event, Emitter<BranchesOverviewState> emit) {
    emit(BranchesOverviewState.initial());
  }

  void _onGetBranches(GetBranchesEvent event, Emitter<BranchesOverviewState> emit) async {
    emit(state.copyWith(isLoadingBranches: true));

    final fos = await _branchRepository.getBranches();
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (branches) => emit(state.copyWith(listOfBranches: branches, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingBranches: false, fosBranchesOption: optionOf(fos)));
    emit(state.copyWith(fosBranchesOption: none()));
  }
}
