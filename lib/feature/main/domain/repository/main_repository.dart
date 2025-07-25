import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/main/data/models/request_movie_model.dart';

import '../../../../core/utils/generic_pagination.dart';
import '../../data/models/Movie.dart';
import '../../data/models/search_model.dart';

abstract class MainRepository{
  Future<Either<Failure,GenericPagination<Content>>> getMovies(RequestMovieModel requestMovieModel);
  Future<Either<Failure,dynamic>> buyMovie(int movieId);
  Future<Either<Failure,dynamic>> submitMovie(String movieName);
  Future<Either<Failure,List<SearchModel>>> searchMovie(String keyWord);
}