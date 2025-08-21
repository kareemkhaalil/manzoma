import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../models/payroll_model.dart';

abstract class PayrollRemoteDataSource {
  Future<PayrollModel> createPayroll({
    required String userId,
    required String period,
    required double basicSalary,
    double allowances = 0,
    double deductions = 0,
    double overtime = 0,
    double bonus = 0,
    required int workingDays,
    required int actualWorkingDays,
    String? notes,
  });

  Future<List<PayrollModel>> getPayrollHistory({
    required String userId,
    String? period,
    int? limit,
    int? offset,
  });

  Future<List<PayrollModel>> getAllPayrolls({
    String? period,
    String? status,
    int? limit,
    int? offset,
  });

  Future<PayrollModel> updatePayroll({
    required String payrollId,
    double? basicSalary,
    double? allowances,
    double? deductions,
    double? overtime,
    double? bonus,
    int? workingDays,
    int? actualWorkingDays,
    String? status,
    String? notes,
  });

  Future<void> deletePayroll({required String payrollId});

  Future<PayrollModel> approvePayroll({required String payrollId});

  Future<PayrollModel> markAsPaid({required String payrollId});
}

class PayrollRemoteDataSourceImpl implements PayrollRemoteDataSource {
  final SupabaseClient supabaseClient;

  PayrollRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<PayrollModel> createPayroll({
    required String userId,
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
    try {
      // Get user info
      final userProfile = await supabaseClient
          .from('profiles')
          .select('name')
          .eq('id', userId)
          .single();

      // Calculate net salary
      final netSalary =
          basicSalary + allowances + overtime + bonus - deductions;

      final payrollData = {
        'user_id': userId,
        'user_name': userProfile['name'],
        'period': period,
        'basic_salary': basicSalary,
        'allowances': allowances,
        'deductions': deductions,
        'overtime': overtime,
        'bonus': bonus,
        'net_salary': netSalary,
        'working_days': workingDays,
        'actual_working_days': actualWorkingDays,
        'status': 'draft',
        'notes': notes,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await supabaseClient
          .from('payroll')
          .insert(payrollData)
          .select()
          .single();

      return PayrollModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PayrollModel>> getPayrollHistory({
    required String userId,
    String? period,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query =
          supabaseClient.from('payroll').select().eq('user_id', userId);

      if (period != null) {
        query = query.eq('period', period);
      }

      query = query.order('period', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;

      return response.map((json) => PayrollModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PayrollModel>> getAllPayrolls({
    String? period,
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = supabaseClient.from('payroll').select();

      if (period != null) {
        query = query.eq('period', period);
      }

      if (status != null) {
        query = query.eq('status', status);
      }

      query = query.order('period', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;

      return response.map((json) => PayrollModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PayrollModel> updatePayroll({
    required String payrollId,
    double? basicSalary,
    double? allowances,
    double? deductions,
    double? overtime,
    double? bonus,
    int? workingDays,
    int? actualWorkingDays,
    String? status,
    String? notes,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (basicSalary != null) updateData['basic_salary'] = basicSalary;
      if (allowances != null) updateData['allowances'] = allowances;
      if (deductions != null) updateData['deductions'] = deductions;
      if (overtime != null) updateData['overtime'] = overtime;
      if (bonus != null) updateData['bonus'] = bonus;
      if (workingDays != null) updateData['working_days'] = workingDays;
      if (actualWorkingDays != null)
        updateData['actual_working_days'] = actualWorkingDays;
      if (status != null) updateData['status'] = status;
      if (notes != null) updateData['notes'] = notes;

      // Recalculate net salary if any salary components changed
      if (basicSalary != null ||
          allowances != null ||
          deductions != null ||
          overtime != null ||
          bonus != null) {
        // Get current values first
        final current = await supabaseClient
            .from('payroll')
            .select('basic_salary, allowances, deductions, overtime, bonus')
            .eq('id', payrollId)
            .single();

        final newBasicSalary = basicSalary ?? current['basic_salary'];
        final newAllowances = allowances ?? current['allowances'];
        final newDeductions = deductions ?? current['deductions'];
        final newOvertime = overtime ?? current['overtime'];
        final newBonus = bonus ?? current['bonus'];

        updateData['net_salary'] = newBasicSalary +
            newAllowances +
            newOvertime +
            newBonus -
            newDeductions;
      }

      final response = await supabaseClient
          .from('payroll')
          .update(updateData)
          .eq('id', payrollId)
          .select()
          .single();

      return PayrollModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deletePayroll({required String payrollId}) async {
    try {
      await supabaseClient.from('payroll').delete().eq('id', payrollId);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PayrollModel> approvePayroll({required String payrollId}) async {
    try {
      final response = await supabaseClient
          .from('payroll')
          .update({
            'status': 'approved',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', payrollId)
          .select()
          .single();

      return PayrollModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PayrollModel> markAsPaid({required String payrollId}) async {
    try {
      final response = await supabaseClient
          .from('payroll')
          .update({
            'status': 'paid',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', payrollId)
          .select()
          .single();

      return PayrollModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
