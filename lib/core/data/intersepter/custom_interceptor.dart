import 'package:dio/dio.dart';

import '../../assets/constants/app_constants.dart';
import '../../singletons/storage/storage_repository.dart';
import '../../singletons/storage/store_keys.dart';

class CustomInterceptor implements Interceptor {
  final Dio dio;

  const CustomInterceptor({required this.dio});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.badResponse && (err.response?.statusCode == 403 || err.response?.statusCode == 401)) {
      StorageRepository.deleteString(StoreKeys.token);
      await _refreshToken(err.requestOptions.baseUrl);
      if (StorageRepository.getString(StoreKeys.token).replaceAll('Bearer', '').trim().isNotEmpty) {
        err.requestOptions.headers['Authorization'] = StorageRepository.getString(StoreKeys.token);
      }

      final response = await _resolveResponse(err.requestOptions);
      handler.resolve(response);
      return;
    }
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 403 || response.statusCode == 401) {
      if (StorageRepository.getString(StoreKeys.refresh).isEmpty) {
        handler.next(response);
        return;
      }
      await _refreshToken(response.requestOptions.baseUrl);
      if (StorageRepository.getString(StoreKeys.token).replaceAll('Bearer', '').trim().isNotEmpty) {
        response.requestOptions.headers['Authorization'] = StorageRepository.getString(StoreKeys.token);
      }
      final resolved = await _resolveResponse(response.requestOptions);
      handler.resolve(resolved);
      return;
    }
    handler.next(response);
  }

  Future<void> _refreshToken(String baseUrl) async {
    if (StorageRepository.getString(StoreKeys.refresh).isNotEmpty) {
      final response = await dio
          .post('$baseUrl/users/TokenRefresh', data: {'refresh': StorageRepository.getString(StoreKeys.refresh)});
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        StorageRepository.putString(StoreKeys.token, 'Bearer ${response.data['access']}');
      } else {
        StorageRepository.deleteString(StoreKeys.refresh);
      }
    }
  }

  Future<Response<dynamic>> _resolveResponse(RequestOptions options) async {
    final path = options.path.replaceAll(AppConstants.BASE_URL_PROD, '');
    if (options.data is FormData) {
      FormData formData = FormData();
      final fields = options.data.fields as List<MapEntry<String, String>>;
      formData.fields.addAll(fields);

      for (MapEntry mapFile in options.data.files) {
        formData.files.add(MapEntry(
            mapFile.key,
            MultipartFile.fromFileSync(
                fields.firstWhere((element) => element.key == 'photo_path', orElse: () => const MapEntry('', '')).value,
                filename: mapFile.value.filename)));
      }
      options.data = formData;
    }
    return await dio.request(AppConstants.BASE_URL_PROD + path,
        data: options.data,
        queryParameters: options.queryParameters,
        options: Options(
          headers: options.headers,
          method: options.method,
        ));
  }
}