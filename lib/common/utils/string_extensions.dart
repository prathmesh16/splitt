extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) {
      return "";
    }
    if (length == 1) {
      return toUpperCase();
    }
    return this[0].toUpperCase() + substring(1);
  }
}
