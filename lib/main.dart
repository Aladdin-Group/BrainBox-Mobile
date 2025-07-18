import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:brain_box/core/fcm_service/fcm_service.dart';
import 'package:brain_box/core/route/ruotes.dart';
import 'package:brain_box/feature/auth/presentation/manager/auth_bloc.dart';
import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:brain_box/feature/navigation/presentation/cubit/navigation_cubit.dart';
import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:brain_box/feature/notification/data/models/push_notification_model.dart';
import 'package:brain_box/feature/notification/data/repositories/notification_box.dart';
import 'package:brain_box/feature/notification/presentation/manager/local_notification_bloc.dart';
import 'package:brain_box/feature/reminder/presentation/manager/remainder_bloc.dart';
import 'package:brain_box/feature/settings/presentation/manager/save_words/save_words_bloc.dart';
import 'package:brain_box/feature/settings/presentation/manager/settings/settings_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/assets/theme/color_schemes.g.dart';
import 'feature/main/presentation/manager/main/main_bloc.dart';
import 'feature/settings/presentation/manager/theme/app_theme_bloc.dart';
import 'feature/splash/presentation/splash_screen.dart';
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
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  showLocalNotification(
      PushNotificationModel(title: "${message.notification?.title} on background", body: message.notification?.body));
  await NotificationBox.addNotification(NotificationModel.fromMap(message.data));
  navigatorKey.currentContext?.read<LocalNotificationBloc>().add(FetchNotifications());
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   final appDocumentDirectory = await getApplicationDocumentsDirectory();
//   Hive.init(appDocumentDirectory.path);
//   Hive.registerAdapter(WordHiveAdapter());
//   await Hive.openBox<LocalWord>(StoreKeys.localWordsList);
//   List<LocalWord?>? localWords = await HiveController.getListFromHive();
//   bool getFromSavedList = StorageRepository.getBool(StoreKeys.getWordsFromSavedList);
//   if (getFromSavedList) {
//     final savedList = SavedController.getListFromHive();
//     for (final element in savedList) {
//       final local = LocalWord(
//         id: element.id,
//         word: element.value,
//         translate: element.translationEn, notificationId: Random().nextInt(100),
//       );
//       localWords.add(local);
//     }
//   }
//   int position = 0;
//
//   ReminderDate reminderDate = ReminderDate.getValue(StorageRepository.getDouble(StoreKeys.reminderDate).toInt());
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();
//
//   /// OPTIONAL when use custom notification
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//
//   // bring to foreground
//   Timer.periodic(Duration(minutes: reminderDate.everyTime), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         /// OPTIONAL for use custom notification
//         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//         if (localWords.isNotEmpty) {
//           if (localWords.length > position) {
//             try {
//               flutterLocalNotificationsPlugin.show(
//                   localWords[position]!.notificationId ?? 0,
//                   '${localWords[position]!.word} => ${localWords[position]!.translate}',
//                   (localWords.length - 1 == position)
//                       ? 'This last word, Do you want repeat ?'
//                       : 'Need for your feature !',
//                   (localWords.length - 1 == position)
//                       ? const NotificationDetails(
//                           android: AndroidNotificationDetails('MEMORIZING_foreground', 'MEMORIZING FOREGROUND SERVICE',
//                               icon: 'app_icon',
//                               actions: [
//                               AndroidNotificationAction(
//                                 'accept',
//                                 'Accept',
//                               ),
//                               AndroidNotificationAction(
//                                 'decline',
//                                 'Decline',
//                               )
//                             ]))
//                       : const NotificationDetails(
//                           android: AndroidNotificationDetails(
//                             'MEMORIZING_foreground',
//                             'MEMORIZING FOREGROUND SERVICE',
//                             icon: 'app_icon',
//                           ),
//                         ));
//             } catch (e) {
//             }
//           }
//         }
//         if (position == localWords.length) {
//           position = 0;
//           return;
//         }
//         position++;
//       }
//     }
//
//     service.invoke(
//       'update',
//     );
//   });
// }

Future<void> onNotificationClick(String payload) async {
  if (payload == 'accept') {
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    // await flutterLocalNotificationsPlugin.initialize(
    //   const InitializationSettings(
    //     iOS: DarwinInitializationSettings(),
    //     android: AndroidInitializationSettings('app_icon'),
    //   ),
    // );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // await service.configure(
  //   androidConfiguration: AndroidConfiguration(
  //     // this will be executed when app is in foreground or background in separated isolate
  //     onStart: onStart,
  //     // auto start service
  //     autoStart: false,
  //     isForegroundMode: true,
  //   ),
  //   iosConfiguration: IosConfiguration(
  //     // auto start service
  //     autoStart: false,
  //
  //     // this will be executed when app is in foreground in separated isolate
  //     onForeground: onStart,
  //
  //     // you have to enable background fetch capability on xcode project
  //     onBackground: onIosBackground,
  //   ),
  // );
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('uz', 'UZ'), Locale('ru', 'RU')],
      path: 'assets/translations',
      startLocale: const Locale('en', 'US'),
      child: const MyApp()));
  FlutterNativeSplash.remove();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => LocalNotificationBloc()..add(GetNotifications())..add(GetLastNotificationIDEvent())),
        BlocProvider(
            create: (context) => MainBloc()
              ..add(InitialMainEvent())
              ..add(GetUserInfoEvent())
              ..add(GetAllMoviesEvent())),
        BlocProvider(create: (context) => AppThemeBloc()),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => RemainderBloc()..add(RemainderInitial())),

        BlocProvider(
            create: (context) => SettingsBloc()
              ..add(GetUserDataEvent())
              ..add(SettingsInitialEvent())),
        BlocProvider(create: (context) => WordsBloc()),
        BlocProvider(create: (context) => EducationBloc()),
        BlocProvider(create: (context) => SaveWordsBloc()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Flutter Demo',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: context.watch<AppThemeBloc>().state.switchValue
              ? ThemeData(
                  useMaterial3: true,
                  colorScheme: darkColorScheme,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                )
              : ThemeData(
                  useMaterial3: true,
                  colorScheme: lightColorScheme,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
          onGenerateRoute: AppRoutes.generateRoute,
        );
      }),
    );
  }
}
