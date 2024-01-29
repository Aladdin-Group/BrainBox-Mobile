import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:brain_box/feature/notification/data/models/push_notification_model.dart';
import 'package:brain_box/feature/notification/data/repositories/notification_box.dart';
import 'package:brain_box/feature/notification/presentation/manager/local_notification_bloc.dart';
import 'package:brain_box/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
final FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> showLocalNotification(PushNotificationModel notification) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();



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

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      PushNotificationModel notification =
          PushNotificationModel(title: message.notification?.title, body: message.notification?.body);
      await showLocalNotification(notification);
      await NotificationBox.addNotification(NotificationModel.fromMap(message.data));
      navigatorKey.currentContext?.read<LocalNotificationBloc>().add(FetchNotifications());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
      await NotificationBox.addNotification(NotificationModel.fromMap(message.data));
      navigatorKey.currentContext?.read<LocalNotificationBloc>().add(FetchNotifications());
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } else {
  }
}

