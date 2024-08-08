part of 'superAdmin_cubit.dart';

abstract class SuperAdminState {}

class SuperAdminInitial extends SuperAdminState {}

class SuperAdminLoading extends SuperAdminState {}

class SuperAdminLoaded extends SuperAdminState {
  final List<ClientModel> clients;

  SuperAdminLoaded(this.clients);
}

class SuperAdminOperationSuccess extends SuperAdminState {
  final String message;

  SuperAdminOperationSuccess(this.message);
}

class SuperAdminNoClients extends SuperAdminState {
  final List<ClientModel>? clients;

  SuperAdminNoClients(this.clients);
}

class SuperAdminError extends SuperAdminState {
  final String error;

  SuperAdminError(this.error);
}

class SuperAdminAddClientLoading extends SuperAdminState {}

class SuperAdminAddClientSuccess extends SuperAdminState {}

class SuperAdminAddClientError extends SuperAdminState {
  final String error;

  SuperAdminAddClientError(this.error);
}

class SuperAdminEditingClient extends SuperAdminState {
  final ClientModel? client;
  SuperAdminEditingClient(this.client);
}

class SuperAdminAdminAdded extends SuperAdminState {
  final List<UserModel> admins;

  SuperAdminAdminAdded(this.admins);
}

class SuperAdminAddingUser extends SuperAdminState {}

class SuperAdminUserAdded extends SuperAdminState {}
