import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/settings/data/models/user.dart';

abstract class SettingsRepository {

  Future<Either<Failure,User>> getUserData();

}