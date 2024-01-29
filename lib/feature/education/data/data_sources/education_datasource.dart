import 'package:brain_box/feature/education/data/models/book_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/singletons/dio_settings.dart';
import '../../../../core/singletons/service_locator.dart';
import '../../../../core/singletons/storage/storage_repository.dart';
import '../../../../core/singletons/storage/store_keys.dart';
import '../../../../core/utils/generic_pagination.dart';
import '../models/edu_model.dart';
import '../models/essential_model.dart';
import '../models/params.dart';

abstract class EducationDatasource {
  Future<GenericPagination<EduModel>> getEduItems(int page);

  Future<List<EssentialModel>> getWords(Two<Essential, int> two);
}

class EducationDatasourceImplementation extends EducationDatasource {
  final dio = serviceLocator<DioSettings>().dio;

  @override
  Future<GenericPagination<EduModel>> getEduItems(int page) async {
    final token = StorageRepository.getString(StoreKeys.token);
    try {
      final response = await dio.get(
        '/api/v1/video/getVideoPage?page=$page&size=5',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return GenericPagination.fromJson(response.data, (p0) {
          return EduModel.fromJson(p0 as Map<String, dynamic>);
        });
      } else if (response.statusCode == 401) {
        throw UserTokenExpire();
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<EssentialModel>> getWords(Two<Essential, int> two) async {
    final token = StorageRepository.getString(StoreKeys.token);

    var book = 1;

    if (two.t == Essential.essential_1) {
      book = 1;
    } else if (two.t == Essential.essential_2) {
      book = 2;
    } else if (two.t == Essential.essential_3) {
      book = 3;
    } else if (two.t == Essential.essential_4) {
      book = 4;
    } else if (two.t == Essential.essential_5) {
      book = 5;
    } else {
      book = 6;
    }

    try {
      final response = await dio.get(
        '/essential/$book/${two.b}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // Ensure response.data is a List<Map<String, dynamic>>
        List<Map<String, dynamic>> jsonDataList = List<Map<String, dynamic>>.from(response.data);

        // Convert JSON list to a list of EssentialModel objects
        List<EssentialModel> essentialModels = EssentialModel.fromList(jsonDataList);

        // Print the resulting list of EssentialModel objects

        return essentialModels;
      } else if (response.statusCode == 401) {
        throw UserTokenExpire();
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }
}
