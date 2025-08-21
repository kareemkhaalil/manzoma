import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/client_entity.dart';
import '../repositories/client_repository.dart';

class GetClientsParams {
  final int? limit;
  final int? offset;

  const GetClientsParams({
    this.limit,
    this.offset,
  });
}

class GetClientsUseCase implements UseCase<List<ClientEntity>, GetClientsParams> {
  final ClientRepository repository;

  GetClientsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ClientEntity>>> call(GetClientsParams params) async {
    return await repository.getClients(
      limit: params.limit,
      offset: params.offset,
    );
  }
}

