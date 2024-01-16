// ignore_for_file: constant_identifier_names

class AppConstants {
  AppConstants._();
  static const BASE_URL_PROD = 'https://api.brainbox.uz/';
  static const SOCKET_URL = 'ws://chat.brainbox.uz:1234';
  static const TOKEN = 'token';
  static const THEME_MODE = 'theme_mode';
  static const LANGUAGE = 'language';
  static const REFRESH = 'refresh';
  static const ON_BOARDING = 'onboarding';
}
// flutter pub run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart