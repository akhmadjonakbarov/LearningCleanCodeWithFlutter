import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'secure_storage_service.dart';

class DioService {
  DioService();

  Dio createDio() {
    final Dio dio = Dio(BaseOptions(baseUrl: ApiConstants.mainUrl));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final SecureStorageService storage = SecureStorageService();
          final token = await storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
