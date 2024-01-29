import 'package:brain_box/core/exceptions/failure.dart';

import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/main/data/datasource/main_datasource.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/main/data/models/request_movie_model.dart';

import '../../../../core/exceptions/exception.dart';
import '../../domain/repository/main_repository.dart';
import '../models/search_model.dart';

class MoviesRepositoryImplementation extends MainRepository{

  final MainDatasource datasource = MainDatasourceImplementation();

  @override
  Future<Either<Failure, GenericPagination<Content>>> getMovies(RequestMovieModel requestMovieModel) async{
    try {
      final result = await datasource.getAllMovies( requestMovieModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on DioException {
      return Left(DioFailure());
    }on ParsingException catch (e) {
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, dynamic>> buyMovie(int movieId) async{
    try{
      final result = await datasource.buyMovie(movieId);
      return Right(result);
    } on ServerException catch (e){
      return Left(ServerFailure(statusCode: e.statusCode,errorMessage: e.errorMessage));
    } on DioException catch (e) {
      return Left(DioFailure());
    } on ParsingException catch (e){
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<SearchModel>>> searchMovie(String keyWord) async{
    try{
      final result = await datasource.searchMovie(keyWord);
      return Right(result);
    } on ServerException catch (e){
      return Left(ServerFailure(statusCode: e.statusCode,errorMessage: e.errorMessage));
    } on DioException catch (e) {
      return Left(DioFailure());
    } on ParsingException catch (e){
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, dynamic>> submitMovie(String movieName) async{
    try{
      final result = await datasource.submitMovie(movieName);
      return Right(result);
    } on ServerException catch (e){
      return Left(ServerFailure(statusCode: e.statusCode,errorMessage: e.errorMessage));
    } on DioException catch (e) {
      return Left(DioFailure());
    } on ParsingException catch (e){
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

}