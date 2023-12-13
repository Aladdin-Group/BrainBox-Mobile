import 'package:dio/dio.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/singletons/dio_settings.dart';
import '../../../../core/singletons/service_locator.dart';
import '../../../../core/singletons/storage/storage_repository.dart';
import '../../../../core/singletons/storage/store_keys.dart';
import '../models/user.dart';

abstract class SettingsDatasource {

  Future<User> getUserData();

}

class SettingsDatasourceImplementation extends SettingsDatasource{

  final dio = serviceLocator<DioSettings>().dio;

  @override
  Future<User> getUserData() async{
    final token = StorageRepository.getString(StoreKeys.token);
    try {

      final response = await dio.get(
        '/api/v1/user/getUserById',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return User.fromJson(response.data);
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }

}