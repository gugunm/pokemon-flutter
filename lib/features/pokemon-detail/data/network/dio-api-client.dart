import 'package:dio/dio.dart';
import 'package:poke_project/core/remote-state.dart';

class DioApiClient {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  // ini singleton pattern, jadi object hanya dibuat sekali
  static final DioApiClient _instance = DioApiClient._internal();

  factory DioApiClient() {
    return _instance;
  }

  DioApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer YOUR_API_KEY_HERE',
        },
        preserveHeaderCase: false,
        responseType: ResponseType.json,
        contentType: 'application/json',
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
        receiveDataWhenStatusError: true,
      ),
    );

    // You can add interceptors if needed
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Do something before request is sent
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Do something with response data
          return handler.next(response);
        },
        onError: (error, handler) {
          // Do something with response error
          _dioErrorHandler(error);
          return handler.next(error);
        },
      ),
    );
  }

  _dioErrorHandler(DioException err) {
    return RemoteStateError(err.message ?? 'Unknown Dio Error');
  }

  late final Dio _dio;
  Dio get dio => _dio;
}
