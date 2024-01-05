import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:brain_box/core/adapters/storage/word_adapter.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/feature/auth/presentation/manager/auth_bloc.dart';
import 'package:brain_box/feature/reminder/data/models/rimnder_date.dart';
import 'package:brain_box/feature/splash/presentation/splash_screen.dart';
import 'package:brain_box/feature/words/data/models/words_response.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:freerasp/freerasp.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/adapters/storage/content_adpater.dart';
import 'core/adapters/storage/user_adapter.dart';
import 'core/assets/theme/color_schemes.g.dart';
import 'core/singletons/service_locator.dart';
import 'core/singletons/storage/hive_controller.dart';
import 'core/singletons/storage/storage_repository.dart';
import 'feature/main/presentation/manager/main/main_bloc.dart';
import 'feature/reminder/data/models/local_word.dart';
import 'feature/settings/presentation/manager/theme/app_theme_bloc.dart';
import 'feature/words/presentation/manager/words_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {

  final appDocumentDirectory =
  await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(WordHiveAdapter());
  await Hive.openBox<LocalWord>(StoreKeys.localWordsList);

  List<LocalWord?>? localWords = await HiveController.getListFromHive();

  int position = 0;

  ReminderDate reminderDate = ReminderDate.getValue(StorageRepository.getDouble(StoreKeys.reminderDate).toInt());
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    print('stopService');
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(Duration(minutes: reminderDate.everyTime), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        if(localWords.isNotEmpty){
          if(localWords.length>position){
            try{
              flutterLocalNotificationsPlugin.show(
                localWords[position]!.notificationId??0,
                '${localWords[position]!.word} => ${localWords[position]!.translate}',
                (localWords.length-1 == position) ? 'This last word, Do you want repeat ?' : 'Need for your feature !',
                (localWords.length-1 == position) ? const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'MEMORIZING_foreground',
                    'MEMORIZING FOREGROUND SERVICE',
                      enableVibration: true,
                    icon: 'app_icon',
                    actions: [
                      AndroidNotificationAction(
                        'accept',
                        'Accept',
                      ),
                      AndroidNotificationAction(
                        'decline',
                        'Decline',
                      )
                    ]
                  )
              ): const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'MEMORIZING_foreground',
                    'MEMORIZING FOREGROUND SERVICE',
                    enableVibration: true,
                    icon: 'app_icon',
                  ),
                )
              );
            }catch(e){
              print(e);
            }
          }
        }
        if(position==localWords.length){
          position = 0;
          return;
        }
        position++;
      }
    }

    service.invoke(
      'update',
    );
  });
}

Future<void> onNotificationClick(String payload) async {
  print(payload);
  if (payload == 'accept') {
    print('Accept');
    print('Accept');
    print('Accept');
    print('Accept');
    print('Accept');
    print('Accept');
    print('Accept');
    print('Accept');
    print('Accept');
    print('Accept');
    print('Accept');
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    playSound: true,
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    // await flutterLocalNotificationsPlugin.initialize(
    //   const InitializationSettings(
    //     iOS: DarwinInitializationSettings(),
    //     android: AndroidInitializationSettings('app_icon'),
    //   ),
    // );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  final appDocumentDirectory =
  await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(WordHiveAdapter());
  Hive.registerAdapter(UserHiveAdapter());
  Hive.registerAdapter(ContentHiveAdapter());
  await Hive.openBox<Content>(StoreKeys.savedWordsList);
  await Hive.openBox<LocalWord>(StoreKeys.localWordsList);
  await Hive.openBox(StoreKeys.userData);
  await initializeService();
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
        BlocProvider(create: (context) => MainBloc()),
        BlocProvider(create: (context) => AppThemeBloc()),
        BlocProvider(create: (context) => WordsBloc()),
      ],
      child: BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, state) {
        return MaterialApp(
          title: 'Flutter Demo',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: state.switchValue ? ThemeData(useMaterial3: true, colorScheme: darkColorScheme,visualDensity: VisualDensity.adaptivePlatformDensity,) : ThemeData(useMaterial3: true, colorScheme: lightColorScheme,visualDensity: VisualDensity.adaptivePlatformDensity,),
          home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
