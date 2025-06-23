class MathsSetting {
  String digit1;
  String digit2;
  String display;
  String row;
  String time;
  String selectedSubOptionLabel;

  MathsSetting({
    this.digit1 = '',
    this.digit2 = '',
    this.display = '',
    this.row = '',
    this.time = '',
    this.selectedSubOptionLabel = '',
  });

  bool isValid() {
    final d = display.trim().toLowerCase();
    if (d == "multiplication" || d == "division") {
      return digit1.isNotEmpty && digit2.isNotEmpty && time.isNotEmpty;
    }
    return digit1.isNotEmpty &&
        digit2.isNotEmpty &&
        display.isNotEmpty &&
        row.isNotEmpty &&
        time.isNotEmpty;
  }
}
