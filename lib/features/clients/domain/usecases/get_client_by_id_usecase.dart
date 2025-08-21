import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/client_entity.dart';
import '../repositories/client_repository.dart';

class GetClientByIdUseCase implements UseCase<ClientEntity, String> {
  final ClientRepository repository;

  GetClientByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ClientEntity>> call(String params) async {
    return await repository.getClientById(params);
  }
}

