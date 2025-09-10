import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUsersUsecase implements UseCase<UserEntity, UpdateUserParams> {
  final UserRepository repository;

  UpdateUsersUsecase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserParams params) async {
    return await repository.updateUser(params.id, params.user);
  }
}

class UpdateUserParams {
  final String id;
  final UserEntity user;

  UpdateUserParams({required this.id, required this.user});
}
