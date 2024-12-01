import 'package:dartz/dartz.dart';

import '../../failures/failures.dart';
import '../models/models.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({required String email, required String password});

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({required String email, required String password});

  Future<void> signOut();

  bool checkIfUserIsSignedIn();

  Future<Either<AuthFailure, Unit>> sendPasswordResetEmail({required String email});

  Future<Either<AuthFailure, Unit>> resetPasswordForEmail({required String email, required String password});

  Future<Either<AbstractFailure, Unit>> createNewCondtionerOnSignUp({
    required Conditioner conditioner,
    required MainSettings settings,
    required Branch branch,
    required CashRegister cashRegister,
    required PaymentMethod paymentMethod,
  });
}
