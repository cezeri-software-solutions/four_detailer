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
    final branchSettingsId = await getBranchSettingsId();
    if (branchSettingsId == null) throw GeneralFailure(message: 'Die Einstellungen konnten nicht aus der Datenbank geladen werden');

    try {
      final response = await supabase.rpc('get_main_settings', params: {'settings_id': branchSettingsId});

      print('response: $response');

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
  Future<Either<AbstractFailure, MainSettings>> updateSettings(MainSettings settings) async {
    if (!await checkInternetConnection()) throw NoConnectionFailure();

    try {
      final response = await supabase.rpc('update_main_settings', params: {'settings_json': settings.toJson()});

      print('response: $response');

      final updatedSettings = MainSettings.fromJson(response);

      return Right(updatedSettings);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Einstellungen ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Einstellungen ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
