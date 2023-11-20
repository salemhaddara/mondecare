import 'package:flutter/services.dart';

class NumericTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Use a regular expression to keep only numeric characters
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
