import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:brain_box/feature/notification/data/repositories/notification_repository_impl.dart';

class GetLastNotificationIdUseCase extends UseCase<NotificationModel, NoParams> {
  final NotificationRepositoryImpl repository = NotificationRepositoryImpl();
  @override
  Future<Either<Failure, NotificationModel>> call(NoParams params) {
    return repository.getLastNotificationId();
  }
}
