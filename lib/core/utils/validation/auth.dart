import 'package:formz/formz.dart';

class Username extends FormzInput<String, String> {
  const Username.pure() : super.pure('');
  const Username.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) {
    // ضع قواعد التحقق من صحة اسم المستخدم هنا
    // مثلا:
    if (value.isEmpty) {
      return "ادخل اسم المستخدم";
    }
    return null;
  }
}

class Password extends FormzInput<String, String> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return ' ادخل كلمة المرور ';
    }
    return null;
  }
}
