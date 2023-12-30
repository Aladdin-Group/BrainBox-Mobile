import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/main/domain/repository/main_repository.dart';

import '../../data/repositories/main_repository_implementation.dart';

class BuyMovieUseCase extends UseCase<dynamic,int>{

  MainRepository repository = MoviesRepositoryImplementation();

  @override
  Future<Either<Failure, dynamic>> call(int params) {
    return repository.buyMovie(params);
  }

}