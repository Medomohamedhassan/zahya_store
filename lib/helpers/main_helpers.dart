import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/system_config.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

bool isNumber(String text) {
  return RegExp('^[0-9]+\$').hasMatch(text);
}

String capitalize(String text) {
  return toBeginningOfSentenceCase(text) ?? text;
}

Map<String, String> get commonHeader => {
      "Content-Type": "application/json",
      "App-Language": app_language.$!,
      "Accept": "application/json",
      "System-Key": AppConfig.system_key
    };
Map<String, String> get authHeader =>
    {"Authorization": "Bearer ${access_token.$}"};
Map<String, String> get currencyHeader =>
    SystemConfig.systemCurrency?.code != null
        ? {
            "Currency-Code": SystemConfig.systemCurrency!.code!,
            "Currency-Exchange-Rate":
                SystemConfig.systemCurrency!.exchangeRate.toString(),
          }
        : {};

String convertPrice(String amount) {
  return amount.replaceAll(
      SystemConfig.systemCurrency!.code!, SystemConfig.systemCurrency!.symbol!);
}

String getParameter(GoRouterState state, String key) =>
    state.pathParameters[key] ?? "";

bool get userIsLogedIn => SystemConfig.systemUser?.id != null;

String validateImageUrl(String? url) {
  if (url == null || url.isEmpty) {
    return "";
  }

  String validatedUrl = url;

  if (validatedUrl.contains("localhost")) {
    validatedUrl = validatedUrl.replaceAll("localhost", "10.0.2.2");
  }

  // Force fix for XAMPP path structure
  if (validatedUrl.contains("/zahyastores/uploads/") &&
      !validatedUrl.contains("/public/uploads/")) {
    validatedUrl = validatedUrl.replaceAll(
        "/zahyastores/uploads/", "/zahyastores/public/uploads/");
  }

  if (!validatedUrl.startsWith("http") && !validatedUrl.startsWith("https")) {
    // If it's a relative path, prepend the base URL
    // Check if it already has the domain path to avoid duplication if RAW_BASE_URL includes it
    if (validatedUrl.startsWith("/")) {
      validatedUrl = validatedUrl.substring(1);
    }

    // Ensure 'public/' is present for local development if not already there
    if (!validatedUrl.startsWith("public/") &&
        validatedUrl.startsWith("uploads/")) {
      validatedUrl = "public/$validatedUrl";
    }

    validatedUrl = "${AppConfig.RAW_BASE_URL}/$validatedUrl";
  }

  return validatedUrl;
}
