import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:brain_box/feature/notification/data/models/push_notification_model.dart';
import 'package:brain_box/feature/notification/data/repositories/notification_box.dart';
import 'package:brain_box/feature/notification/presentation/manager/local_notification_bloc.dart';
import 'package:brain_box/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
final FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> showLocalNotification(PushNotificationModel notification) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'your_channel_id',
    'Your Channel Name',
    importance: Importance.max,
    priority: Priority.high,
  );

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
      0,
      notification.title ?? "FCM Test",
      notification.body ?? "FCM Test body",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'MEMORIZING_foreground',
          'MEMORIZING FOREGROUND SERVICE',
          icon: 'app_icon',
        ),
      ));
}

Future<void> registerForFCMNotifications() async {
  NotificationSettings settings = await messaging.requestPermission();
  String? fcmToken = await messaging.getToken();
  // token: cU6wYJF9Tfu4lzXvbsvR-m:APA91bGTeoZNg8dn4RK1b5vTZOLF9OhVCNWwwMNjHOfu6fq38e8ETetjcesaqHBc4Zxng2k4ef1S2RFqjZNJmfw3WMr7Zg9vakIRwMvbnyB3HreuwKu2KG4n_6FHjRyRVjCBaaNf_d7N
  print("token:$fcmToken");

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');

      PushNotificationModel notification =
          PushNotificationModel(title: message.notification?.title, body: message.notification?.body);
      await showLocalNotification(notification);
      await NotificationBox.addNotification(NotificationModel.fromMap(message.data));
      navigatorKey.currentContext?.read<LocalNotificationBloc>().add(FetchNotifications());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
      print('Got a message whilst in the on terminated state!');
      await NotificationBox.addNotification(NotificationModel.fromMap(message.data));
      navigatorKey.currentContext?.read<LocalNotificationBloc>().add(FetchNotifications());
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } else {
    print('User declined or has not granted permission');
  }
}

Future<void> _onMessageOpenedApp(RemoteMessage message) async {
  print("Got a message whilst in the on background state.");
  showLocalNotification(PushNotificationModel(title: "${message.notification?.title} on background", body: message.notification?.body));
  await NotificationBox.addNotification(NotificationModel.fromMap(message.data));
  navigatorKey.currentContext?.read<LocalNotificationBloc>().add(FetchNotifications());
}
