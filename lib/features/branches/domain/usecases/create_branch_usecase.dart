import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/branch_entity.dart';
import '../repositories/branch_repository.dart';

class CreateBranchUseCase implements UseCase<BranchEntity, CreateBranchParams> {
  final BranchRepository repository;

  CreateBranchUseCase(this.repository);

  @override
  Future<Either<Failure, BranchEntity>> call(CreateBranchParams params) async {
    return await repository.createBranch(params.branch);
  }
}

class CreateBranchParams {
  final BranchEntity branch;

  CreateBranchParams({required this.branch});
}

