import 'package:brain_box/core/assets/constants/app_fonts.dart';
import 'package:brain_box/core/assets/constants/colors.dart';
import 'package:flutter/material.dart';

import 'color_schemes.g.dart';

class DarkTheme{

  static AppColors colors = AppColors();
  static AppFonts appFonts = AppFonts();

  static ThemeData theme() => ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
        titleTextStyle: displaySmall,
        color: AppColors.scaffoldBackgroundColorDark,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black38
    ),
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColorDark,
    textTheme: const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelSmall: labelSmall,
    ),
    colorScheme: darkColorScheme,

  );


  static const displayLarge = TextStyle(
    fontSize: 70,
    fontFamily: AppFonts.vkBold,
    color: Colors.white,
  );

  static const displayMedium = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    fontFamily: AppFonts.vkMedium,
    color: Colors.white,
  );

  static const displaySmall = TextStyle(
    fontSize: 29,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.vkRegular,
    color: Colors.white,
  );

  static const headlineMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.vkDemiBold,
    color: Colors.white,
  );

  static const headlineSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white30,
    letterSpacing: -0.17,
    fontFamily: AppFonts.vkRegular,
  );

  static const titleLarge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.vkBold,
    color: Colors.white,
  );

  static const bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.vkBold,
    color: Colors.white,
  );

  static const bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.vkMedium,
    color: Colors.white,
  );

  static const titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.vkMedium,
    color: Colors.white,
  );

  static const titleSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.vkMedium,
    color: Colors.white,
  );

  static const bodySmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.vkRegular,
    color: Colors.white,
  );

  static const labelLarge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.vkDemiBold,
    color: Colors.white,
  );

  static const labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.vkRegular,
    color: Colors.white,
  );
}