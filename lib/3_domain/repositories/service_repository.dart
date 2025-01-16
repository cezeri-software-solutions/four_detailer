import 'package:dartz/dartz.dart';

import '../../failures/failures.dart';
import '../models/models.dart';

abstract class ServiceRepository {
  Future<Either<AbstractFailure, Service>> createService(Service service);
  Future<Either<AbstractFailure, Service>> getServiceById(String serviceId);
  Future<Either<AbstractFailure, ({List<Service> services, int totalCount})>> getServices({
    required String searchTerm,
    required int itemsPerPage,
    required int currentPage,
  });
  Future<Either<AbstractFailure, Service>> updateService(Service service);
  Future<Either<AbstractFailure, List<Service>>> updatePositionsOfServices(List<Service> services);
  Future<Either<AbstractFailure, Unit>> deleteService(String serviceId);
}
