import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/assets/constants/app_images.dart';
import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    // write to appbar notification and body has column with padding children are image, title and body
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.notifications.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              notification.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(AppImages.notFound,width: double.infinity,height: 200,fit: BoxFit.cover,);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(notification.title,style: context.titleLarge),
            ),
            // add here date time format using intl

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(notification.body,style: context.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
