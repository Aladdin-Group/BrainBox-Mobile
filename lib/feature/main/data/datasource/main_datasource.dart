import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/main/data/models/request_movie_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/singletons/dio_settings.dart';
import '../../../../core/singletons/service_locator.dart';
import '../../../../core/singletons/storage/storage_repository.dart';
import '../../../../core/singletons/storage/store_keys.dart';
import '../models/search_model.dart';

abstract class MainDatasource {
  Future<GenericPagination<Content>> getAllMovies(RequestMovieModel requestMovieModel);

  Future<dynamic> buyMovie(int movieId);

  Future<List<SearchModel>> searchMovie(String keyWord);

  Future submitMovie(String movieName);
}

class MainDatasourceImplementation extends MainDatasource {
  final dio = serviceLocator<DioSettings>().dio;

  static CancelToken cancelToken = CancelToken();

  @override
  Future<GenericPagination<Content>> getAllMovies(RequestMovieModel requestMovieModel) async {
    final token = StorageRepository.getString(StoreKeys.token);
    try {
      final response = await dio.get(
        '/api/v1/movie/getAllMoviePage',
        queryParameters: requestMovieModel.toMap(),
        options: Options(headers: {'Authorization': 'Bearer $token', 'Cache-Control': 'max-age=3600'}),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return GenericPagination.fromJson(response.data, (p0) {
          return Content.fromJson(p0 as Map<String, dynamic>);
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
  Future buyMovie(int movieId) async {
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
  Future<List<SearchModel>> searchMovie(String keyWord) async {
    final token = StorageRepository.getString(StoreKeys.token);
    try {
      final queryParameters = {'keyWord': keyWord};
      final response = await dio.get(
        '/api/v1/movie/search-movie',
        queryParameters: queryParameters,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        cancelToken: cancelToken,
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
  Future submitMovie(String movieName) async {
    final token = StorageRepository.getString(StoreKeys.token);
    try {
      final response = await dio.post(
        '/api/v1/movie/addRequestMovie?request=$movieName',
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
}
