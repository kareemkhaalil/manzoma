import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/client_repository.dart';

class DeleteClientUseCase implements UseCase<void, String> {
  final ClientRepository repository;

  DeleteClientUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteClient(params);
  }
}

