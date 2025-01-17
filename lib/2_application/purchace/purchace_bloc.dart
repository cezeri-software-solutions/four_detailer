import 'package:flutter_bloc/flutter_bloc.dart';

import 'purchace_event.dart';
import 'purchace_state.dart';

class PurchaceBloc extends Bloc<PurchaceEvent, PurchaceState> {
  PurchaceBloc() : super(const PurchaceState()) {
    on<PurchaceEvent>((event, emit) {
      event.map(
        urlChanged: (e) => emit(state.copyWith(currentUrl: e.url)),
        loadingChanged: (e) => emit(state.copyWith(isLoading: e.isLoading)),
      );
    });
  }
}
