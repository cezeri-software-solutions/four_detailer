import 'package:dartz/dartz.dart';

import '../../failures/failures.dart';
import '../models/models.dart';

abstract class SettingsRepository {
  Future<Either<AbstractFailure, MainSettings>> getSettings();
  Future<Either<AbstractFailure, MainSettings>> updateSettings(MainSettings settings);
}
