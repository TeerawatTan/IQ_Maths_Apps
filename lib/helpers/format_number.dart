String formatNumber(String number) {
  String numStr = number;
  bool isNegative = numStr.startsWith('-');

  if (isNegative) {
    numStr = numStr.substring(1);
  }

  String formatted = numStr.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );

  return isNegative ? '-$formatted' : formatted;
}
