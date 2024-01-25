import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/assets/constants/app_images.dart';
import 'package:brain_box/core/route/ruotes.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/feature/notification/presentation/manager/local_notification_bloc.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.notifications.tr())),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.read<LocalNotificationBloc>().add(GetNotifications());
      //   },
      // ),
      body: RefreshIndicator(
        onRefresh: () async => context.read<LocalNotificationBloc>().add(GetNotifications()),
        child: BlocBuilder<LocalNotificationBloc, LocalNotificationState>(
          builder: (context, state) {
            print('local notifications');
            print(state.status);
            if (state.status.isInProgress) {
              return SingleChildScrollView(
                  child: SizedBox(height: context.height, child: const Center(child: CircularProgressIndicator())));
            }
            if (state.status.isFailure) {
              return Center(
                  child: Text(state.message,
                      style: context.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)));
            }
            if (state.notifications.isEmpty) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: context.height,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.noFound, width: 200),
                        Text(LocaleKeys.notificationsNotYet.tr()),
                      ],
                    ),
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              // reverse: true,
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                StorageRepository.putBool(key: 'notification${notification.id}', value: true);
                return GestureDetector(
                  onTap: () => context.pushNamed(RouteNames.notificationDetail, arguments: notification),
                  child: Card(
                    elevation: 4,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (notification.imageUrl != null) Image.network(notification.imageUrl!),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            notification.title,
                            style: context.titleLarge,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            notification.body,
                            style: context.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          },
        ),
      ),
    );
  }
}
