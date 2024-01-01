import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/auth/data/models/dev_test_model.dart';
import 'package:brain_box/feature/auth/data/repositories/auth_repository_implementation.dart';
import 'package:brain_box/feature/auth/domain/repositories/auth_repository.dart';

class IsDevTestTestingModeUseCase extends UseCase<DevTestModel,void>{

  AuthRepository dataSource = AuthRepositoryImplementation();

  @override
  Future<Either<Failure, DevTestModel>> call(void params) {
    return dataSource.isDevTesting();
  }
}