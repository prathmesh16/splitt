class CurrencyDataStore {
  static final CurrencyDataStore _instance = CurrencyDataStore._();

  CurrencyDataStore._();

  factory CurrencyDataStore() {
    return _instance;
  }

  static const String inrSymbol = "₹";

  String selectedCurrency = "INR";

  final Map<String, String> _currencies = {
    "INR": inrSymbol,
  };

  String getCurrencySymbol(String currency) {
    return _currencies[currency] ?? inrSymbol;
  }
}
