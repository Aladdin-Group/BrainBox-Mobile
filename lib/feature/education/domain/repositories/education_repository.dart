import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/education/data/models/edu_model.dart';
import 'package:brain_box/feature/education/data/models/essential_model.dart';

import '../../../../core/utils/generic_pagination.dart';
import '../../data/models/book_model.dart';
import '../../data/models/params.dart';

abstract class EducationRepository{

  Future<Either<Failure,GenericPagination<EduModel>>> getEduItems(int page);
  Future<Either<Failure,List<EssentialModel>>> getWords(Two<Essential,int> two);

}