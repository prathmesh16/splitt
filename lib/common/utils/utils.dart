class Utils {
  static Map<String, T> convertMapValuesToType<T>(Map<String, dynamic> json) {
    return json.map((key, value) => MapEntry(key, value as T));
  }
}
