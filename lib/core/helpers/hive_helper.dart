import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static late Box box;

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('token');
    box = Hive.box('token');
  }

  static Future<void> storeData(String key, String data) async {
    await box.put(key, data);
  }

  static String? getData(String key) {
    return box.get(key);
  }

  static Future<void> deleteData(String key) async {
    await box.delete(key);
  }
}
