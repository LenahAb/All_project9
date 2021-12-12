class Validator {
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'لا يمكن أن يكون الاسم فارغًا';
    } else if (name.length < 3) {
  return 'أدخل الأسم بطول 3 أحرف او ارقام على الأقل';
  }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'لا يمكن أن يكون البريد الإلكتروني فارغًا';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'أدخل بريدًا إلكترونيًا صحيحًا';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'لا يمكن أن تكون كلمة المرور فارغة';
    } else if (password.length < 6) {
      return 'أدخل كلمة مرور بطول 6 أحرف او ارقام على الأقل';
    }

    return null;
  }

  static String? validateField({required String value}) {
  if (value.isEmpty) {
  return 'لا يمكن أن يكون الحقل فارغًا';
  }

  return null;
  }
}
