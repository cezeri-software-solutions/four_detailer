import 'package:dartz/dartz.dart';
import 'package:four_detailer/3_domain/repositories/conditioner_repository.dart';
import 'package:four_detailer/failures/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../3_domain/models/models.dart';
import '../constants.dart';
import '../core/core.dart';
import 'functions/functions.dart';

class ConditionerRepositoryImpl implements ConditionerRepository {
  final SupabaseClient supabase;

  const ConditionerRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, Unit>> createConditionerOnSignUp(Conditioner conditioner) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final currentUserUid = supabase.auth.currentUser!.id;

    final newClient = conditioner.copyWith(id: currentUserUid, ownerId: currentUserUid);
    final newSettings = MainSettings.empty();
    final settingsJson = newSettings.toJson();
    settingsJson.remove('id');

    try {
      await supabase.from('conditoners').insert(newClient.toJson());

      await supabase.from('settings').insert(newSettings.toJson());

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen der Userdaten oder den Einstellungen ist ein Fehler aufgetreten.'));
    }
  }

  @override
  Future<Either<AbstractFailure, Conditioner>> getCurConditioner() async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final currentUserUid = supabase.auth.currentUser!.id;

    try {
      final response = await supabase.rpc('get_conditioner_by_id', params: {'conditioner_id': currentUserUid});

      final conditioner = Conditioner.fromJson(response);

      return Right(conditioner);
    } on PostgrestException catch (e) {
      if (e.message.contains('does not exist') || e.message.contains('not found') || e.toString().contains('The result contains 0 rows')) {
        logger.e(e);
        return Left(EmptyFailure(message: 'Der User konnte nicht in der Datenbank gefunden werden!'));
      } else {
        logger.e(e);
        return Left(GeneralFailure(message: 'Beim Laden deines Users ist ein Fehler aufgetreten. Error: $e'));
      }
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden deines Users ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Conditioner>> getConditionerById(String id) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      final response = await supabase.rpc('get_conditioner_by_id', params: {'conditioner_id': id});

      final conditioner = Conditioner.fromJson(response);

      return Right(conditioner);
    } on PostgrestException catch (e) {
      if (e.message.contains('does not exist') || e.message.contains('not found') || e.toString().contains('The result contains 0 rows')) {
        logger.e(e);
        return Left(EmptyFailure(message: 'Der User konnte nicht in der Datenbank gefunden werden!'));
      } else {
        logger.e(e);
        return Left(GeneralFailure(message: 'Beim Laden deines Users ist ein Fehler aufgetreten. Error: $e'));
      }
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden deines Users ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Conditioner>> updateConditioner(Conditioner conditioner) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final conditionerId = conditioner.id;

    try {
      final response = await supabase.rpc('update_conditioner', params: {'conditioner_id': conditionerId, 'conditioner_data': conditioner.toJson()});

      final updatedConditioner = Conditioner.fromJson(response);

      return Right(updatedConditioner);
    } on PostgrestException catch (e) {
      if (e.message.contains('does not exist') || e.message.contains('not found') || e.toString().contains('The result contains 0 rows')) {
        logger.e(e);
        return Left(EmptyFailure(message: 'Der User konnte nicht in der Datenbank gefunden werden!'));
      } else {
        logger.e(e);
        return Left(GeneralFailure(message: 'Beim Aktualisieren des Users: ${conditioner.name} ist ein Fehler aufgetreten. Error: $e'));
      }
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren des Users: ${conditioner.name} ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Conditioner>> uploadConditionerImage({
    required String conditionerId,
    required MyFile myFile,
    required String? imageUrl,
  }) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final fosBucketExists = await checkIfBucketExists(ownerId);
      if (fosBucketExists.isLeft()) return Left(GeneralFailure(message: fosBucketExists.getLeft().message));

      final bucketExists = fosBucketExists.getRight();
      if (!bucketExists) {
        final fosCreateBucket = await createNewBucket(ownerId);
        if (fosCreateBucket.isLeft()) return Left(GeneralFailure(message: fosCreateBucket.getLeft().message));
      }

      if (imageUrl != null) await deleteFilesFromSupabaseStorageByUrl(ownerId, [imageUrl]);

      final fosUploadImage = await uploadFileToStorage(bucketName: ownerId, path: 'conditioner-image', myFile: myFile, useGivenName: false);
      if (fosUploadImage.isLeft()) return Left(GeneralFailure(message: fosUploadImage.getLeft().message));

      final url = fosUploadImage.getRight();

      await supabase.from('conditioners').update({'image_url': url}).eq('id', conditionerId);

      final fosConditioner = await getConditionerById(conditionerId);
      if (fosConditioner.isLeft()) return Left(GeneralFailure(message: fosConditioner.getLeft().message));

      final updatedConditioner = fosConditioner.getRight();

      return Right(updatedConditioner);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: 'Beim Aktualisieren des Profilbildes ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren des Profilbildes ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Conditioner>> deleteConditionerImage(String conditionerId, String imageUrl) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await deleteFilesFromSupabaseStorageByUrl(ownerId, [imageUrl]);

      await supabase.from('conditioners').update({'image_url': ''}).eq('id', conditionerId);

      final fosConditioner = await getConditionerById(conditionerId);
      if (fosConditioner.isLeft()) return Left(GeneralFailure(message: fosConditioner.getLeft().message));

      final updatedConditioner = fosConditioner.getRight();

      return Right(updatedConditioner);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: 'Beim Aktualisieren des Profilbildes ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren des Profilbildes ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
