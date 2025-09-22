// import 'package:manzoma/features/payroll/data/models/payroll_rules_model.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../../core/error/exceptions.dart';

// abstract class PayrollRulesRemoteDataSource {
//   Future<List<PayrollRuleModel>> getAllRules();
//   Future<PayrollRuleModel> createRule(PayrollRuleModel rule);
//   Future<PayrollRuleModel> updateRule(
//       {required String ruleId, required Map<String, dynamic> data});
//   Future<void> deleteRule(String ruleId);
// }

// class PayrollRulesRemoteDataSourceImpl implements PayrollRulesRemoteDataSource {
//   final SupabaseClient supabaseClient;

//   PayrollRulesRemoteDataSourceImpl({required this.supabaseClient});

//   @override
//   Future<PayrollRuleModel> createRule(PayrollRuleModel rule) async {
//     try {
//       final response = await supabaseClient
//           .from('payroll_rules')
//           .insert(rule.toJson())
//           .select()
//           .maybeSingle();
//       return PayrollRuleModel.fromJson(response);
//     } on PostgrestException catch (e) {
//       throw ServerException(
//           message: e.message, statusCode: int.tryParse(e.code ?? ''));
//     } catch (e) {
//       throw ServerException(message: e.toString());
//     }
//   }

//   @override
//   Future<void> deleteRule(String ruleId) async {
//     try {
//       await supabaseClient.from('payroll_rules').delete().eq('id', ruleId);
//     } on PostgrestException catch (e) {
//       throw ServerException(
//           message: e.message, statusCode: int.tryParse(e.code ?? ''));
//     } catch (e) {
//       throw ServerException(message: e.toString());
//     }
//   }

//   @override
//   Future<List<PayrollRuleModel>> getAllRules() async {
//     try {
//       final response = await supabaseClient.from('payroll_rules').select();
//       return response.map((json) => PayrollRuleModel.fromJson(json)).toList();
//     } on PostgrestException catch (e) {
//       throw ServerException(
//           message: e.message, statusCode: int.tryParse(e.code ?? ''));
//     } catch (e) {
//       throw ServerException(message: e.toString());
//     }
//   }

//   @override
//   Future<PayrollRuleModel> updateRule(
//       {required String ruleId, required Map<String, dynamic> data}) async {
//     try {
//       final response = await supabaseClient
//           .from('payroll_rules')
//           .update(data)
//           .eq('id', ruleId)
//           .select()
//           .maybeSingle();
//       return PayrollRuleModel.fromJson(response);
//     } on PostgrestException catch (e) {
//       throw ServerException(
//           message: e.message, statusCode: int.tryParse(e.code ?? ''));
//     } catch (e) {
//       throw ServerException(message: e.toString());
//     }
//   }
// }
import 'package:manzoma/features/payroll/data/models/payroll_rules_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PayrollRulesRemoteDataSource {
  Future<List<PayrollRuleModel>> getAllRules(String tenantId);
  Future<PayrollRuleModel> createRule(PayrollRuleModel rule);
  Future<PayrollRuleModel> updateRule(PayrollRuleModel rule);
  Future<void> deleteRule(String ruleId);
}

class PayrollRulesRemoteDataSourceImpl implements PayrollRulesRemoteDataSource {
  final SupabaseClient client;
  PayrollRulesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PayrollRuleModel>> getAllRules(String tenantId) async {
    final response =
        await client.from('payroll_rules').select().eq('tenant_id', tenantId);
    return (response as List)
        .map((e) => PayrollRuleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PayrollRuleModel> createRule(PayrollRuleModel rule) async {
    final response = await client
        .from('payroll_rules')
        .insert(rule.toJson())
        .select()
        .maybeSingle();
    return PayrollRuleModel.fromJson(response!);
  }

  @override
  Future<PayrollRuleModel> updateRule(PayrollRuleModel rule) async {
    final response = await client
        .from('payroll_rules')
        .update(rule.toJson())
        .eq('id', rule.id)
        .select()
        .maybeSingle();
    return PayrollRuleModel.fromJson(response!);
  }

  @override
  Future<void> deleteRule(String ruleId) async {
    await client.from('payroll_rules').delete().eq('id', ruleId);
  }
}
