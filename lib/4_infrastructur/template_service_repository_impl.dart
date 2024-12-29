import 'package:dartz/dartz.dart';
import 'package:four_detailer/3_domain/models/template_service.dart';
import 'package:four_detailer/failures/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../3_domain/repositories/template_service_repository.dart';
import '../constants.dart';
import '../core/core.dart';
import 'functions/functions.dart';

class TemplateServiceRepositoryImpl implements TemplateServiceRepository {
  final SupabaseClient supabase;

  const TemplateServiceRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, TemplateService>> createTemplateService(TemplateService templateService) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    final branchId = await getMainBranchId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));
    if (branchId == null) return Left(GeneralFailure(message: 'Die Hauptfiliale konnte nicht aus der Datenbank geladen werden'));

    final updatedTemplateService = templateService.copyWith(ownerId: ownerId, branchId: branchId);
    final templateServiceJson = updatedTemplateService.toJson();
    templateServiceJson.remove('id');
    templateServiceJson.remove('items');

    try {
      final response = await supabase.from('template_services').insert(templateServiceJson).select().single();

      return Right(TemplateService.fromJson(response));
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, TemplateServiceItem>> createTemplateServiceItem(
      TemplateServiceItem templateServiceItem, String templateServiceId) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final updatedTemplateServiceItem = templateServiceItem.copyWith(templateServiceId: templateServiceId);
    final templateServiceItemJson = updatedTemplateServiceItem.toJson();
    templateServiceItemJson.remove('id');

    try {
      final response = await supabase.from('template_service_items').insert(templateServiceItemJson).select().single();

      return Right(TemplateServiceItem.fromJson(response));
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<TemplateService>>> getTemplateServices(TemplateServiceType type) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    final branchId = await getMainBranchId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));
    if (branchId == null) return Left(GeneralFailure(message: 'Die Hauptfiliale konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase
          .from('template_services')
          .select('*, items:template_service_items(*)')
          .eq('branch_id', branchId)
          .eq('owner_id', ownerId)
          .eq('type', type.toJsonString());

      final templateServices = (response as List).map((service) => TemplateService.fromJson(service)).toList();
      return Right(templateServices);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Vorlagen ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Vorlagen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<TemplateService>>> updatePositionsOfTemplateServices(List<TemplateService> templateServices) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      final updates = templateServices
          .map((templateService) => {
                'id': templateService.id,
                'owner_id': templateService.ownerId,
                'branch_id': templateService.branchId,
                'name': templateService.name,
                'description': templateService.description,
                'position': templateService.position,
                'type': templateService.type.toJsonString(),
              })
          .toList();

      final response = await supabase.from('template_services').upsert(updates).select();

      final updatedTemplateServices = (response as List).map((templateService) => TemplateService.fromJson(templateService)).toList();

      return Right(updatedTemplateServices);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Vorlagenpositionen ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Vorlagenpositionen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<TemplateServiceItem>>> updatePositionsOfTemplateServiceItems(
      List<TemplateServiceItem> templateServiceItems) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      final updates = templateServiceItems
          .map((item) => {
                'id': item.id,
                'template_service_id': item.templateServiceId,
                'name': item.name,
                'description': item.description,
                'position': item.position,
              })
          .toList();

      final response = await supabase.from('template_service_items').upsert(updates).select();

      final updatedTemplateServiceItems = (response as List).map((item) => TemplateServiceItem.fromJson(item)).toList();

      return Right(updatedTemplateServiceItems);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Vorlagenpositionen ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Vorlagenpositionen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, TemplateService>> updateTemplateService(TemplateService templateService) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      // Template Service Update ohne items durchführen
      final templateServiceJson = templateService.toJson();
      templateServiceJson.remove('items'); // items aus dem Update entfernen

      await supabase.from('template_services').update(templateServiceJson).eq('id', templateService.id);

      // Dann die aktualisierte Version mit items in einer separaten Abfrage holen
      final response = await supabase.from('template_services').select('*, items:template_service_items(*)').eq('id', templateService.id).single();

      return Right(TemplateService.fromJson(response));
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, TemplateServiceItem>> updateTemplateServiceItem(TemplateServiceItem templateServiceItem) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      // Template Service Update ohne items durchführen
      final templateServiceItemJson = templateServiceItem.toJson();

      await supabase.from('template_service_items').update(templateServiceItemJson).eq('id', templateServiceItem.id);

      // Dann die aktualisierte Version mit items in einer separaten Abfrage holen
      final response = await supabase.from('template_service_items').select().eq('id', templateServiceItem.id).single();

      return Right(TemplateServiceItem.fromJson(response));
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteTemplateService(String templateServiceId) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      await supabase.from('template_services').delete().eq('id', templateServiceId);
      return const Right(unit);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Löschen der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Löschen der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteTemplateServiceItem(String templateServiceItemId) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      await supabase.from('template_service_items').delete().eq('id', templateServiceItemId);
      return const Right(unit);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Löschen der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Löschen der Vorlage ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
