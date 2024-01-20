class PushNotificationModel {
  final String? title;
  final String? body;
  // final String data;

  PushNotificationModel({
     this.title,
     this.body,
    // required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      // 'data': data,
    };
  }

  factory PushNotificationModel.fromJson(Map<String, dynamic> map) {
    return PushNotificationModel(
      title: map['title'] as String,
      body: map['body'] as String,
      // data: map['data'] as String,
    );
  }
}
