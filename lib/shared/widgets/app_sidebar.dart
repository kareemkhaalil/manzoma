import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huma_plus/core/navigation/role_based_navigation.dart';
import 'package:huma_plus/core/entities/user_entity.dart';
import '../../core/storage/shared_pref_helper.dart';
import 'package:huma_plus/core/enums/user_role.dart';

class AppSidebar extends StatefulWidget {
  final bool isMobile;
  final VoidCallback? onItemTap;

  const AppSidebar({
    super.key,
    this.isMobile = false,
    this.onItemTap,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  String? expandedItem;
  String currentRoute = '/dashboard';
  UserEntity? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    final user = SharedPrefHelper.getUser();
    setState(() {
      _currentUser = user;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentRoute = GoRouterState.of(context).uri.path;
  }

  @override
  Widget build(BuildContext context) {
    final navigationItems = RoleBasedNavigation.getNavigationItemsForRole(
        _currentUser?.role ?? UserRole.employee);

    return Container(
      width: widget.isMobile ? double.infinity : 280,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: widget.isMobile
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Column(
        children: [
          // Logo/Header Section
          Container(
            height: widget.isMobile ? 60 : 80,
            padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.business_center,
                  color: Colors.white,
                  size: widget.isMobile ? 24 : 32,
                ),
                SizedBox(width: widget.isMobile ? 8 : 12),
                Expanded(
                  child: Text(
                    'HumaPlus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.isMobile ? 16 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.isMobile)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: widget.isMobile ? 4 : 8),
              itemCount: navigationItems.length,
              itemBuilder: (context, index) {
                final item = navigationItems[index];
                return _buildNavigationItem(item);
              },
            ),
          ),

          // User Info Section
          Container(
            padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: widget.isMobile ? 16 : 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: widget.isMobile ? 16 : 20,
                  ),
                ),
                SizedBox(width: widget.isMobile ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentUser?.name ?? 'User',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: widget.isMobile ? 12 : 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _currentUser?.email ?? 'user@example.com',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: widget.isMobile ? 10 : 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.grey.shade600,
                    size: widget.isMobile ? 18 : 20,
                  ),
                  onPressed: () async {
                    await SharedPrefHelper.clearUser();
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(NavigationItem item) {
    final hasSubItems = item.subItems != null && item.subItems!.isNotEmpty;
    final isExpanded = expandedItem == item.title;
    final isActive = currentRoute == item.route ||
        (item.subItems?.any((sub) => currentRoute == sub.route) ?? false);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (hasSubItems) {
                setState(() {
                  expandedItem = isExpanded ? null : item.title;
                });
              } else {
                context.go(item.route);
                if (widget.isMobile && widget.onItemTap != null) {
                  widget.onItemTap!();
                }
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 12 : 16,
                vertical: widget.isMobile ? 8 : 12,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 4 : 8,
                vertical: 2,
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: widget.isMobile ? 18 : 20,
                    color: isActive
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade600,
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: isActive
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade800,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                        fontSize: widget.isMobile ? 12 : 14,
                      ),
                    ),
                  ),
                  if (hasSubItems)
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: widget.isMobile ? 18 : 20,
                      color: Colors.grey.shade600,
                    ),
                ],
              ),
            ),
          ),
        ),

        // Sub Items
        if (hasSubItems && isExpanded)
          ...item.subItems!.map((subItem) => _buildSubNavigationItem(subItem)),
      ],
    );
  }

  Widget _buildSubNavigationItem(NavigationItem subItem) {
    final isActive = currentRoute == subItem.route;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.go(subItem.route);
          if (widget.isMobile && widget.onItemTap != null) {
            widget.onItemTap!();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 12 : 16,
            vertical: widget.isMobile ? 6 : 8,
          ),
          margin: EdgeInsets.only(
            left: widget.isMobile ? 16 : 24,
            right: widget.isMobile ? 4 : 8,
            top: 2,
            bottom: 2,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(
                subItem.icon,
                size: widget.isMobile ? 16 : 18,
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade500,
              ),
              SizedBox(width: widget.isMobile ? 8 : 12),
              Expanded(
                child: Text(
                  subItem.title,
                  style: TextStyle(
                    color: isActive
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade700,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                    fontSize: widget.isMobile ? 11 : 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
