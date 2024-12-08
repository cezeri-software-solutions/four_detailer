import 'package:dartz/dartz.dart';

import '../../failures/failures.dart';
import '../models/models.dart';

abstract class BranchRepository {
  Future<Either<AbstractFailure, Branch>> getBranchById(String branchId);
  Future<Either<AbstractFailure, List<Branch>>> getBranches();
  Future<Either<AbstractFailure, Branch>> updateBranch(Branch branch);
  Future<Either<AbstractFailure, Branch>> uploadBranchLogo({required String branchId, required MyFile myFile, required String? imageUrl});
  Future<Either<AbstractFailure, Branch>> deleteBranchLogo(String branchId, String imageUrl);
}
