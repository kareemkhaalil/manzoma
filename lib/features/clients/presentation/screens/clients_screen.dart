import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../cubit/client_cubit.dart';
import '../cubit/client_state.dart';
import '../widgets/add_client_dialog.dart';
import '../widgets/client_card.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClientCubit>(
      create: (context) => sl<ClientCubit>()..getClients(),
      child: const ClientsView(),
    );
  }
}

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final currentState = context.read<ClientCubit>().state;
      if (currentState is ClientsLoaded && !currentState.hasReachedMax) {
        context.read<ClientCubit>().getClients(
              offset: currentState.clients.length,
            );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.corporate_fare,
                  size: 28,
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Clients Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                CustomButton(
                  text: 'Add Client',
                  onPressed: () => context.go('/clients/create'),
                  icon: Icons.add,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: BlocConsumer<ClientCubit, ClientState>(
              listener: (context, state) {
                if (state is ClientError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is ClientCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Client created successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is ClientUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Client updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is ClientDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Client deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ClientLoading && state is! ClientsLoaded) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ClientsLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ClientCubit>().getClients();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(24),
                      itemCount:
                          state.clients.length + (state.hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index >= state.clients.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final client = state.clients[index];
                        return ClientCard(
                          client: client,
                          onEdit: () => _showEditClientDialog(context, client),
                          onDelete: () =>
                              _showDeleteConfirmation(context, client),
                          onTap: () => context.go('/clients/${client.id}'),
                        );
                      },
                    ),
                  );
                } else if (state is ClientError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading clients',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Retry',
                          onPressed: () =>
                              context.read<ClientCubit>().getClients(),
                        ),
                      ],
                    ),
                  );
                }

                return const Center(
                  child: Text('No clients found'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddClientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ClientCubit>(),
        child: const AddClientDialog(),
      ),
    );
  }

  void _showEditClientDialog(BuildContext context, client) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ClientCubit>(),
        child: AddClientDialog(client: client),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, client) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Client'),
        content: Text('Are you sure you want to delete "${client.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ClientCubit>().deleteClient(client.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
