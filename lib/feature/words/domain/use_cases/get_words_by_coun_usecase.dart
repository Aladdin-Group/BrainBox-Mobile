import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/words/data/models/words_response.dart';
import 'package:brain_box/feature/words/data/repositories/words_repository.dart';
import 'package:brain_box/feature/words/domain/repositories/words_repository_implementation.dart';

class GetWordsByCountUseCase extends UseCase<GenericPagination<Content>,List<int>> {

  WordsRepository repository = WordsRepositoryImplementation();

  @override
  Future<Either<Failure, GenericPagination<Content>>> call(List m) {
    return repository.getWordsByCount(m[0],m[1]);
  }



}