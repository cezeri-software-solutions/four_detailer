part of 'conditioner_detail_bloc.dart';

@immutable
sealed class ConditionerDetailEvent {}

class SetConditionerStateToInitialEvnet extends ConditionerDetailEvent {}

class GetCurrentConditionerEvent extends ConditionerDetailEvent {}

class UpdatetConditionerEvent extends ConditionerDetailEvent {
  final Conditioner conditioner;

  UpdatetConditionerEvent({required this.conditioner});
}

class ShowImageEditingChangedEvent extends ConditionerDetailEvent {}

class IsEditModeChangedEvent extends ConditionerDetailEvent {}

class IsPaymentEditModeChangedEvent extends ConditionerDetailEvent {}

class ConditionerAddEditImageEvent extends ConditionerDetailEvent {
  final BuildContext context;
  final MyImageSource source;

  ConditionerAddEditImageEvent({required this.context, required this.source});
}

class ConditionerRemoveImageEvent extends ConditionerDetailEvent {
  final BuildContext context;

  ConditionerRemoveImageEvent({required this.context});
}
