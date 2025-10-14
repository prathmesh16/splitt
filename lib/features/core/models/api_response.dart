class APIResponse<T> {
  final int statusCode;
  int? errorCode;
  T? data;
  String? errorMessage;

  APIResponse({
    required this.statusCode,
    this.errorCode,
    this.data,
    this.errorMessage,
  });

  bool get isError => errorMessage != null;
}
