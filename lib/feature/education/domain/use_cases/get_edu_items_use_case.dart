import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/education/data/models/edu_model.dart';
import 'package:brain_box/feature/education/data/repositories/education_repository_implentation.dart';
import 'package:brain_box/feature/education/domain/repositories/education_repository.dart';

class GetEduItemsUseCase extends UseCase<GenericPagination<EduModel>,int>{

  EducationRepository repository = EducationRepositoryImplementation();

  @override
  Future<Either<Failure, GenericPagination<EduModel>>> call(int params) {
    return repository.getEduItems(params);
  }
}