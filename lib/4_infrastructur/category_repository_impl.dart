import 'package:dartz/dartz.dart';
import 'package:four_detailer/3_domain/models/categories/category.dart';
import 'package:four_detailer/failures/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../3_domain/repositories/category_repository.dart';
import '../constants.dart';
import '../core/core.dart';
import 'functions/functions.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final SupabaseClient supabase;

  const CategoryRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, Category>> createCategory(Category category) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    final branchId = await getMainBranchId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));
    if (branchId == null) return Left(GeneralFailure(message: 'Die Hauptfiliale konnte nicht aus der Datenbank geladen werden'));

    final updatedCategory = category.copyWith(ownerId: ownerId, branchId: branchId);
    final categoryJson = updatedCategory.toJson();
    categoryJson.remove('id');

    try {
      final response = await supabase.from('categories').insert(categoryJson).select().single();

      return Right(Category.fromJson(response));
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen der Kategorie ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Erstellen der Kategorie ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteCategory(String categoryId) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      await supabase.from('categories').update({'is_deleted': true}).eq('id', categoryId);

      return const Right(unit);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Löschen der Kategorie ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Löschen der Kategorie ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Category>>> getCategories() async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    final branchId = await getMainBranchId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));
    if (branchId == null) return Left(GeneralFailure(message: 'Die Hauptfiliale konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase
          .from('categories')
          .select()
          .eq('branch_id', branchId)
          .eq('owner_id', ownerId)
          .eq('is_deleted', false)
          .order('position', ascending: true);

      final categories = (response as List).map((category) => Category.fromJson(category)).toList();

      return Right(categories);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Kategorien ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Kategorien ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Category>> updateCategory(Category category) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      final response = await supabase.from('categories').update(category.toJson()).eq('id', category.id).select().single();

      return Right(Category.fromJson(response));
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Kategorie ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Kategorie ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Category>>> updatePositionsOfCategories(List<Category> categories) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      final updates = categories
          .map((category) => {
                'id': category.id,
                'owner_id': category.ownerId,
                'branch_id': category.branchId,
                'title': category.title,
                'description': category.description,
                'position': category.position,
                'is_deleted': category.isDeleted,
              })
          .toList();

      final response = await supabase.from('categories').upsert(updates).select();

      final updatedCategories = (response as List).map((category) => Category.fromJson(category)).toList();

      return Right(updatedCategories);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Kategoriepositionen ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Kategoriepositionen ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
