import 'package:flutter/services.dart';
import 'package:splitt/config/flavor.dart';

late final AppConfig appConfig;

abstract class AppConfig {
  Flavor get flavor;

  String get baseUrl;

  factory AppConfig() {
    const flavor = appFlavor == "prod" ? Flavor.prod : Flavor.qa;
    return switch (flavor) {
      Flavor.qa => QaAppConfig(),
      Flavor.prod => ProdAppConfig(),
    };
  }
}

class QaAppConfig implements AppConfig {
  @override
  String get baseUrl => "http://10.0.2.2:8081/api/";

  @override
  Flavor get flavor => Flavor.qa;
}

class ProdAppConfig implements AppConfig {
  @override
  String get baseUrl => "http://91.108.110.56:8081/api/";

  @override
  Flavor get flavor => Flavor.prod;
}
