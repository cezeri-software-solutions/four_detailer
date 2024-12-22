part of 'conditioners_overview_bloc.dart';

@immutable
sealed class ConditionersOverviewEvent {}

class SetConditionersStateToInitialEvent extends ConditionersOverviewEvent {}

class GetConditionersEvent extends ConditionersOverviewEvent {}
