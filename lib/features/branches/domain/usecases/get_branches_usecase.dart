import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/branch_entity.dart';
import '../repositories/branch_repository.dart';

class GetBranchesUseCase implements UseCase<List<BranchEntity>, GetBranchesParams> {
  final BranchRepository repository;

  GetBranchesUseCase(this.repository);

  @override
  Future<Either<Failure, List<BranchEntity>>> call(GetBranchesParams params) async {
    return await repository.getBranches(
      tenantId: params.tenantId,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetBranchesParams {
  final String? tenantId;
  final int? limit;
  final int? offset;

  GetBranchesParams({
    this.tenantId,
    this.limit,
    this.offset,
  });
}

