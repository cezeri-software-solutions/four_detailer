import 'package:dartz/dartz.dart';
import 'package:four_detailer/3_domain/models/services/service.dart';
import 'package:four_detailer/failures/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../3_domain/repositories/service_repository.dart';
import '../constants.dart';
import '../core/core.dart';
import 'functions/functions.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final SupabaseClient supabase;

  const ServiceRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, Service>> createService(Service service) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    final branchId = await getMainBranchId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));
    if (branchId == null) return Left(GeneralFailure(message: 'Die Hauptfiliale konnte nicht aus der Datenbank geladen werden'));

    final serviceJson = service.toJson();
    serviceJson.addEntries([MapEntry('owner_id', ownerId), MapEntry('branch_id', branchId)]);

    printJson(serviceJson);

    try {
      final response = await supabase.rpc('create_service', params: {'p_service': serviceJson, 'p_owner_id': ownerId, 'p_branch_id': branchId});

      printJson(response);

      final createdService = Service.fromJson(response);

      return right(createdService);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen der Dienstleistung ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen der Dienstleistung ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Service>> getServiceById(String serviceId) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      final response = await supabase.rpc('get_service_by_id', params: {'p_service_id': serviceId});

      final service = Service.fromJson(response);

      return right(service);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Dienstleistung ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Dienstleistung ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, ({List<Service> services, int totalCount})>> getServices({
    required String searchTerm,
    required int itemsPerPage,
    required int currentPage,
  }) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    final branchId = await getMainBranchId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));
    if (branchId == null) return Left(GeneralFailure(message: 'Die Hauptfiliale konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_services_by_branch_id_paginated', params: {
        'p_branch_id': branchId,
        'p_search_text': searchTerm,
        'p_current_page': currentPage,
        'p_items_per_page': itemsPerPage,
      });

      if ((response['data'] as List<dynamic>).isNotEmpty) {
        print('vehicle_sizes');
        printJson((response['data'] as List<dynamic>).firstWhere((element) => element['id'] == 'eb8b88f7-be91-423d-a494-e71ee9eaf768'));
      }

      final List<Service> services = (response['data'] as List<dynamic>).map((service) => Service.fromJson(service as Map<String, dynamic>)).toList();
      final int totalCount = response['total_count'];

      return right((services: services, totalCount: totalCount));
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Dienstleistungen ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Dienstleistungen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Service>> updateService(Service service) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    printJson(service.toJson());

    try {
      final response = await supabase.rpc('update_service', params: {'p_service_id': service.id, 'p_service': service.toJson()});

      final updatedService = Service.fromJson(response);

      return Right(updatedService);
    } on PostgrestException catch (e) {
      if (e.message.contains('does not exist') || e.message.contains('not found') || e.toString().contains('The result contains 0 rows')) {
        logger.e(e);
        return Left(EmptyFailure(message: 'Die Dienstleistung konnte nicht in der Datenbank gefunden werden!'));
      } else {
        logger.e(e);
        return Left(GeneralFailure(message: 'Beim Aktualisieren der Dienstleistung: ${service.name} ist ein Fehler aufgetreten. Error: $e'));
      }
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Dienstleistung: ${service.name} ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Service>>> updatePositionsOfServices(List<Service> services) {
    // TODO: implement updatePositionsOfServices
    throw UnimplementedError();
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteService(String serviceId) {
    // TODO: implement deleteService
    throw UnimplementedError();
  }
}
