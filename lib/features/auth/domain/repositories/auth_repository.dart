import 'package:dartz/dartz.dart';
import 'package:manzoma/features/auth/data/models/user_model.dart';
import '../../../../core/error/failures.dart';
import 'package:manzoma/core/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? avatar,
  });

  Future<Either<Failure, void>> resetPassword({required String email});
}
