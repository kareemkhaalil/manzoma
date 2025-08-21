import 'package:equatable/equatable.dart';
import '../../domain/entities/payroll_entity.dart';

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

