import 'package:equatable/equatable.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';
import '../../domain/entities/payroll_entity.dart';
import '../../domain/entities/payroll_detail_entity.dart';

abstract class PayrollState extends Equatable {
  const PayrollState();

  @override
  List<Object?> get props => [];
}

class PayrollInitial extends PayrollState {}

class PayrollLoading extends PayrollState {}

class PayrollCreateSuccess extends PayrollState {
  final PayrollEntity payroll;

  const PayrollCreateSuccess({required this.payroll});

  @override
  List<Object> get props => [payroll];
}

class PayrollHistoryLoaded extends PayrollState {
  final List<PayrollEntity> payrollList;
  final bool hasReachedMax;

  const PayrollHistoryLoaded({
    required this.payrollList,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [payrollList, hasReachedMax];

  PayrollHistoryLoaded copyWith({
    List<PayrollEntity>? payrollList,
    bool? hasReachedMax,
  }) {
    return PayrollHistoryLoaded(
      payrollList: payrollList ?? this.payrollList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class PayrollError extends PayrollState {
  final String message;

  const PayrollError({required this.message});

  @override
  List<Object> get props => [message];
}

// ----------------- New States for Payroll Rules -----------------

class PayrollRulesLoaded extends PayrollState {
  final List<PayrollRuleEntity> rules;

  const PayrollRulesLoaded({required this.rules});

  @override
  List<Object> get props => [rules];
}

class PayrollRuleCreated extends PayrollState {
  final PayrollRuleEntity rule;

  const PayrollRuleCreated({required this.rule});

  @override
  List<Object> get props => [rule];
}

class PayrollRuleUpdated extends PayrollState {
  final PayrollRuleEntity rule;

  const PayrollRuleUpdated({required this.rule});

  @override
  List<Object> get props => [rule];
}

class PayrollRuleDeleted extends PayrollState {
  final String ruleId;

  const PayrollRuleDeleted({required this.ruleId});

  @override
  List<Object> get props => [ruleId];
}

// ----------------- New State for Employee Rules -----------------

class EmployeeRuleAssigned extends PayrollState {
  final String ruleId;

  const EmployeeRuleAssigned({required this.ruleId});

  @override
  List<Object> get props => [ruleId];
}

// ----------------- New State for Payroll Details -----------------

class PayrollDetailsLoaded extends PayrollState {
  final List<PayrollDetailEntity> details;

  const PayrollDetailsLoaded({required this.details});

  @override
  List<Object> get props => [details];
}
