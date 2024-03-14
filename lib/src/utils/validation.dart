import 'package:flutter/cupertino.dart';

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
        email.trim().split('@')[1].split('.')[1].isEmpty ||
        email.trim().split('.')[1].length < 2) {
      return 'Not a valid email!';
    }
    return null;
  }
}
