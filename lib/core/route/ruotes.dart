import 'package:brain_box/feature/auth/presentation/auth_screen.dart';
import 'package:brain_box/feature/lang/presentation/language_screen.dart';
import 'package:brain_box/feature/navigation/presentation/pages/lading_page.dart';
import 'package:brain_box/feature/settings/presentation/pages/shop_page.dart';
import 'package:brain_box/feature/splash/presentation/splash_screen.dart';
import 'package:brain_box/feature/words/presentation/words_screen.dart';
import 'package:flutter/material.dart';

class RouteNames {
  static const String splash = '/';
  static const String landingPage = '/landingPage';
  static const String language = '/language';
  static const String auth = '/auth';
  static const String words = '/words';
  static const String shopPage = '/shopPage';





}

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    switch(settings.name){
      case RouteNames.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouteNames.landingPage:
        return MaterialPageRoute(builder: (context) => const LadingPage());
      case RouteNames.language:
        return MaterialPageRoute(builder: (context) => const LanguageScreen());
      case RouteNames.auth:
        return MaterialPageRoute(builder: (context) => const AuthScreen());
      case RouteNames.words:
        return MaterialPageRoute(builder: (context) =>  WordsScreen(movieId: settings.arguments as int,));
      case RouteNames.shopPage:
        return MaterialPageRoute(builder: (context) => const ShopPage());
    }
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text("Route not found"),
        ),
      ),
    );
  }
}
