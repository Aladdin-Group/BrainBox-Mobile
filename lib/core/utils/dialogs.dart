import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogs {
  static showLoadingDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(content: CupertinoActivityIndicator());
      },
    );
  }
}
