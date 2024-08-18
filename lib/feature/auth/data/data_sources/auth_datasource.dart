import 'dart:convert';

import 'package:brain_box/core/assets/constants/app_constants.dart';
import 'package:brain_box/feature/auth/data/models/auth_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/singletons/dio_settings.dart';
import '../../../../core/singletons/service_locator.dart';
import '../models/AuthParams.dart';
import '../models/dev_test_model.dart';

abstract class AuthDataSource {
  Future<GoogleSignInAccount?> authWithGoogle();

  Future auth(AuthParams? authParams);

  Future<DevTestModel> isDevTesting();

  Future<bool> handleError(String? message);
}

class AuthDatasourceImplementation extends AuthDataSource {
  final dio = serviceLocator<DioSettings>().dio;

  @override
  Future auth(AuthParams? authParams) async {

    try {
      final response = await dio.post(
        '/api/v1/auth/regLog',
        data: {
          "name": authParams?.fullName,
          "surname": "some",
          "uniqueId": authParams?.uid,
          "email": authParams?.email,
          "imageUrl": authParams?.photoUrl
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

  @override
  Future<bool> handleError(String? message) async{
    try{
      const url = 'https://api.telegram.org/bot${AppConstants.BOT_TOKEN}/sendMessage';
      final response = await dio.post(
        url,
        data: jsonEncode({
          'chat_id': '-1002188884730',
          'text': message,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.statusMessage);
      }
    }catch(e){
      throw Exception(e);
    }


  }
}
