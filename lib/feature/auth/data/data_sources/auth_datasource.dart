import 'package:brain_box/core/singeltons/dio_settings.dart';
import 'package:brain_box/core/singeltons/service_locator.dart';
import 'package:brain_box/feature/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/singeltons/storage/storage_repository.dart';
import '../../../../core/singeltons/storage/store_keys.dart';

abstract class AuthDataSource {

  Future<GoogleSignInAccount?> authWithGoogle();
  Future auth(GoogleSignInAccount? googleUser);

}

class AuthDatasourceImplementation extends AuthDataSource{

  final dio = serviceLocator<DioSettings>().dio;

  @override
  Future auth(GoogleSignInAccount? googleUser) async{
    final token = StorageRepository.getString(StoreKeys.token);

    try {
      final response = await dio.post(
        '/api/v1/auth/regLog',
        data: {
          "name": "Azizbek",
          "surname": "Xoliqov",
          "uniqueId": "string",
          "email": "xoliqovazizbek23@gmail.com",
          "imageUrl": "https://i.pinimg.com/564x/59/19/69/591969d90243c1a2d04ff01c8ac0ac0a.jpg"
        },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return AuthModel.fromJson(response.data);
      }
      throw ServerException(statusCode: response.statusCode ?? 0, errorMessage: response.statusMessage ?? '');
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }

  @override
  Future<GoogleSignInAccount?> authWithGoogle() async{
     return await GoogleSignIn().signIn();
  }

}