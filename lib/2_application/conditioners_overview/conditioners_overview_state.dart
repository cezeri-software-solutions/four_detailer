part of 'conditioners_overview_bloc.dart';

@immutable
class ConditionersOverviewState {
  final List<Conditioner>? listOfConditioners;
  final AbstractFailure? failure;
  final bool isLoadingConditioners;
  final bool isLoadingCreateConditioner;
  final Option<Either<AbstractFailure, List<Conditioner>>> fosConditionersOption;
  final Option<Either<AbstractFailure, Unit>> fosCreateConditionerOption;

  const ConditionersOverviewState({
    required this.listOfConditioners,
    required this.failure,
    required this.isLoadingConditioners,
    required this.isLoadingCreateConditioner,
    required this.fosConditionersOption,
    required this.fosCreateConditionerOption,
  });

  factory ConditionersOverviewState.initial() => ConditionersOverviewState(
        listOfConditioners: null,
        failure: null,
        isLoadingConditioners: true,
        isLoadingCreateConditioner: false,
        fosConditionersOption: none(),
        fosCreateConditionerOption: none(),
      );

  ConditionersOverviewState copyWith({
    List<Conditioner>? listOfConditioners,
    bool? resetFailure,
    AbstractFailure? failure,
    bool? isLoadingConditioners,
    bool? isLoadingCreateConditioner,
    Option<Either<AbstractFailure, List<Conditioner>>>? fosConditionersOption,
    Option<Either<AbstractFailure, Unit>>? fosCreateConditionerOption,
  }) {
    return ConditionersOverviewState(
      listOfConditioners: listOfConditioners ?? this.listOfConditioners,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingConditioners: isLoadingConditioners ?? this.isLoadingConditioners,
      isLoadingCreateConditioner: isLoadingCreateConditioner ?? this.isLoadingCreateConditioner,
      fosConditionersOption: fosConditionersOption ?? this.fosConditionersOption,
      fosCreateConditionerOption: fosCreateConditionerOption ?? this.fosCreateConditionerOption,
    );
  }
}
