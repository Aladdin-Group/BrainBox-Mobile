import 'dart:io';
import 'dart:ui';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/assets/constants/colors.dart';
import 'package:brain_box/core/assets/constants/icons.dart';
import 'package:brain_box/feature/lang/presentation/language_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:freerasp/freerasp.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/adapters/storage/content_adpater.dart';
import '../../../core/adapters/storage/user_adapter.dart';
import '../../../core/adapters/storage/word_adapter.dart';
import '../../../core/fcm_service/fcm_service.dart';
import '../../../core/singletons/service_locator.dart';
import '../../../core/singletons/storage/storage_repository.dart';
import '../../../core/singletons/storage/store_keys.dart';
import '../../../firebase_options.dart';
import '../../main/data/models/Movie.dart';
import '../../navigation/presentation/pages/lading_page.dart';
import '../../notification/data/models/notification_model.dart';
import '../../reminder/data/models/local_word.dart';

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
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // await registerForFCMNotifications();
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    // 1:519103600258:android:36643015179e2dc0e7469b
    final callback = ThreatCallback(
      onAppIntegrity: () => exit(0),
      onObfuscationIssues: () => exit(0),
      onDebug: () => exit(0),
      onDeviceBinding: () => exit(0),
      onHooks: () => exit(0),
      onPrivilegedAccess: () => exit(0),
      onSecureHardwareNotAvailable: () => exit(0),
      onSimulator: () => exit(0),
      onUnofficialStore: () => exit(0),
    );

    // Attaching listener
    Talsec.instance.attachListener(callback);

    await EasyLocalization.ensureInitialized();

    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(WordHiveAdapter());
    Hive.registerAdapter(UserHiveAdapter());
    Hive.registerAdapter(ContentHiveAdapter());
    Hive.registerAdapter(NotificationModelAdapter());
    await Hive.openBox<Content>(StoreKeys.savedWordsList);
    await Hive.openBox<LocalWord>(StoreKeys.localWordsList);
    await Hive.openBox(StoreKeys.userData);
    // await initializeService();
    setupLocator();
    await registerForFCMNotifications();
    await Future.delayed(
      const Duration(milliseconds: 20),
      () async {
        // // TODO: remove this
        // await StorageRepository.putBool(key: StoreKeys.isAuth, value: true);
        // await StorageRepository.putString(StoreKeys.token,
        //     "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJGT1ItTE9HSU4iLCJpc3MiOiJNRURJVU0iLCJ1c2VybmFtZSI6ImlzbG9tQGdtYWlsLmNvbSIsImlhdCI6MTcwNTU3ODE2NywiZXhwIjo4ODEwNTU3ODE2N30.BZwxulL1w_NX-DtwB2hf2W5v19_6oYWQz52Z3YXq-is");
        bool isAuth = StorageRepository.getString(StoreKeys.token).isNotEmpty;
        if (!isAuth) {
          // context.pushAndRemoveUntil(const LanguageScreen());
          context.pushAndRemoveUntil(const LanguageScreen());
        } else {
          context.pushAndRemoveUntil( const LadingPage());
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
