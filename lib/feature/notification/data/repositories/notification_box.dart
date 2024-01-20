import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationBox {
  static const String _boxName = 'notificationBox';

  // Initialize Hive box
  static Future<Box<NotificationModel>> openBox() async {
    return await Hive.openBox<NotificationModel>(_boxName);
  }

  // Create
  static Future<void> addNotification(NotificationModel notification) async {
    final box = await openBox();
    await box.add(notification);
  }

  // Read All
  static Future<List<NotificationModel>> getAllNotifications() async {
    final box = await openBox();
    return box.values.toList();
  }

  // Update
  static Future<void> updateNotification(int index, NotificationModel updatedNotification) async {
    final box = await openBox();
    await box.putAt(index, updatedNotification);
  }

  // Delete
  static Future<void> deleteNotification(int index) async {
    final box = await openBox();
    await box.deleteAt(index);
  }

  // Clear All Notifications
  static Future<void> clearAllNotifications() async {
    final box = await openBox();
    await box.clear();
  }
}
