// payroll_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart';
import 'package:manzoma/core/usecases/usecase.dart';
import 'package:manzoma/features/auth/data/models/user_model.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';
import 'package:manzoma/features/payroll/domain/usecases/cerate_rule_usecase_dart';
import 'package:manzoma/features/payroll/domain/usecases/update_rule_usecase.dart';
import 'package:manzoma/features/payroll/domain/usecases/delete_rule_usecase.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';

// Payroll usecases
import '../../domain/usecases/create_payroll_usecase.dart';
import '../../domain/usecases/get_payroll_history_usecase.dart';

// Rules usecases
import '../../domain/usecases/get_all_rules_usecase.dart';

// Employee rules usecases
import '../../domain/usecases/assign_rule_to_employee_usecase.dart';

// Payroll details usecases
import '../../domain/usecases/get_payroll_details_usecase.dart';

// Entities
import '../../domain/entities/payroll_entity.dart';

// State
import 'payroll_state.dart';

class PayrollCubit extends Cubit<PayrollState> {
  // Usecases
  final CreatePayrollUseCase _createPayrollUseCase;
  final GetPayrollHistoryUseCase _getPayrollHistoryUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  final GetAllRulesUseCase _getAllRulesUseCase;
  final CreateRuleUseCase _createRuleUseCase;
  final UpdateRuleUseCase _updateRuleUseCase;
  final DeleteRuleUseCase _deleteRuleUseCase;

  final AssignRuleToEmployeeUseCase _assignRuleToEmployeeUseCase;
  // NOTE: UnassignRuleFromEmployeeUseCase and GetEmployeeRulesUseCase are not defined in the provided files.
  // We will remove them or assume they are external. For this refactoring, we will comment them out.
  // final UnassignRuleFromEmployeeUseCase _unassignRuleFromEmployeeUseCase;
  // final GetEmployeeRulesUseCase _getEmployeeRulesUseCase;

  final GetPayrollDetailsUseCase _getPayrollDetailsUseCase;

  // Helpers
  static const int _limit = 20;
  int _currentOffset = 0;
  UserModel? _currentUser;

  PayrollCubit({
    CreatePayrollUseCase? createPayrollUseCase,
    GetPayrollHistoryUseCase? getPayrollHistoryUseCase,
    GetCurrentUserUseCase? getCurrentUserUseCase,
    GetAllRulesUseCase? getAllRulesUseCase,
    CreateRuleUseCase? createRuleUseCase,
    UpdateRuleUseCase? updateRuleUseCase,
    DeleteRuleUseCase? deleteRuleUseCase,
    AssignRuleToEmployeeUseCase? assignRuleToEmployeeUseCase,
    // UnassignRuleFromEmployeeUseCase? unassignRuleFromEmployeeUseCase,
    // GetEmployeeRulesUseCase? getEmployeeRulesUseCase,
    GetPayrollDetailsUseCase? getPayrollDetailsUseCase,
  })  : _createPayrollUseCase =
            createPayrollUseCase ?? sl<CreatePayrollUseCase>(),
        _getPayrollHistoryUseCase =
            getPayrollHistoryUseCase ?? sl<GetPayrollHistoryUseCase>(),
        _getCurrentUserUseCase =
            getCurrentUserUseCase ?? sl<GetCurrentUserUseCase>(),
        _getAllRulesUseCase = getAllRulesUseCase ?? sl<GetAllRulesUseCase>(),
        _createRuleUseCase = createRuleUseCase ?? sl<CreateRuleUseCase>(),
        _updateRuleUseCase = updateRuleUseCase ?? sl<UpdateRuleUseCase>(),
        _deleteRuleUseCase = deleteRuleUseCase ?? sl<DeleteRuleUseCase>(),
        _assignRuleToEmployeeUseCase =
            assignRuleToEmployeeUseCase ?? sl<AssignRuleToEmployeeUseCase>(),
        // _unassignRuleFromEmployeeUseCase = unassignRuleFromEmployeeUseCase ?? sl<UnassignRuleFromEmployeeUseCase>(),
        // _getEmployeeRulesUseCase = getEmployeeRulesUseCase ?? sl<GetEmployeeRulesUseCase>(),
        _getPayrollDetailsUseCase =
            getPayrollDetailsUseCase ?? sl<GetPayrollDetailsUseCase>(),
        super(PayrollInitial());

