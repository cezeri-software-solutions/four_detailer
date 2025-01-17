import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchace_event.freezed.dart';

@freezed
class PurchaceEvent with _$PurchaceEvent {
  const factory PurchaceEvent.urlChanged(String url) = _UrlChanged;
  const factory PurchaceEvent.loadingChanged(bool isLoading) = _LoadingChanged;
}
