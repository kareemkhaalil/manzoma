import 'package:dartz/dartz.dart';
import 'package:huma_plus/core/enums/user_role.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase implements UseCase<List<UserEntity>, GetUsersParams> {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(GetUsersParams params) async {
    return await repository.getUsers(
      tenantId: params.tenantId,
      branchId: params.branchId,
      role: params.role,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetUsersParams {
  final String? tenantId;
  final String? branchId;
  final UserRole? role;
  final int? limit;
  final int? offset;

  GetUsersParams({
    this.tenantId,
    this.branchId,
    this.role,
    this.limit,
    this.offset,
  });
}
