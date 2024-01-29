import 'package:flutter/material.dart';

class CustomStyles {
  static ButtonStyle buttonStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    )
  );
}
