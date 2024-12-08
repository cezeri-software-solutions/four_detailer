part of 'branch_detail_bloc.dart';

@immutable
sealed class BranchDetailEvent {}

class SetBranchDetailStateToInitialEvent extends BranchDetailEvent {}

class GetBranchEvent extends BranchDetailEvent {
  final String branchId;

  GetBranchEvent({required this.branchId});
}

class UpdateBranchEvent extends BranchDetailEvent {
  final Branch branch;

  UpdateBranchEvent({required this.branch});
}

class ShowBranchImageEditingChangedEvent extends BranchDetailEvent {}

class IsEditModeChangedEvent extends BranchDetailEvent {}

class BranchAddEditImageEvent extends BranchDetailEvent {
  final BuildContext context;
  final MyImageSource source;

  BranchAddEditImageEvent({required this.context, required this.source});
}

class BranchRemoveImageEvent extends BranchDetailEvent {
  final BuildContext context;

  BranchRemoveImageEvent({required this.context});
}
