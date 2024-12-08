part of 'conditioner_bloc.dart';

@immutable
sealed class ConditionerEvent {}

class SetConditionerStateToInitialEvnet extends ConditionerEvent {}

class GetCurrentConditionerEvent extends ConditionerEvent {}

class UpdatetConditionerEvent extends ConditionerEvent {
  final Conditioner conditioner;

  UpdatetConditionerEvent({required this.conditioner});
}

class ShowImageEditingChangedEvent extends ConditionerEvent {}

class IsEditModeChangedEvent extends ConditionerEvent {}

class IsPaymentEditModeChangedEvent extends ConditionerEvent {}

class ConditionerAddEditImageEvent extends ConditionerEvent {
  final BuildContext context;
  final MyImageSource source;

  ConditionerAddEditImageEvent({required this.context, required this.source});
}

class ConditionerRemoveImageEvent extends ConditionerEvent {
  final BuildContext context;

  ConditionerRemoveImageEvent({required this.context});
}
