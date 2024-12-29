import 'package:dartz/dartz.dart';

import '../../failures/failures.dart';
import '../models/models.dart';

abstract class TemplateServiceRepository {
  Future<Either<AbstractFailure, List<TemplateService>>> getTemplateServices(TemplateServiceType type);
  Future<Either<AbstractFailure, TemplateService>> createTemplateService(TemplateService templateService);
  Future<Either<AbstractFailure, TemplateServiceItem>> createTemplateServiceItem(TemplateServiceItem templateServiceItem, String templateServiceId);
  Future<Either<AbstractFailure, TemplateService>> updateTemplateService(TemplateService templateService);
  Future<Either<AbstractFailure, TemplateServiceItem>> updateTemplateServiceItem(TemplateServiceItem templateServiceItem);
  Future<Either<AbstractFailure, List<TemplateService>>> updatePositionsOfTemplateServices(List<TemplateService> templateServices);
  Future<Either<AbstractFailure, List<TemplateServiceItem>>> updatePositionsOfTemplateServiceItems(List<TemplateServiceItem> templateServiceItems);
  Future<Either<AbstractFailure, Unit>> deleteTemplateService(String templateServiceId);
  Future<Either<AbstractFailure, Unit>> deleteTemplateServiceItem(String templateServiceItemId);
}
