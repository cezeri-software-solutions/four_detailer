import 'package:dartz/dartz.dart';

import '../../failures/failures.dart';
import '../models/models.dart';

abstract class ConditionerRepository {
  Future<Either<AbstractFailure, Unit>> createConditionerOnSignUp(Conditioner conditioner);
  Future<Either<AbstractFailure, Conditioner>> getCurConditioner();
  Future<Either<AbstractFailure, Conditioner>> getConditionerById(String id);
  Future<Either<AbstractFailure, Conditioner>> updateConditioner(Conditioner conditioner);
  Future<Either<AbstractFailure, Conditioner>> uploadConditionerImage({
    required String conditionerId,
    required MyFile myFile,
    required String? imageUrl,
  });
  Future<Either<AbstractFailure, Conditioner>> deleteConditionerImage(String conditionerId, String imageUrl);
}
