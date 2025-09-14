import 'package:manzoma/features/payroll/data/models/payroll_rules_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';

abstract class EmployeeRulesRemoteDataSource {
  Future<List<PayrollRuleModel>> getRulesForEmployee(String userId);
  Future<void> assignRuleToEmployee(
      {required String userId, required String ruleId});
  Future<void> unassignRuleFromEmployee(
      {required String userId, required String ruleId});
}

class EmployeeRulesRemoteDataSourceImpl
    implements EmployeeRulesRemoteDataSource {
  final SupabaseClient supabaseClient;

  EmployeeRulesRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> assignRuleToEmployee(
      {required String userId, required String ruleId}) async {
    try {
      await supabaseClient.from('employee_salary_rules').insert({
        'user_id': userId,
        'rule_id': ruleId,
      });
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<List<PayrollRuleModel>> getRulesForEmployee(String userId) async {
    try {
      // This is a more complex query using a join
      final response = await supabaseClient
          .from('employee_salary_rules')
          .select('payroll_rules(*)')
          .eq('user_id', userId);

      final rulesList = response
          .map((item) => PayrollRuleModel.fromJson(item['payroll_rules']))
          .toList();
      return rulesList;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<void> unassignRuleFromEmployee(
      {required String userId, required String ruleId}) async {
    try {
      await supabaseClient
          .from('employee_salary_rules')
          .delete()
          .eq('user_id', userId)
          .eq('rule_id', ruleId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }
}
