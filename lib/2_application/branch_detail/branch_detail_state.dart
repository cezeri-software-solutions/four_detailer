part of 'branch_detail_bloc.dart';

@immutable
class BranchDetailState {
  final Branch? branch;
  final AbstractFailure? failure;
  final bool isLoadingBranchOnObserve;
  final bool isLoadingBranchOnUpdate;
  final Option<Either<AbstractFailure, Branch>> fosBranchOnObserveOption;
  final Option<Either<AbstractFailure, Branch>> fosBranchOnUpdateOption;
  //* Helper
  final bool isInEditMode;
  final bool showImageEditing;

  const BranchDetailState({
    required this.branch,
    required this.failure,
    required this.isLoadingBranchOnObserve,
    required this.isLoadingBranchOnUpdate,
    required this.fosBranchOnObserveOption,
    required this.fosBranchOnUpdateOption,
    required this.isInEditMode,
    required this.showImageEditing,
  });

  factory BranchDetailState.initial() => BranchDetailState(
        branch: null,
        failure: null,
        isLoadingBranchOnObserve: true,
        isLoadingBranchOnUpdate: false,
        fosBranchOnObserveOption: none(),
        fosBranchOnUpdateOption: none(),
        isInEditMode: false,
        showImageEditing: false,
      );

  BranchDetailState copyWith({
    Branch? branch,
    bool? resetFailure,
    AbstractFailure? failure,
    bool? isLoadingBranchOnObserve,
    bool? isLoadingBranchOnUpdate,
    Option<Either<AbstractFailure, Branch>>? fosBranchOnObserveOption,
    Option<Either<AbstractFailure, Branch>>? fosBranchOnUpdateOption,
    bool? isInEditMode,
    bool? showImageEditing,
  }) {
    return BranchDetailState(
      branch: branch ?? this.branch,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingBranchOnObserve: isLoadingBranchOnObserve ?? this.isLoadingBranchOnObserve,
      isLoadingBranchOnUpdate: isLoadingBranchOnUpdate ?? this.isLoadingBranchOnUpdate,
      fosBranchOnObserveOption: fosBranchOnObserveOption ?? this.fosBranchOnObserveOption,
      fosBranchOnUpdateOption: fosBranchOnUpdateOption ?? this.fosBranchOnUpdateOption,
      isInEditMode: isInEditMode ?? this.isInEditMode,
      showImageEditing: showImageEditing ?? this.showImageEditing,
    );
  }
}
