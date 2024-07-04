abstract class HiveRepo {
  Future<void> put(String key, dynamic value);
  String? get(String key);
  Future<void> delete(String key);
}
