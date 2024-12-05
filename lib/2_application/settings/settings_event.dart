part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class SetSettingsStateToInitialEvent extends SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateSettingsEvent extends SettingsEvent {
  final MainSettings settings;

  UpdateSettingsEvent({required this.settings});
}

class SaveMainSettingsEvent extends SettingsEvent {}
