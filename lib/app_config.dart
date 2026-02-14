var this_year = DateTime.now().year.toString();

class AppConfig {
  //configure this
  static String copyright_text =
      "@ zahyastore $this_year"; //this shows in the splash screen
  static String app_name = "Zahya Store"; //this shows in the splash screen
  static String search_bar_text =
      "Search in zahyastore..."; //this will show in app Search bar.
  static String purchase_code =
      "b15c483b-686a-1343-a919-810ac895d0dc"; //enter your purchase code for the app from codecanyon
  static String system_key =
      r"$2y$10$PB5hN9sjHT9QiPx5.NSfBeu2aqEsOW5q/taKosbCwydzBq.GWR2my"; //enter your purchase code for the app from codecanyon

  //Default language config
  static String default_language = "en";
  static String mobile_app_code = "en";
  static bool app_language_rtl = false;
  //configure this
  static const bool HTTPS =
      true; //if you are using localhost , set this to false
  static const DOMAIN_PATH = "zahyastores.com"; //updated base domain
  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "$PROTOCOL$DOMAIN_PATH";
  static const String BASE_URL = "$RAW_BASE_URL/$API_ENDPATH";
}
