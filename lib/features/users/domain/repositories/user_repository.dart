import 'package:dartz/dartz.dart';
import 'package:huma_plus/core/enums/user_role.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers({
    String? tenantId,
    String? branchId,
    UserRole? role,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, UserEntity>> getUserById(String id);

  Future<Either<Failure, UserEntity>> createUser(UserEntity user);

  Future<Either<Failure, UserEntity>> updateUser(String id, UserEntity user);

  Future<Either<Failure, void>> deleteUser(String id);

  Future<Either<Failure, List<UserEntity>>> searchUsers(
    String query, {
    String? tenantId,
    String? role,
  });
}
