import 'package:flutter/cupertino.dart';

enum PasswordType {
  digitLetter,
  digitLetterSpecial,
  digitLetterLowerUpper,
  digitLetterLowerUpperSpecial;

  RegExp regex({
    int minLength = 8,
    int? maxLength,
  }) =>
      RegExp(switch (this) {
        PasswordType.digitLetter =>
          '^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{$minLength,${maxLength ?? ""}}',
        PasswordType.digitLetterSpecial =>
          '^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{$minLength,${maxLength ?? ""}',
        PasswordType.digitLetterLowerUpper =>
          '^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@\$!%*#?&])[A-Za-z\\d@\$!%*#?&]{$minLength,${maxLength ?? ""}',
        PasswordType.digitLetterLowerUpperSpecial =>
          '^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@\$!%*?&])[A-Za-z\\d@\$!%*?&]{$minLength,${maxLength ?? ""}',
      });

  String get errorMessage => switch (this) {
        PasswordType.digitLetter =>
          'Needs to have at least one letter and one digit!',
        PasswordType.digitLetterSpecial =>
          'Needs to have at least one letter, one digit and one special character!',
        PasswordType.digitLetterLowerUpper =>
          'Needs to have at least one lowercase letter, one uppercase letter and one digit!',
        PasswordType.digitLetterLowerUpperSpecial =>
          'Needs to have at least one lowercase letter, one uppercase letter, one digit and one special character!',
      };
}

class ValidationUtils {
  static bool _empty(String? text) => text == null || text.trim().isEmpty;

  static String? name(String? name, {bool required = true, int minLength = 3}) {
    if (_empty(name)) {
      if (required) {
        return 'Field is required!';
      }
      return null;
    }
    if (name!.trim().length < minLength) {
      return 'At least $minLength characters!';
    }
    return null;
  }

  static String? password(String? password, PasswordType type,
      {bool required = true, int minLength = 8, int? maxLength}) {
    if (_empty(password)) {
      if (required) {
        return 'Field is required!';
      }
      return null;
    }
    if (password!.trim().length < minLength) {
      return 'At least $minLength characters!';
    }
    if (maxLength != null && password.trim().length > maxLength) {
      return 'At least $minLength characters!';
    }

    if (!password
        .contains(type.regex(minLength: minLength, maxLength: maxLength))) {
      return type.errorMessage;
    }
    return null;
  }

  static String? number(String? number,
      {bool required = true, bool shouldBeInt = false}) {
    if (_empty(number)) {
      if (required) {
        return 'Field is required!';
      }
      return null;
    }
    if (num.tryParse(number!.trim())?.isNaN ?? true) {
      return 'Must be a number!';
    }
    if (shouldBeInt &&
        num.parse(number.trim()).truncateToDouble() !=
            double.parse(number.trim())) {
      return 'Must be an integer!';
    }
    return null;
  }

  static String? url(String? url, {bool required = true}) {
    if (_empty(url)) {
      if (required) {
        return 'Field is required!';
      }
      return null;
    }
    if (!url!.trim().toLowerCase().startsWith('https://') &&
        !url.trim().toLowerCase().startsWith('http://')) {
      return 'Not a valid URL!';
    }
    return null;
  }

  static String? email(String? email, {bool required = true}) {
    if (_empty(email)) {
      if (required) {
        return 'Field is required!';
      }
      return null;
    }
    if (email!.trim().characters.where((char) => char == '@').length != 1 ||
        email.trim().split('@')[0].isEmpty ||
        email.trim().split('@')[1].split('.')[0].isEmpty ||
        email.trim().split('@')[1].split('.')[1].length < 2) {
      return 'Not a valid email!';
    }
    return null;
  }
}
