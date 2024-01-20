import 'package:hive_flutter/hive_flutter.dart';
part 'notification_model.g.dart';
@HiveType(typeId: 5)
class NotificationModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  String body;
  @HiveField(2)
  String? imageUrl;
  @HiveField(3)
  DateTime time;

  NotificationModel({
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'time': time,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      body: map['body'] as String,
      imageUrl: map['imageUrl'] as String,
      time: DateTime.now(),
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      imageUrl: json['imageUrl'],
      time: DateTime.parse(json['time']),
    );
  }
}
