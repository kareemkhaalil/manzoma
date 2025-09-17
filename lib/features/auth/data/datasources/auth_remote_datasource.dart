import 'package:manzoma/core/enums/user_role.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart';
import 'package:manzoma/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      // Sign in with Supabase Auth
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const AuthException(
            'فشل في تسجيل الدخول: بيانات المستخدم غير موجودة');
      }

      // Fetch user profile from the users table
      final profileResponse = await supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      // Check if profile exists
      if (profileResponse == null) {
        throw ServerException(
          message: 'لم يتم العثور على ملف المستخدم في قاعدة البيانات',
        );
      }

      print('Profile from DB: $profileResponse');

      // Parse role safely
      final roleEnum =
          UserRoleX.fromValue(profileResponse['role'] as String? ?? 'employee');
      print('Role enum: $roleEnum');

      // Create user model
      final map = <String, dynamic>{
        'id': response.user!.id,
        'email': response.user?.email ?? '',
        'tenant_id': profileResponse['tenant_id'] as String? ?? '',
        'branch_id': profileResponse['branch_id'] as String?,
        'role': roleEnum.toValue(),
        'name':
            profileResponse['name'] as String? ?? response.user?.email ?? '',
        'phone': profileResponse['phone'] as String?,
        'avatar': profileResponse['avatar'] as String?,
        'is_active': profileResponse['is_active'] as bool? ?? true,
        'base_salary': profileResponse['base_salary'] != null
            ? double.tryParse(profileResponse['base_salary'].toString()) ?? 0.0
            : 0.0,
        'allowances':
            (profileResponse['allowances'] as List?)?.toList() ?? const [],
        'deductions':
            (profileResponse['deductions'] as List?)?.toList() ?? const [],
        'work_schedule': (profileResponse['work_schedule'] as Map?)
                ?.cast<String, dynamic>() ??
            const {},
        'created_at': profileResponse['created_at'] as String?,
        'updated_at': profileResponse['updated_at'] as String?,
      };

      final loggedInUser = UserModel.fromJson(map);
      await SharedPrefHelper.saveUser(loggedInUser);

      return loggedInUser;
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      throw ServerException(message: e.message);
    } catch (e) {
      print('General error: $e');
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
        throw const AuthException('فشل في إنشاء الحساب');
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
          .maybeSingle();

      return UserModel.fromJson({
        'id': user.id,
        'email': user.email!,
        ...?profileResponse,
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
          .maybeSingle();

      return UserModel.fromJson(response!);
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
