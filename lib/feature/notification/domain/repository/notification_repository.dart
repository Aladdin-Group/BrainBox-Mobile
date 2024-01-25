import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/notification/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Failure, GenericPagination<NotificationModel>>> getNotifications(int page);

  Future<Either<Failure, NotificationModel>> getLastNotificationId();
}
