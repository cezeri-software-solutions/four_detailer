import 'package:dartz/dartz.dart';

import '../../failures/failures.dart';
import '../models/models.dart';

abstract class CategoryRepository {
  Future<Either<AbstractFailure, Category>> createCategory(Category category);
  Future<Either<AbstractFailure, List<Category>>> getCategories();
  Future<Either<AbstractFailure, Category>> updateCategory(Category category);
  Future<Either<AbstractFailure, List<Category>>> updatePositionsOfCategories(List<Category> categories);
  Future<Either<AbstractFailure, Unit>> deleteCategory(String categoryId);
}
