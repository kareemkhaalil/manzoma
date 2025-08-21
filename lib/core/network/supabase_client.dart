import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://ngjygharnzhlvcpmpxxy.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_Rzf4wpnvJBVffpUTJxkYcQ_4Iq2oy61';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}

// Extension to make Supabase operations easier
extension SupabaseExtensions on SupabaseClient {
  // Auth helpers
  User? get currentUser => auth.currentUser;
  bool get isAuthenticated => auth.currentUser != null;

  // Database helpers
  SupabaseQueryBuilder table(String tableName) => from(tableName);

  // Storage helpers
  SupabaseStorageClient get storage => Supabase.instance.client.storage;
}
