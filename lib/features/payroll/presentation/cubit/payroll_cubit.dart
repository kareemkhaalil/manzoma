import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart';
import 'package:manzoma/core/usecases/usecase.dart';
import 'package:manzoma/features/auth/data/models/user_model.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/create_payroll_usecase.dart';
import '../../domain/usecases/get_payroll_history_usecase.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import 'payroll_state.dart';

class PayrollCubit extends Cubit<PayrollState> {
  final CreatePayrollUseCase _createPayrollUseCase;
  final GetPayrollHistoryUseCase _getPayrollHistoryUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  static const int _limit = 20;
  int _currentOffset = 0;
  UserModel? _currentUser;

  PayrollCubit({
    CreatePayrollUseCase? createPayrollUseCase,
    GetPayrollHistoryUseCase? getPayrollHistoryUseCase,
    GetCurrentUserUseCase? getCurrentUserUseCase,
  })  : _createPayrollUseCase =
            createPayrollUseCase ?? sl<CreatePayrollUseCase>(),
        _getPayrollHistoryUseCase =
            getPayrollHistoryUseCase ?? sl<GetPayrollHistoryUseCase>(),
        _getCurrentUserUseCase =
            getCurrentUserUseCase ?? sl<GetCurrentUserUseCase>(),
        super(PayrollInitial());

  /// Load current user from local storage or API
  ///

  Future<void> loadCurrentUser() async {
    // 1️⃣ Try from local storage
    _currentUser = SharedPrefHelper.getUser() as UserModel?;

    // 2️⃣ If null, try from API
    if (_currentUser == null) {
      final result = await _getCurrentUserUseCase(const NoParams());
      result.fold(
        (failure) => emit(PayrollError(message: failure.message)),
        (user) {
          if (user != null) {
            _currentUser = user as UserModel?;
            SharedPrefHelper.saveUser(UserModel.fromEntity(user));
          }
        },
      );
    }
  }

  Future<void> createPayroll({
    required String period,
    required double basicSalary,
    double allowances = 0,
    double deductions = 0,
    double overtime = 0,
    double bonus = 0,
    required int workingDays,
    required int actualWorkingDays,
    String? notes,
  }) async {
    if (_currentUser == null) {
      await loadCurrentUser();
      if (_currentUser == null) {
        emit(const PayrollError(message: 'User not found'));
        return;
      }
    }

    emit(PayrollLoading());

    final result = await _createPayrollUseCase(
      CreatePayrollParams(
        userId: _currentUser!.id,
        period: period,
        basicSalary: basicSalary,
        allowances: allowances,
        deductions: deductions,
        overtime: overtime,
        bonus: bonus,
        workingDays: workingDays,
        actualWorkingDays: actualWorkingDays,
        notes: notes,
      ),
    );

    result.fold(
      (failure) => emit(PayrollError(message: failure.message)),
      (payroll) => emit(PayrollCreateSuccess(payroll: payroll)),
    );
  }

  Future<void> getPayrollHistory({
    String? period,
    bool refresh = false,
  }) async {
    if (_currentUser == null) {
      await loadCurrentUser();
      if (_currentUser == null) {
        emit(const PayrollError(message: 'User not found'));
        return;
      }
    }

    if (refresh) {
      _currentOffset = 0;
      emit(PayrollLoading());
    }

    final result = await _getPayrollHistoryUseCase(
      GetPayrollHistoryParams(
        userId: _currentUser!.id,
        period: period,
        limit: _limit,
        offset: _currentOffset,
      ),
    );

    result.fold(
      (failure) => emit(PayrollError(message: failure.message)),
      (newPayrollList) {
        final hasReachedMax = newPayrollList.length < _limit;
        _currentOffset += newPayrollList.length;

        if (state is PayrollHistoryLoaded && !refresh) {
          final currentState = state as PayrollHistoryLoaded;
          final updatedList = List.of(currentState.payrollList)
            ..addAll(newPayrollList);

          emit(PayrollHistoryLoaded(
            payrollList: updatedList,
            hasReachedMax: hasReachedMax,
          ));
        } else {
          emit(PayrollHistoryLoaded(
            payrollList: newPayrollList,
            hasReachedMax: hasReachedMax,
          ));
        }
      },
    );
  }
}
