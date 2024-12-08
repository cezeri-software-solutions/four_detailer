import 'package:dartz/dartz.dart';
import 'package:four_detailer/failures/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../3_domain/models/models.dart';
import '../3_domain/repositories/branch_repository.dart';
import '../constants.dart';
import '../core/core.dart';
import 'functions/functions.dart';

class BranchRepositoryImpl implements BranchRepository {
  final SupabaseClient supabase;

  const BranchRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, Branch>> getBranchById(String branchId) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      final response = await supabase.rpc('get_branche_by_id', params: {'p_branch_id': branchId});

      final branch = Branch.fromJson(response);

      return right(branch);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Filiale ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Filiale ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Branch>>> getBranches() async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_branches_by_owner_id', params: {'p_owner_id': ownerId});

      final List<Branch> branches = (response as List<dynamic>).map((branch) => Branch.fromJson(branch as Map<String, dynamic>)).toList();

      return right(branches);
    } on PostgrestException catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Filialen ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Laden der Filialen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Branch>> updateBranch(Branch branch) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      final response = await supabase.rpc('update_branch', params: {'p_branch_id': branch.id, 'p_branch_data': branch.toJson()});

      final updatedBranch = Branch.fromJson(response);

      return Right(updatedBranch);
    } on PostgrestException catch (e) {
      if (e.message.contains('does not exist') || e.message.contains('not found') || e.toString().contains('The result contains 0 rows')) {
        logger.e(e);
        return Left(EmptyFailure(message: 'Die Filiale konnte nicht in der Datenbank gefunden werden!'));
      } else {
        logger.e(e);
        return Left(GeneralFailure(message: 'Beim Aktualisieren der Filiale: ${branch.branchName} ist ein Fehler aufgetreten. Error: $e'));
      }
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren der Filiale: ${branch.branchName} ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Branch>> uploadBranchLogo({required String branchId, required MyFile myFile, required String? imageUrl}) async {
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

      final fosUploadImage = await uploadFileToStorage(bucketName: ownerId, path: 'branch-logo', myFile: myFile, useGivenName: false);
      if (fosUploadImage.isLeft()) return Left(GeneralFailure(message: fosUploadImage.getLeft().message));

      final url = fosUploadImage.getRight();

      await supabase.from('branches').update({'branch_logo': url}).eq('id', branchId);

      final fosBranch = await getBranchById(branchId);
      if (fosBranch.isLeft()) return Left(GeneralFailure(message: fosBranch.getLeft().message));

      final updatedBranch = fosBranch.getRight();

      return Right(updatedBranch);
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: 'Beim Aktualisieren des Logos ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren des Logos ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Branch>> deleteBranchLogo(String branchId, String imageUrl) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(message: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await deleteFilesFromSupabaseStorageByUrl(ownerId, [imageUrl]);

      final updatedBranch = await supabase.from('branches').update({'image_url': ''}).eq('id', branchId);

      return Right(Branch.fromJson(updatedBranch));
    } on PostgrestException catch (e) {
      logger.e(e.message);
      return Left(GeneralFailure(message: 'Beim Aktualisieren des Logos ist ein Fehler aufgetreten. Error: $e'));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(message: 'Beim Aktualisieren des Logos ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
