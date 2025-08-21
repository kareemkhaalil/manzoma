import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/branch_entity.dart';

abstract class BranchRepository {
  Future<Either<Failure, List<BranchEntity>>> getBranches({
    String? tenantId,
    int? limit,
    int? offset,
  });
  
  Future<Either<Failure, BranchEntity>> getBranchById(String id);
  
  Future<Either<Failure, BranchEntity>> createBranch(BranchEntity branch);
  
  Future<Either<Failure, BranchEntity>> updateBranch(String id, BranchEntity branch);
  
  Future<Either<Failure, void>> deleteBranch(String id);
  
  Future<Either<Failure, List<BranchEntity>>> searchBranches(String query, {
    String? tenantId,
  });
}

