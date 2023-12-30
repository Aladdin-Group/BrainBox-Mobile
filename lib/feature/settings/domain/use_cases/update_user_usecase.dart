import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';
import 'package:brain_box/feature/settings/data/models/update_user.dart';

import '../../data/repositories/settings_repository_implementation.dart';
import '../repositories/settings_repository.dart';

class UpdateUserUseCase extends UseCase<void,UpdateUser>{

  final SettingsRepository repository = SettingsRepositoryImplementation();

  @override
  Future<Either<Failure, void>> call(UpdateUser params) {
    return repository.updateUser(params);
  }



}