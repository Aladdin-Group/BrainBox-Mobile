import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:dio/dio.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/singletons/dio_settings.dart';
import '../../../../core/singletons/service_locator.dart';
import '../../../../core/singletons/storage/storage_repository.dart';
import '../../../../core/singletons/storage/store_keys.dart';
import '../models/search_model.dart';

abstract class MainDatasource {
  Future<GenericPagination<Content>> getAllMovies(Map<String,int> map);
  Future<dynamic> buyMovie(int movieId);
  Future<List<SearchModel>> searchMovie(String keyWord);
  Future submitMovie(String movieName);
}

class MainDatasourceImplementation extends MainDatasource{

  final dio = serviceLocator<DioSettings>().dio;

  @override
  Future<GenericPagination<Content>> getAllMovies(Map<String,int> map) async{
    final token = StorageRepository.getString(StoreKeys.token);
    try {
      var query = {
        "page": map[map.keys.elementAt(0)],
        "size": 5,
        "level": map.keys.first
      };
      final response = await dio.get(
        '/api/v1/movie/getAllMoviePage',
         queryParameters: query,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return GenericPagination.fromJson(response.data, (p0) {
          return  Content.fromJson(p0 as Map<String, dynamic>);
        });
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }

  @override
  Future buyMovie(int movieId) async{
    final token = StorageRepository.getString(StoreKeys.token);
    try {
      final response = await dio.post(
        '/api/v1/bought-movie/buy?movieId=$movieId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<SearchModel>> searchMovie(String keyWord) async{
    final token = StorageRepository.getString(StoreKeys.token);
    try {
      final response = await dio.get(
        '/api/v1/movie/search-movie?keyWord=$keyWord',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return SearchModel.fromList(response.data);
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }

  @override
  Future submitMovie(String movieName) async{
    final token = StorageRepository.getString(StoreKeys.token);
    try {
      final response = await dio.post(
        '/api/v1/movie/addRequestMovie?request=$movieName',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('object');
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }



}