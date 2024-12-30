part of 'conditioners_overview_bloc.dart';

@immutable
sealed class ConditionersOverviewEvent {}

class SetConditionersStateToInitialEvent extends ConditionersOverviewEvent {}

class GetConditionersEvent extends ConditionersOverviewEvent {
  final bool isLoading;

  GetConditionersEvent({this.isLoading = true});
}

class CreateNewConditionerEvent extends ConditionersOverviewEvent {
  final Conditioner conditioner;
  final String password;

  CreateNewConditionerEvent({required this.conditioner, required this.password});
}
