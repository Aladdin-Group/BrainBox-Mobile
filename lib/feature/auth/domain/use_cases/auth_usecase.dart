 import 'package:brain_box/feature/auth/data/models/auth_model.dart';
import 'package:brain_box/feature/auth/data/repositories/auth_repository_implementation.dart';
import 'package:brain_box/feature/auth/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/either.dart';
import '../../data/models/AuthParams.dart';

class AuthUseCase extends UseCase<AuthModel,AuthParams?>{

  final AuthRepository _repository = AuthRepositoryImplementation();

  @override
  Future<Either<Failure, AuthModel>> call(AuthParams? params) {
    return _repository.auth(params);
  }

}