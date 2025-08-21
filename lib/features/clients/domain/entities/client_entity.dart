import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  final String id;
  final String name;
  final String plan;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;
  final double billingAmount;
  final String billingInterval;
  final bool isActive;
  final int allowedBranches;
  final int allowedUsers;
  final int currentBranches;
  final int currentUsers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ClientEntity({
    required this.id,
    required this.name,
    required this.plan,
    this.subscriptionStart,
    this.subscriptionEnd,
    required this.billingAmount,
    required this.billingInterval,
    required this.isActive,
    required this.allowedBranches,
    required this.allowedUsers,
    required this.currentBranches,
    required this.currentUsers,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        plan,
        subscriptionStart,
        subscriptionEnd,
        billingAmount,
        billingInterval,
        isActive,
        allowedBranches,
        allowedUsers,
        currentBranches,
        currentUsers,
        createdAt,
        updatedAt,
      ];
}
