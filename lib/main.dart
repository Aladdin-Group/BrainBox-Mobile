import 'package:brain_box/core/singeltons/service_locator.dart';
import 'package:brain_box/feature/auth/presentation/manager/auth_bloc.dart';
import 'package:brain_box/feature/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:easy_localization/easy_localization.dart';

import 'core/assets/theme/color_schemes.g.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await MobileAds.instance.initialize();
  FlutterNativeSplash.remove();
  setupLocator();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'),Locale('uz','UZ'),Locale('ru','RU')],
      path: 'assets/translations',
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme,visualDensity: VisualDensity.adaptivePlatformDensity,),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme,visualDensity: VisualDensity.adaptivePlatformDensity,),
        home: const SplashScreen(),
      ),
    );
  }
}