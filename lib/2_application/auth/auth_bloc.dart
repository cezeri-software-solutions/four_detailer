import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../3_domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<SignOutPressedEvent>(_onSignOutPressed);
    on<AuthCheckRequestedEvent>(_onAuthCheckRequested);
  }

  void _onSignOutPressed(SignOutPressedEvent event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(AuthStateUnauthenticated());
  }

  void _onAuthCheckRequested(AuthCheckRequestedEvent event, Emitter<AuthState> emit) async {
    // await _authRepository.signOut();

    final userOption = _authRepository.checkIfUserIsSignedIn();
    emit(userOption ? AuthStateAuthenticated() : AuthStateUnauthenticated());
  }
}
