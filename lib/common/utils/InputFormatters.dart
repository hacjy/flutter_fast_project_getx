// ignore: file_names
import 'package:flutter/services.dart';

class InputFormatter extends TextInputFormatter {
  final String regExp;

  InputFormatter({this.regExp = "[a-zA-Z]"});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (RegExp(regExp).firstMatch(newValue.text) != null) {
        return newValue;
      }
      return oldValue;
    }
    return newValue;
  }
}
