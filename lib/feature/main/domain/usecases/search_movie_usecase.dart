import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/main/domain/repository/main_repository.dart';

import '../../data/models/search_model.dart';
import '../../data/repositories/main_repository_implementation.dart';

class SearchMovieUseCase extends UseCase<List<SearchModel>,String>{

  MainRepository repository = MoviesRepositoryImplementation();

  @override
  Future<Either<Failure, List<SearchModel>>> call(String params) {
    return repository.searchMovie(params);
  }

}