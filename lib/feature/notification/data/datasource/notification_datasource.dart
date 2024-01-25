import 'package:brain_box/core/exceptions/exception.dart';
import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/singletons/dio_settings.dart';
import 'package:brain_box/core/singletons/service_locator.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/notification/data/models/notification_model.dart';
import 'package:dio/dio.dart';

abstract class NotificationDataSource {
  Future<GenericPagination<NotificationModel>> getNotifications(int page);
  Future<NotificationModel> getLastNotificationId();
}

class NotificationDataSourceImplementation extends NotificationDataSource {
  final dio = serviceLocator<DioSettings>().dio;

  @override
  Future<GenericPagination<NotificationModel>> getNotifications(int page) async {
    final token = StorageRepository.getString(StoreKeys.token);
    try {
      final response = await dio.get(
        '/api/v1/news/getNews',
        queryParameters: {'page': page, 'size': 5},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return GenericPagination.fromJson(
            response.data, (p0) => NotificationModel.fromJson(p0 as Map<String, dynamic>));
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }

//   http://137.184.14.168:8080/api/v1/news/getLastNews
  @override
  Future<NotificationModel> getLastNotificationId() async {
    final token = StorageRepository.getString(StoreKeys.token);
    try {
      final response = await dio.get(
        '/api/v1/news/getLastNews',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return NotificationModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    }
    on ServerException {
      rethrow;
    }
    on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }
}
