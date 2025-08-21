import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_client_usecase.dart';
import '../../domain/usecases/delete_client_usecase.dart';
import '../../domain/usecases/get_client_by_id_usecase.dart';
import '../../domain/usecases/get_clients_usecase.dart';
import '../../domain/usecases/update_client_usecase.dart';
import 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  final GetClientsUseCase getClientsUseCase;
  final GetClientByIdUseCase getClientByIdUseCase;
  final CreateClientUseCase createClientUseCase;
  final UpdateClientUseCase updateClientUseCase;
  final DeleteClientUseCase deleteClientUseCase;

  ClientCubit({
    required this.getClientsUseCase,
    required this.getClientByIdUseCase,
    required this.createClientUseCase,
    required this.updateClientUseCase,
    required this.deleteClientUseCase,
  }) : super(ClientInitial());

  Future<void> getClients({int? limit, int? offset}) async {
    if (offset == null || offset == 0) {
      emit(ClientLoading());
    }

    final result = await getClientsUseCase(GetClientsParams(
      limit: limit ?? 20,
      offset: offset ?? 0,
    ));

    result.fold(
      (failure) => emit(ClientError(message: failure.message)),
      (clients) {
        if (state is ClientsLoaded && offset != null && offset > 0) {
          final currentState = state as ClientsLoaded;
          final updatedClients = [...currentState.clients, ...clients];
          emit(ClientsLoaded(
            clients: updatedClients,
            hasReachedMax: clients.length < (limit ?? 20),
          ));
        } else {
          emit(ClientsLoaded(
            clients: clients,
            hasReachedMax: clients.length < (limit ?? 20),
          ));
        }
      },
    );
  }

  Future<void> getClientById(String id) async {
    emit(ClientLoading());

    final result = await getClientByIdUseCase(id);

    result.fold(
      (failure) => emit(ClientError(message: failure.message)),
      (client) => emit(ClientLoaded(client: client)),
    );
  }

  Future<void> createClient(
      {required String name,
      required String plan,
      required DateTime subscriptionStart,
      required DateTime subscriptionEnd,
      required double billingAmount,
      required String billingInterval,
      bool isActive = true,
      int? allowedBranches,
      int? allowedUsers}) async {
    emit(ClientLoading());

    final result = await createClientUseCase(CreateClientParams(
      name: name,
      plan: plan,
      subscriptionStart: subscriptionStart,
      subscriptionEnd: subscriptionEnd,
      billingAmount: billingAmount,
      billingInterval: billingInterval,
    ));

    result.fold(
      (failure) => emit(ClientError(message: failure.message)),
      (client) {
        emit(ClientCreated(client: client));
        // Refresh the clients list
        getClients();
      },
    );
  }

  Future<void> updateClient({
    required String id,
    String? name,
    String? plan,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
    double? billingAmount,
    String? billingInterval,
    bool? isActive,
    required int allowedBranches,
    required int allowedUsers,
  }) async {
    emit(ClientLoading());

    final result = await updateClientUseCase(UpdateClientParams(
      id: id,
      name: name,
      plan: plan,
      subscriptionStart: subscriptionStart,
      subscriptionEnd: subscriptionEnd,
      billingAmount: billingAmount,
      billingInterval: billingInterval,
      isActive: isActive,
    ));

    result.fold(
      (failure) => emit(ClientError(message: failure.message)),
      (client) {
        emit(ClientUpdated(client: client));
        // Refresh the clients list
        getClients();
      },
    );
  }

  Future<void> deleteClient(String id) async {
    emit(ClientLoading());

    final result = await deleteClientUseCase(id);

    result.fold(
      (failure) => emit(ClientError(message: failure.message)),
      (_) {
        emit(ClientDeleted());
        // Refresh the clients list
        getClients();
      },
    );
  }

  void resetState() {
    emit(ClientInitial());
  }
}
