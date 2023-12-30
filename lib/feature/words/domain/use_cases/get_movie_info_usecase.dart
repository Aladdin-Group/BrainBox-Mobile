import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/words/data/repositories/words_repository.dart';
import 'package:brain_box/feature/words/domain/repositories/words_repository_implementation.dart';

import '../../data/models/movie_model.dart';

class GetMovieInfoUseCase extends UseCase<MovieModel,int> {

  final WordsRepository repository = WordsRepositoryImplementation();

  @override
  Future<Either<Failure, MovieModel>> call(int params) {
    return repository.getMovieInfo(params);
  }

}