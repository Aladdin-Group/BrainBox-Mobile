import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:dio/dio.dart';

import '../data/intersepter/custom_interceptor.dart';

typedef ConverterFunctionType<T> = T Function(dynamic response);

class DioSettings {
  BaseOptions _dioBaseOptions = BaseOptions(
    baseUrl: 'http://10.0.2.2:8080/',
    connectTimeout: const Duration(milliseconds: 35000),
    receiveTimeout: const Duration(milliseconds: 35000),
    followRedirects: false,
    headers: <String, dynamic>{'Accept-Language': StorageRepository.getString(StoreKeys.language, defValue: 'uz')},
    validateStatus: (status) => status != null && status <= 500,
  );

  void setBaseOptions({String? lang, String? baseUrl}) {
    if (baseUrl != null && Uri.parse(baseUrl).isAbsolute) {
      _dioBaseOptions = BaseOptions(
        baseUrl: baseUrl ?? 'http://10.0.2.2:8080/',
        connectTimeout: const Duration(milliseconds: 35000),
        receiveTimeout: const Duration(milliseconds: 35000),
        headers: <String, dynamic>{'Accept-Language': lang},
        followRedirects: false,
        validateStatus: (status) => status != null && status <= 500,
      );
    }else{
      // Handle the case where baseUrl is not a valid URL.
      // You can throw an exception, provide a default URL, or take appropriate action.
      print('Invalid baseUrl: $baseUrl');
      _dioBaseOptions = BaseOptions(
        baseUrl: 'http://10.0.2.2:8080/',
        connectTimeout: const Duration(milliseconds: 35000),
        receiveTimeout: const Duration(milliseconds: 35000),
        headers: <String, dynamic>{'Accept-Language': lang},
        followRedirects: false,
        validateStatus: (status) => status != null && status <= 500,
      );
    }
  }

  BaseOptions get dioBaseOptions => _dioBaseOptions;

  Dio get dio {
    final dio = Dio(_dioBaseOptions);
    dio.interceptors
      ..add(CustomInterceptor(dio: dio))
      ..add(
        LogInterceptor(
          responseBody: true,
          requestBody: true,
        ),
      );
    return dio;
  }
}