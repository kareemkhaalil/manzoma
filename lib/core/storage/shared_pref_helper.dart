// lib/core/storage/shared_pref_helper.dart
import 'dart:convert';
import 'package:manzoma/core/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manzoma/features/auth/data/models/user_model.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;
  static const _userKey = 'user';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveUser(UserModel user) async {
    await _prefs?.setString(_userKey, jsonEncode(user.toJson()));
  }

  static UserEntity? getUser() {
    final jsonString = _prefs?.getString('user');
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final model = UserModel.fromJson(jsonMap);
    return model.toEntity();
  }

  static Future<void> clearUser() async {
    await _prefs?.remove(_userKey);
  }

  // باقي setData/getData كما هي لو محتاجها
}
