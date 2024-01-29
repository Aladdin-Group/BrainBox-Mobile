import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/assets/constants/colors.dart';
import 'package:brain_box/core/assets/constants/icons.dart';
import 'package:brain_box/feature/lang/presentation/language_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/singletons/storage/storage_repository.dart';
import '../../../core/singletons/storage/store_keys.dart';
import '../../navigation/presentation/pages/lading_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    route(context);
  }

  Future route(BuildContext context) async {
    await Future.delayed(
      const Duration(milliseconds: 20),
      () async {
        // // TODO: remove this
        // await StorageRepository.putBool(key: StoreKeys.isAuth, value: true);
        // await StorageRepository.putString(StoreKeys.token,
        //     "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJGT1ItTE9HSU4iLCJpc3MiOiJNRURJVU0iLCJ1c2VybmFtZSI6ImlzbG9tQGdtYWlsLmNvbSIsImlhdCI6MTcwNTU3ODE2NywiZXhwIjo4ODEwNTU3ODE2N30.BZwxulL1w_NX-DtwB2hf2W5v19_6oYWQz52Z3YXq-is");
        bool isAuth = StorageRepository.getBool(StoreKeys.isAuth) || StorageRepository.getBool(StoreKeys.isSkip);
        if (!isAuth) {
          // context.pushAndRemoveUntil(const LanguageScreen());
          context.pushAndRemoveUntil(const LanguageScreen());
        } else {
          context.pushAndRemoveUntil( LadingPage());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: Center(
          child: Image.asset(
        AppIcons.brain,
        width: 200,
      )),
    );
  }
}
