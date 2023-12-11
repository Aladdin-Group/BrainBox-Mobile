import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/main/domain/repository/main_repository.dart';

import '../../data/repositories/main_repository_implementation.dart';

class GetMoviesUseCase extends UseCase<GenericPagination<Content>,Map<String,int>>{

  final MainRepository repository = MoviesRepositoryImplementation();

  @override
  Future<Either<Failure, GenericPagination<Content>>> call(Map<String,int> params) {
    return repository.getMovies(params);
  }

}