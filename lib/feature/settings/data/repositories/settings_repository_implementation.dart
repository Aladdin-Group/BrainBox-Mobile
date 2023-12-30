import 'package:brain_box/core/exceptions/failure.dart';

import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/settings/data/data_sources/settings_datsource.dart';
import 'package:brain_box/feature/settings/data/models/update_user.dart';

import 'package:brain_box/feature/settings/data/models/user.dart';

import '../../../../core/exceptions/exception.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImplementation extends SettingsRepository{

  SettingsDatasource datasource = SettingsDatasourceImplementation();

  @override
  Future<Either<Failure, User>> getUserData() async{
    try {
      final result = await datasource.getUserData();
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
  Future<Either<Failure, void>> updateUser(UpdateUser params) async{
    try {
      final result = await datasource.updateCoin(params);
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
  Future<Either<Failure, void>> subscribePremium() async{
    try {
      final result = await datasource.subscribePremium();
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