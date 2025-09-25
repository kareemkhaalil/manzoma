import 'package:equatable/equatable.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';
import '../../domain/entities/payroll_entity.dart';
import '../../domain/entities/payroll_detail_entity.dart';

enum PayrollStatus { initial, loading, success, failure }

class PayrollState extends Equatable {
  final PayrollStatus status;
  final List<PayrollEntity> payrolls;
  final PayrollEntity? selectedPayroll;
  final List<PayrollDetailEntity> details;
  final List<PayrollRuleEntity> rules;
  final String? errorMessage;
  final String? message; // 👈 جديد

  const PayrollState({
    this.status = PayrollStatus.initial,
    this.payrolls = const [],
    this.selectedPayroll,
    this.details = const [],
    this.rules = const [],
    this.errorMessage,
    this.message, // 👈 جديد
  });

  PayrollState copyWith({
    PayrollStatus? status,
    List<PayrollEntity>? payrolls,
    PayrollEntity? selectedPayroll,
    List<PayrollDetailEntity>? details,
    List<PayrollRuleEntity>? rules,
    String? errorMessage,
    String? message,
  }) {
    return PayrollState(
      status: status ?? this.status,
      payrolls: payrolls ?? this.payrolls,
      selectedPayroll: selectedPayroll ?? this.selectedPayroll,
      details: details ?? this.details,
      rules: rules ?? this.rules,
      errorMessage: errorMessage,
      message: message, // 👈 جديد
    );
  }

  @override
  List<Object?> get props => [
        status,
        payrolls,
        selectedPayroll,
        details,
        rules,
        errorMessage,
        message
      ];
}
