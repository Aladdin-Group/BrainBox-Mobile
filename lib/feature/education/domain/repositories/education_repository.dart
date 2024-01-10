import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/education/data/models/edu_model.dart';

import '../../../../core/utils/generic_pagination.dart';

abstract class EducationRepository{

  Future<Either<Failure,GenericPagination<EduModel>>> getEduItems(int page);

}