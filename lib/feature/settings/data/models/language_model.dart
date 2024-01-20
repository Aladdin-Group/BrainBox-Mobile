import 'package:flutter/material.dart';

class LanguageModel {
  final Locale locale;
  final String name;
  final String shortName;

  const LanguageModel({
    required this.locale,
    required this.name,
    required this.shortName,
  });
}
