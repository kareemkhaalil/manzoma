import 'package:manzoma/core/enums/user_role.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart';
import 'package:manzoma/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/supabase_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? avatar,
  });

  Future<void> resetPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const AuthException(message: 'فشل في تسجيل الدخول');
      }
// داخل signIn()
      final profileResponse = await supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      print('Profile from DB: $profileResponse');

      final roleEnum = UserRoleX.fromValue(
          (profileResponse?['role'] ?? 'employee') as String?);
      print('role enum $roleEnum');

      final map = <String, dynamic>{
        'id': response.user!.id,
        'email': response.user?.email ?? '',
        'tenant_id': profileResponse?['tenant_id'] ?? '',
        'branch_id': profileResponse?['branch_id'],
        'role': roleEnum.toValue(), // مهم
        'name': profileResponse?['name'] ?? response.user?.email ?? '',
        'phone': profileResponse?['phone'],
        'avatar': profileResponse?['avatar'],
        'is_active': profileResponse?['is_active'] ?? true,
        'base_salary': profileResponse?['base_salary'] ?? 0,
        'allowances': profileResponse?['allowances'] ?? const [],
        'deductions': profileResponse?['deductions'] ?? const [],
        'work_schedule': profileResponse?['work_schedule'] ?? const {},
        'created_at': profileResponse?['created_at'],
        'updated_at': profileResponse?['updated_at'],
      };

      final loggedInUser = UserModel.fromJson(map);
      await SharedPrefHelper.saveUser(loggedInUser);

      return loggedInUser;

      return UserModel.fromJson(map);
    } on PostgrestException catch (e) {
      print(" error after post data login ");
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      print(" error after post data login end");

      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const AuthException(message: 'فشل في إنشاء الحساب');
      }

      // Create user profile
      await supabaseClient.from('profiles').insert({
        'id': response.user!.id,
        'name': name,
        'role': role,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      return UserModel.fromJson({
        'id': response.user!.id,
        'email': email,
        'name': name,
        'role': role,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
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
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return null;

      final profileResponse = await supabaseClient
          .from('users_view')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson({
        'id': user.id,
        'email': user.email!,
        ...profileResponse,
      });
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
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? avatar,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (avatar != null) updateData['avatar'] = avatar;

      final response = await supabaseClient
          .from('profiles')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(response);
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
  Future<void> resetPassword({required String email}) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
