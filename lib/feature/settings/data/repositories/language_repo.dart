import 'package:brain_box/feature/settings/data/models/language_model.dart';
import 'package:flutter/material.dart';

class LanguageRepository {
  LanguageRepository._();

  static List<LanguageModel> languages = [
    const LanguageModel(locale: Locale('uz', 'UZ'), name: 'O`zbek', shortName: 'uz'),
    const LanguageModel(locale: Locale('ru', 'RU'), name: 'Русский', shortName: 'ru'),
    const LanguageModel(locale: Locale('en', 'US'), name: 'English', shortName: 'en'),
  ];

  static LanguageModel get uz => languages[0];

  static LanguageModel get ru => languages[1];

  static LanguageModel get en => languages[2];
}
