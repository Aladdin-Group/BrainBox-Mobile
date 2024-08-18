import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/feature/auth/data/data_sources/auth_datasource.dart';
import 'package:brain_box/feature/auth/data/models/auth_model.dart';
import 'package:brain_box/feature/auth/data/models/dev_test_model.dart';
import 'package:brain_box/feature/auth/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/utils/either.dart';
import '../models/AuthParams.dart';

class AuthRepositoryImplementation extends AuthRepository {
  final AuthDataSource datasource = AuthDatasourceImplementation();

  @override
  Future<Either<Failure, AuthModel>> auth(AuthParams? authParams) async {
    try {
      final result = await datasource.auth(authParams);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on DioException {
      return Left(DioFailure());
    } on ParsingException catch (e) {
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, DevTestModel>> isDevTesting() async {
    try {
      final result = await datasource.isDevTesting();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on DioException {
      return Left(DioFailure());
    } on ParsingException catch (e) {
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> handleError(String? message) async{
    try {
      final result = await datasource.handleError(message);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on DioException {
      return Left(DioFailure());
    } on ParsingException catch (e) {
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    }
  }
}
