import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchace_state.freezed.dart';

@freezed
class PurchaceState with _$PurchaceState {
  const factory PurchaceState({
    @Default('https://ccf-autopflege.at') String currentUrl,
    @Default(false) bool isLoading,
  }) = _PurchaceState;
}
