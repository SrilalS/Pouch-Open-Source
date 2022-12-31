class Validations{


  static bool isValidPercentage(String value) {
    if (value.isEmpty) {
      return false;
    }
    final n = num.tryParse(value);
    return (n != null) && (n >= 0) && (n <= 100);
  }
}