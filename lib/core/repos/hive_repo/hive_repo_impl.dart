import 'package:hive/hive.dart';
import 'package:hudor/core/repos/hive_repo/hive_repo.dart';

class HiveRepoImpl extends HiveRepo {
  final Box box;

  HiveRepoImpl(this.box);

  @override
  Future<void> put(String key, dynamic value) async {
    await box.put(key, value);
  }

  @override
  String? get(String key) {
    return box.get(key) as String?;
  }

  @override
  Future<void> delete(String key) async {
    await box.delete(key);
  }
}
