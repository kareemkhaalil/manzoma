import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/client_entity.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<ClientEntity>>> getClients({
    int? limit,
    int? offset,
  });
  
  Future<Either<Failure, ClientEntity>> getClientById(String id);
  
  Future<Either<Failure, ClientEntity>> createClient({
    required String name,
    required String plan,
    required DateTime subscriptionStart,
    required DateTime subscriptionEnd,
    required double billingAmount,
    required String billingInterval,
  });
  
  Future<Either<Failure, ClientEntity>> updateClient({
    required String id,
    String? name,
    String? plan,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
    double? billingAmount,
    String? billingInterval,
    bool? isActive,
  });
  
  Future<Either<Failure, void>> deleteClient(String id);
}

