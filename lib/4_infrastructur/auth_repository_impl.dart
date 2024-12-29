import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../constants.dart';
import '../3_domain/models/models.dart';
import '../3_domain/repositories/auth_repository.dart';
import '../core/core.dart';
import '../failures/failures.dart';
import 'functions/functions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient supabase;

  const AuthRepositoryImpl({required this.supabase});

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({required String email, required String password}) async {
    try {
      await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );

      return right(unit);
    } on AuthApiException catch (e) {
      logger.e(e.statusCode);
      logger.e(e.message);

      switch (e.message) {
        case 'Invalid login credentials':
          return left(WrongEmailOrPasswordFailure());
        case 'Email not confirmed':
          return left(EmailNotConfirmedFailure());
        default:
          return left(AuthServerFailure());
      }
    } catch (e) {
      logger.e(e);
      logger.e((e as AuthException).message);
      logger.e((e).statusCode);
      return left(AuthServerFailure());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await supabase.auth.signInWithPassword(email: email.trim(), password: password.trim());

      return right(unit);
    } on AuthApiException catch (e) {
      logger.e(e.statusCode);
      logger.e(e.message);

      switch (e.message) {
        case 'Invalid login credentials':
          return Left(WrongEmailOrPasswordFailure());
        case 'Email not confirmed':
          return Left(EmailNotConfirmedFailure());
        default:
          return Left(AuthServerFailure());
      }
    } catch (e) {
      return Left(AuthServerFailure());
    }
  }

  @override
  Future<void> signOut() async {
    logger.i('// ###### signOut pressed ###### //');
    await supabase.auth.signOut();
  }

  @override
  bool checkIfUserIsSignedIn() {
    final session = supabase.auth.currentSession;
    logger.i(session);
    return session != null ? true : false;
  }

  @override
  Future<Either<AuthFailure, Unit>> sendPasswordResetEmail({required String email}) async {
    try {
      await supabase.auth.resetPasswordForEmail(email, redirectTo: 'io.supabase.flutterquickstart://login-callback/');
      return right(unit);
    } catch (e) {
      logger.e(e);
      return left(AuthServerFailure());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> resetPasswordForEmail({required String email, required String password}) async {
    try {
      final response = await supabase.auth.updateUser(UserAttributes(email: email, password: password));
      logger.i(response);
      return right(unit);
    } catch (e) {
      logger.e(e);
      return left(AuthServerFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> createNewCondtionerOnSignUp({
    required Conditioner conditioner,
    required MainSettings settings,
    required Branch branch,
    required CashRegister cashRegister,
    required PaymentMethod paymentMethod,
  }) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());

    try {
      await supabase.rpc('create_new_conditioner_on_sign_up', params: {
        'p_id': getCurrentUserId(),
        'conditioner_json': conditioner.toJson(),
        'settings_json': settings.toJson(),
        'branch_json': branch.toJson(),
        'cash_register_json': cashRegister.toJson(),
        'payment_method_json': paymentMethod.toJson(),
      });

      // await supabase.rpc('create_conditioner', params: {
      //   'conditioner_json':  conditioner.toJson(),
      //   'owner_id': getCurrentUserId(),
      // });

      return const Right(unit);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: e.message));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim erstellen deines Users ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
