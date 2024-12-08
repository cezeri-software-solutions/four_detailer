part of 'branches_overview_bloc.dart';

@immutable
sealed class BranchesOverviewEvent {}

class SetBranchesStateToInitialEvent extends BranchesOverviewEvent {}

class GetBranchesEvent extends BranchesOverviewEvent {}
