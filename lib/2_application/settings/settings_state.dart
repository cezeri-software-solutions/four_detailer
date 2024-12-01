part of 'settings_bloc.dart';

@immutable
class SettingsState {
  final MainSettings? settings;
  final List<Currency>? availableCurrencies;
  final AbstractFailure? failure;
  final bool isLoadingSettingsOnOserve;
  final bool isLoadingSettingsOnUpdate;
  final Option<Either<AbstractFailure, MainSettings>> fosSettingsOnObserveOption;
  final Option<Either<AbstractFailure, MainSettings>> fosSettingsOnUpdateOption;

  const SettingsState({
    required this.settings,
    required this.availableCurrencies,
    required this.failure,
    required this.isLoadingSettingsOnOserve,
    required this.isLoadingSettingsOnUpdate,
    required this.fosSettingsOnObserveOption,
    required this.fosSettingsOnUpdateOption,
  });

  factory SettingsState.initial() => SettingsState(
        settings: null,
        availableCurrencies: null,
        failure: null,
        isLoadingSettingsOnOserve: true,
        isLoadingSettingsOnUpdate: false,
        fosSettingsOnObserveOption: none(),
        fosSettingsOnUpdateOption: none(),
      );

  SettingsState copyWith({
    MainSettings? settings,
    List<Currency>? availableCurrencies,
    bool? resetFailure,
    AbstractFailure? failure,
    bool? isLoadingSettingsOnOserve,
    bool? isLoadingSettingsOnUpdate,
    Option<Either<AbstractFailure, MainSettings>>? fosSettingsOnObserveOption,
    Option<Either<AbstractFailure, MainSettings>>? fosSettingsOnUpdateOption,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingSettingsOnOserve: isLoadingSettingsOnOserve ?? this.isLoadingSettingsOnOserve,
      isLoadingSettingsOnUpdate: isLoadingSettingsOnUpdate ?? this.isLoadingSettingsOnUpdate,
      fosSettingsOnObserveOption: fosSettingsOnObserveOption ?? this.fosSettingsOnObserveOption,
      fosSettingsOnUpdateOption: fosSettingsOnUpdateOption ?? this.fosSettingsOnUpdateOption,
    );
  }
}
