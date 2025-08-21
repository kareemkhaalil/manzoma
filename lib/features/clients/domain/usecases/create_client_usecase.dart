import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/client_entity.dart';
import '../repositories/client_repository.dart';

class CreateClientParams {
  final String name;
  final String plan;
  final DateTime subscriptionStart;
  final DateTime subscriptionEnd;
  final double billingAmount;
  final String billingInterval;
  final bool isActive;
  final int? allowedBranches;
  final int? allowedUsers;

  const CreateClientParams({
    required this.name,
    required this.plan,
    required this.subscriptionStart,
    required this.subscriptionEnd,
    required this.billingAmount,
    required this.billingInterval,
    this.isActive = true,
    this.allowedBranches,
    this.allowedUsers,
  });
}

class CreateClientUseCase implements UseCase<ClientEntity, CreateClientParams> {
  final ClientRepository repository;

  CreateClientUseCase(this.repository);

  @override
  Future<Either<Failure, ClientEntity>> call(CreateClientParams params) async {
    return await repository.createClient(
      name: params.name,
      plan: params.plan,
      subscriptionStart: params.subscriptionStart,
      subscriptionEnd: params.subscriptionEnd,
      billingAmount: params.billingAmount,
      billingInterval: params.billingInterval,
    );
  }
}
