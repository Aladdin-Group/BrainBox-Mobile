import 'package:brain_box/core/exceptions/exception.dart';
import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/notification/data/datasource/notification_datasource.dart';
import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:brain_box/feature/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource dataSource = NotificationDataSourceImplementation();

  @override
  Future<Either<Failure, GenericPagination<NotificationModel>>> getNotifications(int page) async {
    try {
      final result = await dataSource.getNotifications(page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, NotificationModel>> getLastNotificationId() async{
    try{
      final result = await dataSource.getLastNotificationId();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }


}
