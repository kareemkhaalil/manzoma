import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';
import 'payroll_state.dart';
import '../../domain/entities/payroll_entity.dart';
import '../../domain/entities/payroll_detail_entity.dart';
import '../../domain/usecases/get_payrolls.dart';
import '../../domain/usecases/get_payroll_by_id.dart';
import '../../domain/usecases/create_payroll.dart';
import '../../domain/usecases/update_payroll.dart';
import '../../domain/usecases/delete_payroll.dart';
import '../../domain/usecases/get_payroll_details.dart';
import '../../domain/usecases/add_payroll_detail.dart';
import '../../domain/usecases/delete_payroll_detail.dart';
import '../../domain/usecases/get_payroll_rules.dart';
import '../../domain/usecases/create_payroll_rule.dart';
import '../../domain/usecases/update_payroll_rule.dart';
import '../../domain/usecases/delete_payroll_rule.dart';

class PayrollCubit extends Cubit<PayrollState> {
  final GetPayrolls getPayrolls;
  final GetPayrollById getPayrollById;
  final CreatePayroll createPayroll;
  final UpdatePayroll updatePayroll;
  final DeletePayroll deletePayroll;
  final GetPayrollDetails getPayrollDetails;
  final AddPayrollDetail addPayrollDetail;
  final DeletePayrollDetail deletePayrollDetail;
  final GetPayrollRules getPayrollRules;
  final CreatePayrollRule createPayrollRule;
  final UpdatePayrollRule updatePayrollRule;
  final DeletePayrollRule deletePayrollRule;

  PayrollCubit({
    required this.getPayrolls,
    required this.getPayrollById,
    required this.createPayroll,
    required this.updatePayroll,
    required this.deletePayroll,
    required this.getPayrollDetails,
    required this.addPayrollDetail,
    required this.deletePayrollDetail,
    required this.getPayrollRules,
    required this.createPayrollRule,
    required this.updatePayrollRule,
    required this.deletePayrollRule,
  }) : super(const PayrollState());

  // ---- Payroll ----
  Future<void> fetchPayrolls(String tenantId) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await getPayrolls(tenantId);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (payrolls) => emit(
          state.copyWith(status: PayrollStatus.success, payrolls: payrolls)),
    );
  }

  Future<void> fetchPayrollById(String id) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await getPayrollById(id);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (payroll) => emit(state.copyWith(
          status: PayrollStatus.success, selectedPayroll: payroll)),
    );
  }

  Future<void> addPayroll(PayrollEntity payroll) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await createPayroll(payroll);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (created) => emit(state.copyWith(
          status: PayrollStatus.success,
          payrolls: [...state.payrolls, created])),
    );
  }

  Future<void> editPayroll(PayrollEntity payroll) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await updatePayroll(payroll);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (updated) {
        final updatedList = state.payrolls
            .map((p) => p.id == updated.id ? updated : p)
            .toList();
        emit(state.copyWith(
            status: PayrollStatus.success, payrolls: updatedList));
      },
    );
  }

  Future<void> removePayroll(String id) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await deletePayroll(id);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (_) {
        final filtered = state.payrolls.where((p) => p.id != id).toList();
        emit(state.copyWith(status: PayrollStatus.success, payrolls: filtered));
      },
    );
  }

  // ---- Payroll Details ----
  Future<void> fetchDetails(String payrollId) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await getPayrollDetails(payrollId);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (details) =>
          emit(state.copyWith(status: PayrollStatus.success, details: details)),
    );
  }

  Future<void> addDetail(PayrollDetailEntity detail) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await addPayrollDetail(detail);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (created) => emit(state.copyWith(
          status: PayrollStatus.success, details: [...state.details, created])),
    );
  }

  Future<void> removeDetail(String detailId) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await deletePayrollDetail(detailId);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (_) {
        final filtered = state.details.where((d) => d.id != detailId).toList();
        emit(state.copyWith(status: PayrollStatus.success, details: filtered));
      },
    );
  }

  // ---- Payroll Rules ----
  Future<void> fetchRules(String tenantId) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await getPayrollRules(tenantId);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (rules) =>
          emit(state.copyWith(status: PayrollStatus.success, rules: rules)),
    );
  }

  Future<void> addRule(PayrollRuleEntity rule) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await createPayrollRule(rule);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (created) => emit(state.copyWith(
          status: PayrollStatus.success, rules: [...state.rules, created])),
    );
  }

  Future<void> editRule(PayrollRuleEntity rule) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await updatePayrollRule(rule);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (updated) {
        final updatedList =
            state.rules.map((r) => r.id == updated.id ? updated : r).toList();
        emit(state.copyWith(status: PayrollStatus.success, rules: updatedList));
      },
    );
  }

  Future<void> removeRule(String ruleId) async {
    emit(state.copyWith(status: PayrollStatus.loading));
    final result = await deletePayrollRule(ruleId);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PayrollStatus.failure, errorMessage: failure.message)),
      (_) {
        final filtered = state.rules.where((r) => r.id != ruleId).toList();
        emit(state.copyWith(status: PayrollStatus.success, rules: filtered));
      },
    );
  }
}
