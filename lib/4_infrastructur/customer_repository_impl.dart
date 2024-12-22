import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../3_domain/models/models.dart';
import '../3_domain/repositories/customer_repository.dart';
import '../constants.dart';
import '../core/core.dart';
import '../failures/failures.dart';
import 'functions/functions.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final SupabaseClient supabase;

  const CustomerRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, Customer>> createCustomer(Customer customer) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final customerJson = customer.toJson();
    customerJson.addEntries([MapEntry('owner_id', ownerId)]);

    printJson(customerJson);

    try {
      final response = await supabase.rpc('create_customer', params: {'customer_json': customerJson, 'p_owner_id': ownerId});

      final createdCustomer = Customer.fromJson(response);

      return right(createdCustomer);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen des Kunden ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen des Kunden ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Customer>> getCustomerById(String customerId) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      final response = await supabase.rpc('get_customer_by_id', params: {'p_customer_id': customerId});

      final customer = Customer.fromJson(response);

      return right(customer);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden des Kunden ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden des Kunden ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, ({List<Customer> customers, int totalCount})>> getCustomers({
    required String searchTerm,
    required int itemsPerPage,
    required int currentPage,
  }) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_customers_by_owner_id_paginated', params: {
        'p_owner_id': ownerId,
        'p_search_text': searchTerm,
        'p_current_page': currentPage,
        'p_items_per_page': itemsPerPage,
      });

      final List<Customer> customers =
          (response['data'] as List<dynamic>).map((customer) => Customer.fromJson(customer as Map<String, dynamic>)).toList();
      final int totalCount = response['total_count'];

      return right((customers: customers, totalCount: totalCount));
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Kunden ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Kunden ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Customer>> updateCustomer(Customer customer) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    printJson(customer.toJson());

    try {
      final response = await supabase.rpc('update_customer', params: {'p_customer_id': customer.id, 'p_customer_data': customer.toJson()});

      final updatedCustomer = Customer.fromJson(response);

      return Right(updatedCustomer);
    } on PostgrestException catch (e) {
      if (e.message.contains('does not exist') || e.message.contains('not found') || e.toString().contains('The result contains 0 rows')) {
        logger.e(e);
        return Left(EmptyFailure(message: 'Der Kunde konnte nicht in der Datenbank gefunden werden!'));
      } else {
        logger.e(e);
        return Left(GeneralFailure(message: 'Beim Aktualisieren des Kunden: ${customer.name} ist ein Fehler aufgetreten. Error: $e'));
      }
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren des Kunden: ${customer.name} ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteCustomers(List<String> customerIds) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await supabase.rpc('delete_customers', params: {'p_customer_ids': customerIds, 'p_owner_id': ownerId});
      return right(unit);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Löschen der Kunden ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Löschen der Kunden ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
