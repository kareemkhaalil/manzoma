import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/client_entity.dart';
import '../repositories/client_repository.dart';

class UpdateClientParams {
  final String id;
  final String? name;
  final String? plan;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;
  final double? billingAmount;
  final String? billingInterval;
  final bool? isActive;

  const UpdateClientParams({
    required this.id,
    this.name,
    this.plan,
    this.subscriptionStart,
    this.subscriptionEnd,
    this.billingAmount,
    this.billingInterval,
    this.isActive,
  });
}

class UpdateClientUseCase implements UseCase<ClientEntity, UpdateClientParams> {
  final ClientRepository repository;

  UpdateClientUseCase(this.repository);

  @override
  Future<Either<Failure, ClientEntity>> call(UpdateClientParams params) async {
    return await repository.updateClient(
      id: params.id,
      name: params.name,
      plan: params.plan,
      subscriptionStart: params.subscriptionStart,
      subscriptionEnd: params.subscriptionEnd,
      billingAmount: params.billingAmount,
      billingInterval: params.billingInterval,
      isActive: params.isActive,
    );
  }
}

