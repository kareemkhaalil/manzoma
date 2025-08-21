import 'package:equatable/equatable.dart';
import '../../domain/entities/client_entity.dart';

abstract class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object> get props => [];
}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientsLoaded extends ClientState {
  final List<ClientEntity> clients;
  final bool hasReachedMax;

  const ClientsLoaded({
    required this.clients,
    this.hasReachedMax = false,
  });

  ClientsLoaded copyWith({
    List<ClientEntity>? clients,
    bool? hasReachedMax,
  }) {
    return ClientsLoaded(
      clients: clients ?? this.clients,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [clients, hasReachedMax];
}

class ClientLoaded extends ClientState {
  final ClientEntity client;

  const ClientLoaded({required this.client});

  @override
  List<Object> get props => [client];
}

class ClientCreated extends ClientState {
  final ClientEntity client;

  const ClientCreated({required this.client});

  @override
  List<Object> get props => [client];
}

class ClientUpdated extends ClientState {
  final ClientEntity client;

  const ClientUpdated({required this.client});

  @override
  List<Object> get props => [client];
}

class ClientDeleted extends ClientState {}

class ClientError extends ClientState {
  final String message;

  const ClientError({required this.message});

  @override
  List<Object> get props => [message];
}

