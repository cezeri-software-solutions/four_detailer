abstract class AbstractFailure {
  final String? message;

  const AbstractFailure({this.message});
}

class GeneralFailure extends AbstractFailure {
  GeneralFailure({required super.message});
}

class EmptyFailure extends AbstractFailure {
  EmptyFailure({required super.message});
}

class NoConnectionFailure extends AbstractFailure {
  NoConnectionFailure({super.message = 'No internet connection'});
}

enum AuthFailureType { wrongEmailOrPassword, emailNotConfirmed, authServer }

abstract class AuthFailure extends AbstractFailure {
  final AuthFailureType authFailureType;

  AuthFailure({required super.message, required this.authFailureType});
}

// ############### SignIn Failures #################

class WrongEmailOrPasswordFailure extends AuthFailure {
  WrongEmailOrPasswordFailure({super.message}) : super(authFailureType: AuthFailureType.wrongEmailOrPassword);
}

class EmailNotConfirmedFailure extends AuthFailure {
  EmailNotConfirmedFailure({super.message}) : super(authFailureType: AuthFailureType.emailNotConfirmed);
}

class AuthServerFailure extends AuthFailure {
  AuthServerFailure({super.message}) : super(authFailureType: AuthFailureType.authServer);
}
