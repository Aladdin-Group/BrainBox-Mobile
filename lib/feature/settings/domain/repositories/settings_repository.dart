import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/settings/data/models/user.dart';

import '../../data/models/update_user.dart';

abstract class SettingsRepository {

  Future<Either<Failure,User>> getUserData();
  Future<Either<Failure,void>> updateUser(UpdateUser params);
  Future<Either<Failure,void>> subscribePremium();

}