import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../cubit/client_cubit.dart';
import '../cubit/client_state.dart';
import '../widgets/client_card.dart'; // تأكد أنه موجود، أو استبدله بـ ListTile

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
  final TextEditingController _searchCtrl = TextEditingController();

  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchCtrl.dispose();
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
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color.surface,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
        title: Row(
          children: [
            Icon(Icons.corporate_fare_rounded, color: color.primary),
            const SizedBox(width: 8),
            Text(
              'إدارة العملاء',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _isGridView ? 'عرض قائمة' : 'عرض شبكة',
            onPressed: () => setState(() => _isGridView = !_isGridView),
            icon: Icon(_isGridView
                ? Icons.view_list_rounded
                : Icons.grid_view_rounded),
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: FilledButton.icon(
              icon: const Icon(Icons.add_rounded),
              label: const Text('إضافة عميل'),
              onPressed: () => context.push('/clients/create'),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'ابحث عن عميل...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchCtrl.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'مسح',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() {});
                        },
                      ),
                filled: true,
                fillColor: color.surfaceContainerHighest.withOpacity(0.3),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addClientFab',
        onPressed: () => context.push('/clients/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('إضافة عميل'),
      ),
      body: BlocConsumer<ClientCubit, ClientState>(
        listener: (context, state) {
          if (state is ClientError) {
            _showSnack(
                context, state.message, Theme.of(context).colorScheme.error);
          } else if (state is ClientCreated) {
            _showSnack(context, 'تم إنشاء العميل بنجاح ✅', Colors.green);
          } else if (state is ClientUpdated) {
            _showSnack(context, 'تم تحديث العميل بنجاح ✅', Colors.green);
          } else if (state is ClientDeleted) {
            _showSnack(context, 'تم حذف العميل بنجاح 🗑️', Colors.green);
          }
        },
        builder: (context, state) {
          if (state is ClientLoading) {
            return _buildSkeletonList(context);
          }

          if (state is ClientError) {
            return _buildErrorState(
              context,
              message: state.message,
              onRetry: () => context.read<ClientCubit>().getClients(),
            );
          }

          if (state is ClientsLoaded) {
            final query = _searchCtrl.text.trim().toLowerCase();
            final all = state.clients;
            final filtered = query.isEmpty
                ? all
                : all.where((c) {
                    final name = (c.name ?? '').toString().toLowerCase();
                    return name.contains(query);
                  }).toList();

            if (all.isEmpty) {
              return _buildEmptyState(
                context,
                title: 'لا يوجد عملاء بعد',
                subtitle: 'ابدأ بإضافة أول عميل لك',
                actionLabel: 'إضافة عميل',
                onAction: () => context.push('/clients/create'),
              );
            }

            if (filtered.isEmpty) {
              return _buildEmptyState(
                context,
                title: 'لا توجد نتائج',
                subtitle: 'جرّب تعديل كلمات البحث',
                actionLabel: 'مسح البحث',
                onAction: () {
                  _searchCtrl.clear();
                  setState(() {});
                },
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                int crossAxisCount = 1;
                if (width >= 1280) {
                  crossAxisCount = 4;
                } else if (width >= 1000) {
                  crossAxisCount = 3;
                } else if (width >= 700) {
                  crossAxisCount = 2;
                }

                final showGrid = _isGridView && crossAxisCount > 1;

                final itemCount =
                    filtered.length + (state.hasReachedMax ? 0 : 1);
                const padding = EdgeInsets.fromLTRB(16, 16, 16, 100);

                if (showGrid) {
                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<ClientCubit>().getClients(),
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: padding,
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.35,
                      ),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (index >= filtered.length) {
                          return _buildLoadMoreTile(context);
                        }
                        final client = filtered[index];
                        return ClientCard(
                          client: client,
                          onEdit: () => _navigateToEdit(context, client),
                          onDelete: () =>
                              _showDeleteConfirmation(context, client),
                          onTap: () => _onClientTap(context, client),
                        );
                      },
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<ClientCubit>().getClients(),
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: padding,
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      itemCount: itemCount,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index >= filtered.length) {
                          return _buildLoadMoreTile(context);
                        }
                        final client = filtered[index];
                        return ClientCard(
                          client: client,
                          onEdit: () => _navigateToEdit(context, client),
                          onDelete: () =>
                              _showDeleteConfirmation(context, client),
                          onTap: () => _onClientTap(context, client),
                        );
                      },
                    ),
                  );
                }
              },
            );
          }

          // حالة افتراضية
          return _buildSkeletonList(context);
        },
      ),
    );
  }

  // ---------- Actions ----------

  Future<void> _onClientTap(BuildContext context, dynamic client) async {
    final color = Theme.of(context).colorScheme;
    final result = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: color.surface,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit_rounded, color: color.primary),
              title: const Text('تعديل العميل'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline_rounded, color: Colors.red),
              title: const Text('حذف العميل'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );

    if (result == 'edit') {
      _navigateToEdit(context, client);
    } else if (result == 'delete') {
      _showDeleteConfirmation(context, client);
    }
  }

  void _navigateToEdit(BuildContext context, dynamic client) {
    // بنمرر الـ client كـ extra علشان نعمل Prefill
    context.push('/clients/${client.id}/edit', extra: client);
  }

  void _showDeleteConfirmation(BuildContext context, dynamic client) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف العميل'),
        content: Text('هل أنت متأكد من حذف "${client.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ClientCubit>().deleteClient(client.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message, Color bg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: bg,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  // ---------- UI Helpers ----------

  Widget _buildSkeletonList(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Container(
          height: 88,
          decoration: BoxDecoration(
            color: color.surfaceContainerHighest.withOpacity(0.4),
            borderRadius: BorderRadius.circular(14),
          ),
        );
      },
    );
  }

  Widget _buildLoadMoreTile(BuildContext context) {
    return Container(
      height: 76,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3),
      ),
      child: const SizedBox(
        height: 28,
        width: 28,
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    final color = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline_rounded,
                  size: 72, color: color.outline),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: color.outline),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context,
      {required String message, required VoidCallback onRetry}) {
    final color = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 72, color: color.error),
              const SizedBox(height: 12),
              Text('حدث خطأ أثناء تحميل العملاء',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: color.outline),
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
