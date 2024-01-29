import 'package:brain_box/core/exceptions/exception.dart';
import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/words/data/data_sources/words_datasource.dart';
import 'package:brain_box/feature/words/data/models/movie_model.dart';
import 'package:brain_box/feature/words/data/models/words_response.dart';
import 'package:brain_box/feature/words/data/repositories/words_repository.dart';

class WordsRepositoryImplementation extends WordsRepository{

  final WordsDatasource datasource = WordsDatasourceImplementation();

  @override
  Future<Either<Failure, MovieModel>> getMovieInfo(int id) async{
    try{
      final result = await datasource.getMovieInfo(id);
      return Right(result);
    } on ServerException catch (e){
      return Left(ServerFailure(statusCode: e.statusCode,errorMessage: e.errorMessage));
    } on DioException {
      return Left(DioFailure());
    } on ParsingException catch (e){
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, GenericPagination<Content>>> getWordsByCount(int page,int movieId) async{
    try{
      final result = await datasource.getWordsByCount(page,movieId);
      return Right(result);
    } on ServerException catch (e){
      return Left(ServerFailure(statusCode: e.statusCode,errorMessage: e.errorMessage));
    } on DioException {
      return Left(DioFailure());
    } on ParsingException catch (e){
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

}