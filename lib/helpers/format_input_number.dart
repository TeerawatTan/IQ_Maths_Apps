import 'package:flutter/services.dart';
import 'package:iq_maths_apps/helpers/format_number.dart';

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    int? number = int.tryParse(cleanedText);

    if (number == null) {
      return oldValue;
    }

    String formattedText = formatNumber(number.toString());

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
