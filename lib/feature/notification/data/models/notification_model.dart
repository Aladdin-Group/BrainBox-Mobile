import 'package:hive_flutter/hive_flutter.dart';

part 'notification_model.g.dart';

class NotificationModel {
  int id;
  String title;

  String body;

  String imageUrl;

  DateTime time;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.time,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      body: map['dialog'] as String,
      imageUrl: map['imageUrl'] as String,
      time: DateTime.now(),
      id: map['id'] as int,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['dialog'],
      imageUrl: json['imageUrl'],
      time: DateTime.now(),
      id: json['id'],
    );
  }
}
