class Validator {
  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل كلمة السر ';
    }
    //  else if (value.length < 6) {
    //   return 'Password must be at least 6 characters';
    // }
    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    } else if (value != password) {
      return 'Confirm password does not match';
    }
    return null;
  }

  // Name validation
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل اسم المستخدم';
    }
    return null;
  }

// National Number validation
  String? validateIdNum(String? value) {
    if (value == null || value.isEmpty) {
      return "ادخل الرقم القومي";
    } else if (value.length < 14) {
      return 'الرقم القومي يجب ان يكون 14 رقم';
    }
    return null;
  }

// Date of birth validation
  String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل تاريخ الميلاد';
    } else {
      return null;
    }
  }

  String? validateGender(String? value, String? nationalId) {
    if (value == null || value.isEmpty) {
      return 'ادخل النوع';
    } else {
      try {
        String genderFromId = nationalId!.substring(12, 13);

        if (value.toLowerCase() == 'ذكر') {
          if (int.parse(genderFromId) % 2 == 1) {
            return null; // الجنس متطابق
          } else {
            return 'الجنس غير متطابق';
          }
        } else if (value.toLowerCase() == 'أنثى') {
          if (int.parse(genderFromId) % 2 == 0) {
            return null; // الجنس متطابق
          } else {
            return 'الجنس غير متطابق';
          }
        } else {
          return 'النوع غير صحيح';
        }
      } on Exception catch (e) {
        print(e);
        return 'ادخل النوع';
      }
    }
  }

  // Address validation
  String? validateSc(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل رقم الهاتف';
    } else if (value.length < 11 || value.length > 11) {
      return 'رقم الهاتف يجب ان يكون 11 رقم';
    }
    return null;
  }

  // Latitude validation
  String? validateLatitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل خطوط العرض';
    } else {
      final latitude = double.tryParse(value);
      if (latitude == null || latitude < -90 || latitude > 90) {
        return 'خطوط العرض يجب ان تكون بين -90 و 90';
      }
    }
    return null;
  }

  // Longitude validation
  String? validateLongitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل خطوط الطول';
    } else {
      final longitude = double.tryParse(value);
      if (longitude == null || longitude < -180 || longitude > 180) {
        return 'خطوط الطول يجب ان تكون بين -180 و 180';
      }
    }
    return null;
  }
}
