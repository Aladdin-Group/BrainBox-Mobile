import 'package:brain_box/core/singletons/dio_settings.dart';
import 'package:brain_box/core/singletons/service_locator.dart';
import 'package:dio/dio.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/singletons/storage/storage_repository.dart';
import '../../../../core/singletons/storage/store_keys.dart';
import '../../../../core/utils/generic_pagination.dart';
import '../models/movie_model.dart';
import '../models/words_response.dart';

abstract class WordsDatasource{
  Future<MovieModel> getMovieInfo(int id);
  Future<GenericPagination<Content>> getWordsByCount(int page,int movieId);
}

class WordsDatasourceImplementation extends WordsDatasource{

  var dio = serviceLocator<DioSettings>().dio;

  @override
  Future<MovieModel> getMovieInfo(int id) async{

    final token = StorageRepository.getString(StoreKeys.token);

    try {
      final response = await dio.get(
        '/api/v1/movie/getMovie/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return MovieModel.fromJson(response.data);
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }

  }

  @override
  Future<GenericPagination<Content>> getWordsByCount(int page,int movieId) async{
    final token = StorageRepository.getString(StoreKeys.token);

    try {
      final response = await dio.get(
        '/api/v1/subtitleWords/getWordsByCount?language=1&movieId=$movieId&page=$page&size=20',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return GenericPagination.fromJson(response.data, (p0) => Content.fromJson(p0 as Map<String,dynamic>));
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }



}