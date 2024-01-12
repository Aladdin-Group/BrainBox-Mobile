import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/education/data/models/book_model.dart';
import 'package:brain_box/feature/education/data/models/essential_model.dart';
import 'package:brain_box/feature/education/data/models/params.dart';
import 'package:brain_box/feature/education/data/repositories/education_repository_implentation.dart';
import 'package:brain_box/feature/education/domain/repositories/education_repository.dart';

class GetEssentialWordsUseCase extends UseCase<List<EssentialModel>,Two<Essential,int>>{

  EducationRepository repository = EducationRepositoryImplementation();

  @override
  Future<Either<Failure, List<EssentialModel>>> call(Two<Essential, int> params) {
    return repository.getWords(params);
  }

}