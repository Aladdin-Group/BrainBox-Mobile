import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/words/data/models/words_response.dart';

import '../models/movie_model.dart';

abstract class WordsRepository{
  Future<Either<Failure,MovieModel>> getMovieInfo(int id);
  Future<Either<Failure,GenericPagination<Content>>> getWordsByCount(int page);
}