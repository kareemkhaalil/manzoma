import '../../domain/entities/client_entity.dart';

class ClientModel extends ClientEntity {
  const ClientModel({
    required super.id,
    required super.name,
    required super.plan,
    super.subscriptionStart,
    super.subscriptionEnd,
    required super.billingAmount,
    required super.billingInterval,
    required super.isActive,
    required super.allowedBranches,
    required super.allowedUsers,
    required super.currentBranches,
    required super.currentUsers,
    super.createdAt,
    super.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      name: json['name'] as String,
      plan: json['plan'] as String? ?? 'free',
      subscriptionStart: json['subscription_start'] != null
          ? DateTime.tryParse(json['subscription_start'].toString())
          : null,
      subscriptionEnd: json['subscription_end'] != null
          ? DateTime.tryParse(json['subscription_end'].toString())
          : null,
      billingAmount: json['billing_amount'] != null
          ? (double.tryParse(json['billing_amount'].toString()) ?? 0.0)
          : 0.0,
      billingInterval: json['billing_interval'] as String? ?? 'monthly',
      isActive: json['is_active'] as bool? ?? true,
      allowedBranches: json['allowed_branches'] as int? ?? 1,
      allowedUsers: json['allowed_users'] as int? ?? 5,
      currentBranches: json['current_branches'] as int? ?? 0,
      currentUsers: json['current_users'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toCreateJson({bool includeId = false}) {
    final map = <String, dynamic>{
      if (includeId) 'id': id,
      'name': name,
      'plan': plan,
      'billing_amount': billingAmount,
      'billing_interval': billingInterval,
      'is_active': isActive,
      'allowed_branches': allowedBranches,
      'allowed_users': allowedUsers,
      'current_branches': currentBranches,
      'current_users': currentUsers,
    };

    map.removeWhere((k, v) => v == null);
    return map;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'plan': plan,
      'subscription_start': subscriptionStart?.toIso8601String(),
      'subscription_end': subscriptionEnd?.toIso8601String(),
      'billing_amount': billingAmount,
      'billing_interval': billingInterval,
      'is_active': isActive,
      'allowed_branches': allowedBranches,
      'allowed_users': allowedUsers,
      'current_branches': currentBranches,
      'current_users': currentUsers,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ClientModel.fromEntity(ClientEntity e) {
    return ClientModel(
      id: e.id,
      name: e.name,
      plan: e.plan,
      subscriptionStart: e.subscriptionStart,
      subscriptionEnd: e.subscriptionEnd,
      billingAmount: e.billingAmount,
      billingInterval: e.billingInterval,
      isActive: e.isActive,
      allowedBranches: e.allowedBranches,
      allowedUsers: e.allowedUsers,
      currentBranches: e.currentBranches,
      currentUsers: e.currentUsers,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  ClientModel copyWith({
    String? id,
    String? name,
    String? plan,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
    double? billingAmount,
    String? billingInterval,
    bool? isActive,
    int? allowedBranches,
    int? allowedUsers,
    int? currentBranches,
    int? currentUsers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      plan: plan ?? this.plan,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      billingAmount: billingAmount ?? this.billingAmount,
      billingInterval: billingInterval ?? this.billingInterval,
      isActive: isActive ?? this.isActive,
      allowedBranches: allowedBranches ?? this.allowedBranches,
      allowedUsers: allowedUsers ?? this.allowedUsers,
      currentBranches: currentBranches ?? this.currentBranches,
      currentUsers: currentUsers ?? this.currentUsers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
