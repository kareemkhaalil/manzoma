part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

// هذه الحالة ستحمل كل الأرقام التي نحتاجها
class DashboardLoaded extends DashboardState {
  // Stats for SuperAdmin
  final int totalClients;
  final int activeUsers;

  // Stats for Admin (CAD)
  final int totalEmployees;
  final int presentToday;
  final int lateArrivals;
  final int absentToday;

  // يمكنك إضافة أي إحصائيات أخرى هنا

  const DashboardLoaded({
    this.totalClients = 0,
    this.activeUsers = 0,
    this.totalEmployees = 0,
    this.presentToday = 0,
    this.lateArrivals = 0,
    this.absentToday = 0,
  });

  @override
  List<Object> get props => [
        totalClients,
        activeUsers,
        totalEmployees,
        presentToday,
        lateArrivals,
        absentToday,
      ];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});
  @override
  List<Object> get props => [message];
}
