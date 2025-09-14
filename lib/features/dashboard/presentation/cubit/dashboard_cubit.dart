import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../clients/domain/entities/client_entity.dart';
import '../../../clients/domain/usecases/get_clients_usecase.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../../../users/domain/usecases/get_users_usecase.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetClientsUseCase getClientsUseCase;
  final GetUsersUseCase getUsersUseCase;

  DashboardCubit({
    required this.getClientsUseCase,
    required this.getUsersUseCase,
  }) : super(DashboardInitial());

  Future<void> getStats() async {
    emit(DashboardLoading());

    try {
      // 1. استخدام Future.wait لجلب البيانات على التوازي لتحسين الأداء
      final results = await Future.wait([
        getClientsUseCase(const GetClientsParams()), // جلب كل العملاء
        getUsersUseCase(GetUsersParams()), // جلب كل المستخدمين
      ]);

      // 2. التعامل مع نتائج الـ UseCases التي تكون من نوع Either
      final clientResult = results[0] as Either<Failure, List<ClientEntity>>;
      final userResult = results[1] as Either<Failure, List<UserEntity>>;

      // متغيرات لتخزين البيانات النهائية
      int totalClients = 0;
      int activeUsers = 0;
      String? errorMessage;

      // 3. معالجة نتيجة العملاء
      clientResult.fold(
        (failure) => errorMessage = failure.message,
        (clients) => totalClients = clients.length,
      );

      // إذا فشل الطلب الأول، أرسل الخطأ فورًا
      if (errorMessage != null) {
        emit(DashboardError(message: errorMessage!));
        return;
      }

      // 4. معالجة نتيجة المستخدمين
      userResult.fold(
        (failure) => errorMessage = failure.message,
        (users) => activeUsers = users.length,
      );

      // إذا فشل الطلب الثاني، أرسل الخطأ
      if (errorMessage != null) {
        emit(DashboardError(message: errorMessage!));
        return;
      }

      // 5. في حالة نجاح كل الطلبات، أرسل البيانات الحقيقية للـ UI
      emit(DashboardLoaded(
        totalClients: totalClients,
        activeUsers: activeUsers,
        // يمكنك إبقاء هذه الأرقام مؤقتًا حتى توفر مصادر بيانات لها
        totalEmployees: 178,
        presentToday: 160,
        lateArrivals: 7,
        absentToday: 18,
      ));
    } catch (e) {
      // للتعامل مع أي أخطاء غير متوقعة
      emit(DashboardError(
          message: "An unexpected error occurred: ${e.toString()}"));
    }
  }
}
