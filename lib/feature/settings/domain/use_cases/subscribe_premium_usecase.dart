import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/usecase/usecase.dart';
import 'package:brain_box/core/utils/either.dart';

import '../../data/repositories/settings_repository_implementation.dart';
import '../repositories/settings_repository.dart';

class SubscribePremiumUseCase extends UseCase<void,void> {

  final SettingsRepository repository = SettingsRepositoryImplementation();

  @override
  Future<Either<Failure, void>> call(void params) {
    return repository.subscribePremium();
  }



}