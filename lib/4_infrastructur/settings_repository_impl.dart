import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/3_domain/models/models.dart';
import '/3_domain/repositories/settings_repository.dart';
import '/constants.dart';
import '/core/core.dart';
import '/failures/failures.dart';
import 'functions/functions.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SupabaseClient supabase;

  const SettingsRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, MainSettings>> getSettings() async {
    if (!await checkInternetConnection()) throw NoConnectionFailure();
    final ownerId = await getOwnerId();
    if (ownerId == null) throw GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden');

    try {
      final response = await supabase.rpc('get_main_settings', params: {'p_owner_id': ownerId});

      final settings = MainSettings.fromJson(response);

      return Right(settings);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Einstellungen ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Einstellungen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, MainSettings>> updateSettings(MainSettings settings) {
    // TODO: implement updateSettings
    throw UnimplementedError();
  }
}
