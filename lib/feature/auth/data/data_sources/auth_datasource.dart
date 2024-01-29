import 'package:brain_box/feature/auth/data/models/auth_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/singletons/dio_settings.dart';
import '../../../../core/singletons/service_locator.dart';
import '../models/dev_test_model.dart';

abstract class AuthDataSource {
  Future<GoogleSignInAccount?> authWithGoogle();

  Future auth(GoogleSignInAccount? googleUser);

  Future<DevTestModel> isDevTesting();
}

class AuthDatasourceImplementation extends AuthDataSource {
  final dio = serviceLocator<DioSettings>().dio;

  @override
  Future auth(GoogleSignInAccount? googleUser) async {

    try {
      final response = await dio.post(
        '/api/v1/auth/regLog',
        data: {
          "name": googleUser?.displayName,
          "surname": "some",
          "uniqueId": googleUser?.id,
          "email": googleUser?.email,
          "imageUrl": googleUser?.photoUrl
        },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return AuthModel.fromJson(response.data);
      }
      throw ServerException(
          statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }

  @override
  Future<GoogleSignInAccount?> authWithGoogle() async {
    return await GoogleSignIn().signIn();
  }

  @override
  Future<DevTestModel> isDevTesting() async {

    try {
      final response = await dio.post(
        '/api/v1/auth/isDebug',
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        try {
          return DevTestModel.fromJson(response.data);
        } catch (e) {
          throw ParsingException(errorMessage: e.toString());
        }
      }
      throw ServerException(
          statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }
}
