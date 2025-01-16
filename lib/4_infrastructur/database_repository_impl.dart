import 'package:dartz/dartz.dart';
import 'package:four_detailer/failures/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../3_domain/models/models.dart';
import '../3_domain/repositories/database_repository.dart';
import '../constants.dart';
import '../core/core.dart';
import 'functions/functions.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  final SupabaseClient supabase;

  const DatabaseRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, List<Country>>> getCountries() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());

    try {
      final response = await supabase.from('countries').select().order('name', ascending: true);

      final listOfCountries = response.map((e) => Country.fromJson(e)).toList();

      return Right(listOfCountries);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: e.message));
    }
  }

  @override
  Future<Either<AbstractFailure, Country>> getCountyByIsoCode(String isoCode) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());

    try {
      final response = await supabase.from('countries').select().eq('iso_code', isoCode).single();

      return Right(Country.fromJson(response));
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: e.message));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Currency>>> getCurrencies() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());

    try {
      final response = await supabase.from('currencies').select().order('name', ascending: true);

      final listOfCurrencies = response.map((e) => Currency.fromJson(e)).toList();

      return Right(listOfCurrencies);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: e.message));
    }
  }

  @override
  Future<Either<AbstractFailure, Currency>> getCurrencyById(String id) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());

    try {
      final response = await supabase.from('currencies').select().eq('id', id).single();

      return Right(Currency.fromJson(response));
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: e.message));
    }
  }

  @override
  Future<Either<AbstractFailure, List<TimeZone>>> getTimeZones() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());

    try {
      final response = await supabase.from('time_zones').select().order('sort_id', ascending: true);

      final listOfTimeZones = response.map((e) => TimeZone.fromJson(e)).toList();

      return Right(listOfTimeZones);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: e.message));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Tax>>> getTaxes({String? countryCode, bool? isReduced}) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());

    try {
      List<Map<String, dynamic>>? response;

      if (countryCode != null && isReduced != null) {
        response = await supabase.from('taxes').select().eq('is_reduced', isReduced).contains('country_codes', [countryCode]);
      } else if (countryCode != null && isReduced == null) {
        response = await supabase.from('taxes').select().contains('country_codes', [countryCode]).order('rate', ascending: false);
      } else if (countryCode == null && isReduced != null) {
        response = await supabase.from('taxes').select().eq('is_reduced', isReduced).order('rate', ascending: false);
      } else {
        response = await supabase.from('taxes').select().order('rate', ascending: false);
      }

      final List<Tax> listOfTaxes = response.map((e) => Tax.fromJson(e)).toList();

      return Right(listOfTaxes);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: e.message));
    }
  }

  @override
  Future<Either<AbstractFailure, Tax>> getTaxByCountryCode(String countryCode) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());

    try {
      final response = await supabase.from('taxes').select().eq('is_reduced', false).contains('country_codes', [countryCode]);

      final listOfTaxes = response.map((e) => Tax.fromJson(e)).toList();

      return Right(listOfTaxes.first);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: e.message));
    }
  }

  @override
  Future<Either<AbstractFailure, ({double tax, Currency currency})>> getTaxAndCurrencyFromSettings() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());

    try {
      final settingsId = await getMainBranchSettingsId();
      if (settingsId == null) return Left(GeneralFailure(message: 'Settings not found'));

      final response = await supabase.from('settings').select('tax, currency_id').eq('id', settingsId).single();

      if (response['tax'] == null) return Left(GeneralFailure(message: 'Beim Laden der Steuer ist ein Fehler aufgetreten.'));
      if (response['currency_id'] == null) return Left(GeneralFailure(message: 'Beim Laden der Währung ist ein Fehler aufgetreten.'));

      final fosCurrency = await getCurrencyById(response['currency_id']);
      if (fosCurrency.isLeft()) return Left(fosCurrency.getLeft());

      return Right((tax: response['tax'].toDouble(), currency: fosCurrency.getRight()));
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Steuer ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Steuer ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<String>>> getVehicleBrands({required String searchTerm}) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());

    try {
      final response = await supabase.from('vehicle_brands').select().ilike('brand_name', '%$searchTerm%');

      final listOfVehicleBrands = response.map((e) => e['brand_name'] as String).toList();

      return Right(listOfVehicleBrands);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: e.message));
    }
  }
}
