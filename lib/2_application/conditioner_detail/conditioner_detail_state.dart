part of 'conditioner_detail_bloc.dart';

@immutable
class ConditionerDetailState {
  final Conditioner? conditioner;
  final AbstractFailure? failure;
  final bool isLoadingConditionerOnObserve;
  final bool isLoadingConditionerOnUpdate;
  final Option<Either<AbstractFailure, Conditioner>> fosConditionerOnObserveOption;
  final Option<Either<AbstractFailure, Conditioner>> fosConditionerOnUpdateOption;
  //* Helper
  final bool showImageEditing;
  final bool isInEditMode;
  final bool isInPaymentEditMode;

  const ConditionerDetailState({
    required this.conditioner,
    required this.failure,
    required this.isLoadingConditionerOnObserve,
    required this.isLoadingConditionerOnUpdate,
    required this.fosConditionerOnObserveOption,
    required this.fosConditionerOnUpdateOption,
    required this.showImageEditing,
    required this.isInEditMode,
    required this.isInPaymentEditMode,
  });

  factory ConditionerDetailState.initial() => ConditionerDetailState(
        conditioner: null,
        failure: null,
        isLoadingConditionerOnObserve: true,
        isLoadingConditionerOnUpdate: false,
        fosConditionerOnObserveOption: none(),
        fosConditionerOnUpdateOption: none(),
        showImageEditing: false,
        isInEditMode: false,
        isInPaymentEditMode: false,
      );

  ConditionerDetailState copyWith({
    Conditioner? conditioner,
    AbstractFailure? failure,
    bool? resetFailure,
    bool? isLoadingConditionerOnObserve,
    bool? isLoadingConditionerOnUpdate,
    Option<Either<AbstractFailure, Conditioner>>? fosConditionerOnObserveOption,
    Option<Either<AbstractFailure, Conditioner>>? fosConditionerOnUpdateOption,
    bool? showImageEditing,
    bool? isInEditMode,
    bool? isInPaymentEditMode,
  }) {
    return ConditionerDetailState(
      conditioner: conditioner ?? this.conditioner,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingConditionerOnObserve: isLoadingConditionerOnObserve ?? this.isLoadingConditionerOnObserve,
      isLoadingConditionerOnUpdate: isLoadingConditionerOnUpdate ?? this.isLoadingConditionerOnUpdate,
      fosConditionerOnObserveOption: fosConditionerOnObserveOption ?? this.fosConditionerOnObserveOption,
      fosConditionerOnUpdateOption: fosConditionerOnUpdateOption ?? this.fosConditionerOnUpdateOption,
      showImageEditing: showImageEditing ?? this.showImageEditing,
      isInEditMode: isInEditMode ?? this.isInEditMode,
      isInPaymentEditMode: isInPaymentEditMode ?? this.isInPaymentEditMode,
    );
  }
}
