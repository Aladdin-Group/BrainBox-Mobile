import 'package:brain_box/core/exceptions/failure.dart';

import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/main/data/datasource/main_datasource.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';

import '../../../../core/exceptions/exception.dart';
import '../../domain/repository/main_repository.dart';

class MoviesRepositoryImplementation extends MainRepository{

  final MainDatasource datasource = MainDatasourceImplementation();

  @override
  Future<Either<Failure, GenericPagination<Content>>> getMovies(Map<String,int> map) async{
    try {
      final result = await datasource.getAllMovies(map);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on DioException {
      return Left(DioFailure());
    }on ParsingException catch (e) {
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

}