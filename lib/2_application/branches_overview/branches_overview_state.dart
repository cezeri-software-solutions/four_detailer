part of 'branches_overview_bloc.dart';

@immutable
class BranchesOverviewState {
  final List<Branch>? listOfBranches;
  final AbstractFailure? failure;
  final bool isLoadingBranches;
  final Option<Either<AbstractFailure, List<Branch>>> fosBranchesOption;

  const BranchesOverviewState({
    required this.listOfBranches,
    required this.failure,
    required this.isLoadingBranches,
    required this.fosBranchesOption,
  });

  factory BranchesOverviewState.initial() => BranchesOverviewState(
        listOfBranches: null,
        failure: null,
        isLoadingBranches: true,
        fosBranchesOption: none(),
      );

  BranchesOverviewState copyWith({
    List<Branch>? listOfBranches,
    bool? resetFailure,
    AbstractFailure? failure,
    bool? isLoadingBranches,
    Option<Either<AbstractFailure, List<Branch>>>? fosBranchesOption,
  }) {
    return BranchesOverviewState(
      listOfBranches: listOfBranches ?? this.listOfBranches,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingBranches: isLoadingBranches ?? this.isLoadingBranches,
      fosBranchesOption: fosBranchesOption ?? this.fosBranchesOption,
    );
  }
}
