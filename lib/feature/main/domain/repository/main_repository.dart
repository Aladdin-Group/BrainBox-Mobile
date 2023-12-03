import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';

import '../../../../core/utils/generic_pagination.dart';
import '../../data/models/Movie.dart';

abstract class MainRepository{
  Future<Either<Failure,GenericPagination<Content>>> getMovies(int page);
}