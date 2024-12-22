part of 'conditioners_overview_bloc.dart';

@immutable
class ConditionersOverviewState {
  final List<Conditioner>? listOfConditioners;
  final AbstractFailure? failure;
  final bool isLoadingConditioners;
  final Option<Either<AbstractFailure, List<Conditioner>>> fosConditionersOption;

  const ConditionersOverviewState({
    required this.listOfConditioners,
    required this.failure,
    required this.isLoadingConditioners,
    required this.fosConditionersOption,
  });

  factory ConditionersOverviewState.initial() => ConditionersOverviewState(
        listOfConditioners: null,
        failure: null,
        isLoadingConditioners: true,
        fosConditionersOption: none(),
      );

  ConditionersOverviewState copyWith({
    List<Conditioner>? listOfConditioners,
    bool? resetFailure,
    AbstractFailure? failure,
    bool? isLoadingConditioners,
    Option<Either<AbstractFailure, List<Conditioner>>>? fosConditionersOption,
  }) {
    return ConditionersOverviewState(
      listOfConditioners: listOfConditioners ?? this.listOfConditioners,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingConditioners: isLoadingConditioners ?? this.isLoadingConditioners,
      fosConditionersOption: fosConditionersOption ?? this.fosConditionersOption,
    );
  }
}
