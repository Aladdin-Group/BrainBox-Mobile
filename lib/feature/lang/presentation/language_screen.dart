import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/route/ruotes.dart';
import 'package:brain_box/core/utils/custom_styles.dart';
import 'package:brain_box/feature/auth/presentation/auth_screen.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets/constants/icons.dart';

/// LanguageScreen is a Flutter widget that allows users to select the app language
/// before navigating to the authentication screen.
///
/// This widget provides buttons to choose from different languages and sets the
/// selected language using EasyLocalization package. It then navigates to the
/// authentication screen using the specified route.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  /// Sets the selected language and navigates to the authentication screen.
  ///
  /// The [languageCode] parameter represents the language code (e.g., 'en').
  /// The [countryCode] parameter represents the country code (e.g., 'US').
  /// The [context] parameter is the [BuildContext] used for navigation.
  void _chooseAndAuth(String la, String ng, BuildContext context) async {
    context.setLocale(Locale(la, ng));
    context.pushNamed(RouteNames.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Logo
              SizedBox(width: double.maxFinite, height: 220, child: Image.asset(AppIcons.brain)),

              /// App Title
              AutoSizeText(
                'BrainBox',
                textAlign: TextAlign.center,
                style: GoogleFonts.kronaOne(fontSize: 35),
              ),
              const Gap(75),

              /// Language Selection Propmpt
              AutoSizeText(
                LocaleKeys.chooseAppLang.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),

              /// Language Selection Buttons
              const Gap(30),
              _buildLanguageButton('English', 'en', 'US', context),
              const Gap(15),
              _buildLanguageButton('Русский', 'ru', 'RU', context),
              const Gap(15),
              _buildLanguageButton('O\'zbekcha', 'uz', 'UZ', context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a language selection button.
  ///
  /// The [label] parameter is the display text on the button.
  /// The [languageCode] and [countryCode] parameters represent the selected language.
  /// The [context] parameter is the [BuildContext] used for navigation.
  Widget _buildLanguageButton(
      String label, String languageCode, String countryCode, BuildContext context) {
    return SizedBox(
      height: 50,
      /// Filled button todo
      child: ElevatedButton(
        onPressed: () => _chooseAndAuth(languageCode, countryCode, context),
        style: CustomStyles.buttonStyle,
        child: Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
