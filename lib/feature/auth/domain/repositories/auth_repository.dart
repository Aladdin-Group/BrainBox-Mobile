import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/auth/data/models/dev_test_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/AuthParams.dart';
import '../../data/models/auth_model.dart';

abstract class AuthRepository{

  Future<Either<Failure, AuthModel>> auth(AuthParams? authParams);
  Future<Either<Failure, bool>> handleError(String? message);
  Future<Either<Failure, DevTestModel>> isDevTesting();

}