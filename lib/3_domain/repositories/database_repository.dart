import 'package:dartz/dartz.dart';

import '../../failures/failures.dart';
import '../models/models.dart';

abstract class DatabaseRepository {
  Future<Either<AbstractFailure, List<Country>>> getCountries();
  Future<Either<AbstractFailure, Country>> getCountyByIsoCode(String isoCode);
  Future<Either<AbstractFailure, List<Currency>>> getCurrencies();
  Future<Either<AbstractFailure, Currency>> getCurrencyById(String id);
  Future<Either<AbstractFailure, List<TimeZone>>> getTimeZones();
  Future<Either<AbstractFailure, List<Tax>>> getTaxes({String? countryCode, bool? isReduced});
  Future<Either<AbstractFailure, Tax>> getTaxByCountryCode(String countryCode);
  Future<Either<AbstractFailure, ({double tax, Currency currency})>> getTaxAndCurrencyFromSettings();
  Future<Either<AbstractFailure, List<String>>> getVehicleBrands({required String searchTerm});
}
