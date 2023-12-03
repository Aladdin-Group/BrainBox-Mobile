import 'package:brain_box/core/singeltons/storage/storage_repository.dart';
import 'package:get_it/get_it.dart';

import 'dio_settings.dart';

final serviceLocator = GetIt.I;

Future<void> setupLocator() async {
  await StorageRepository.getInstance();
  serviceLocator.registerLazySingleton(() => DioSettings());
}