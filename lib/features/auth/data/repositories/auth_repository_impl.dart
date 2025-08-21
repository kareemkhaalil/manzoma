import 'package:dartz/dartz.dart';
import 'package:huma_plus/features/auth/data/models/user_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import 'package:huma_plus/core/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signIn(
          email: email,
          password: password,
        );
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(
          message: e.message,
          code: e.code,
        ));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUp(
          email: email,
          password: password,
          name: name,
          role: role,
        );
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(
          message: e.message,
          code: e.code,
        ));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailure(
          message: e.message,
          code: e.code,
        ));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? avatar,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.updateProfile(
          userId: userId,
          name: name,
          phone: phone,
          avatar: avatar,
        );
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(email: email);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailure(
          message: e.message,
          code: e.code,
        ));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }
}
