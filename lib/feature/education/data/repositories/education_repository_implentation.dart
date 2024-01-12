import 'package:brain_box/core/utils/generic_pagination.dart';
import 'package:brain_box/feature/education/data/data_sources/education_datasource.dart';
import 'package:brain_box/feature/education/data/models/book_model.dart';
import 'package:brain_box/feature/education/data/models/edu_model.dart';
import 'package:brain_box/feature/education/data/models/essential_model.dart';
import 'package:brain_box/feature/education/data/models/params.dart';
import 'package:brain_box/feature/education/domain/repositories/education_repository.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/utils/either.dart';

class EducationRepositoryImplementation extends EducationRepository{

  EducationDatasource datasource = EducationDatasourceImplementation();

  @override
  Future<Either<Failure, GenericPagination<EduModel>>> getEduItems(int page) async{
    try {
      final result = await datasource.getEduItems(page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on DioException {
      return Left(DioFailure());
    }on ParsingException catch (e) {
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<EssentialModel>>> getWords(Two<Essential,int> two) async{
    try {
      final result = await datasource.getWords(two);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on DioException {
      return Left(DioFailure());
    }on ParsingException catch (e) {
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }



}