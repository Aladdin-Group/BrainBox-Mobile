import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/settings/data/repositories/settings_repository_implementation.dart';

import '../../../../core/usecase/usecase.dart';
import '../../data/models/user.dart';
import '../repositories/settings_repository.dart';

class UserdataUseCase extends UseCase<void, User> {
  final SettingsRepository repository = SettingsRepositoryImplementation();

  @override
  Future<Either<Failure, User>> call(void params) async {
    return await repository.getUserData();
  }
}
