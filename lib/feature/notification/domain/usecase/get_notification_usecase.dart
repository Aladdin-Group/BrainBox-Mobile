import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:brain_box/feature/notification/data/repositories/notification_repository_impl.dart';

class GetNotificationsUseCase extends UseCase<GenericPagination<NotificationModel>, int> {
  final NotificationRepositoryImpl repository = NotificationRepositoryImpl();
  @override
  Future<Either<Failure, GenericPagination<NotificationModel>>> call(int params) {
    return repository.getNotifications(params);
  }


}