  /// ----------------- User Handling -----------------
  Future<void> loadCurrentUser() async {
    _currentUser = SharedPrefHelper.getUser() as UserModel?;

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

  /// ----------------- Payroll -----------------
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
    if (_currentUser == null) await loadCurrentUser();
    if (_currentUser == null) {
      emit(const PayrollError(message: 'User not found'));
      return;
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

  Future<void> getPayrollHistory({String? period, bool refresh = false}) async {
    if (_currentUser == null) await loadCurrentUser();
    if (_currentUser == null) {
      emit(const PayrollError(message: 'User not found'));
      return;
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
          final updatedList = List<PayrollEntity>.of(currentState.payrollList)
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

  /// ----------------- Payroll Rules -----------------
  Future<void> getAllRules() async {
    emit(PayrollLoading());
    final result = await _getAllRulesUseCase(const NoParams());

    result.fold(
      (failure) => emit(PayrollError(message: failure.message)),
      (rules) => emit(PayrollRulesLoaded(rules: rules)),
    );
  }

  Future<void> createRule(CreateRuleParams params) async {
    emit(PayrollLoading());
    final result = await _createRuleUseCase(params);

    result.fold(
      (failure) => emit(PayrollError(message: failure.message)),
      (newRule) => emit(PayrollRuleCreated(rule: newRule as PayrollRuleEntity)),
    );
  }

  Future<void> updateRule({
    required String ruleId,
    required String name,
    required double value,
    required String type,
    String? description,
  }) async {
    emit(PayrollLoading());
    final result = await _updateRuleUseCase(
      UpdateRuleParams(
        ruleId: ruleId,
        name: name,
        description: description,
        value: value,
        type: type,
      ),
    );

    result.fold(
      (failure) => emit(PayrollError(message: failure.message)),
      (updated) => emit(PayrollRuleUpdated(rule: updated)),
    );
  }

  Future<void> deleteRule(String ruleId) async {
    emit(PayrollLoading());
    final result = await _deleteRuleUseCase(DeleteRuleParams(ruleId));

    result.fold(
      (failure) => emit(PayrollError(message: failure.message)),
      (_) => emit(PayrollRuleDeleted(ruleId: ruleId)),
    );
  }

  /// ----------------- Employee Salary Rules -----------------
  // NOTE: getEmployeeRules is not defined in the provided usecases
  // Future<void> getEmployeeRules(String userId) async {
  //   emit(PayrollLoading());
  //   final result = await _getEmployeeRulesUseCase(userId);
  //
  //   result.fold(
  //         (failure) => emit(PayrollError(message: failure.message)),
  //         (rules) => emit(EmployeeRulesLoaded(rules: rules)),
  //   );
  // }

  Future<void> assignRuleToEmployee(String userId, String ruleId) async {
    emit(PayrollLoading());
    final result = await _assignRuleToEmployeeUseCase(
      AssignRuleParams(userId: userId, ruleId: ruleId),
    );

    result.fold(
      (failure) => emit(PayrollError(message: failure.message)),
      (_) => emit(EmployeeRuleAssigned(ruleId: ruleId)),
    );
  }
  // NOTE: unassignRuleFromEmployee is not defined in the provided usecases
  // Future<void> unassignRuleFromEmployee(String userId, String ruleId) async {
  //   emit(PayrollLoading());
  //   final result = await _unassignRuleFromEmployeeUseCase(
  //     UnassignRuleParams(userId: userId, ruleId: ruleId),
  //   );
  //
  //   result.fold(
  //         (failure) => emit(PayrollError(message: failure.message)),
  //         (_) => emit(EmployeeRuleUnassigned(ruleId: ruleId)),
  //   );
  // }

  /// ----------------- Payroll Details -----------------
  Future<void> getPayrollDetails(String payrollId) async {
    emit(PayrollLoading());
    final result = await _getPayrollDetailsUseCase(
        GetPayrollDetailsParams(payrollId: payrollId));

    result.fold(
      (failure) => emit(PayrollError(message: failure.message)),
      (details) => emit(PayrollDetailsLoaded(details: details)),
    );
  }
}
