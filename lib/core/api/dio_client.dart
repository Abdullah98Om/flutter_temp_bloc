import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_services.dart';
import '../error/exceptions.dart';
import '../storage/storage_keys.dart';
import 'end_points.dart';
import 'status_code.dart';

class ApiClient {
  static const int _timeout = 60000; // 60 seconds

  late final Dio _dio;
  final SecureStorageServices _secureStorage;
  final String refreshTokenUrl = EndPoints.refreshToken;

  bool _isRefreshing = false;
  final Queue<RequestOptions> _retryQueue = Queue<RequestOptions>();

  ApiClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: const Duration(milliseconds: _timeout),
        receiveTimeout: const Duration(milliseconds: _timeout),
        sendTimeout: const Duration(milliseconds: _timeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // إضافة Access Token فقط إذا requiresAuth != false
          final requiresAuth = options.extra['requiresAuth'] ?? true;

          if (requiresAuth) {
            final token = await _secureStorage.getValue(
              AppStorageKey.accessToken,
            );
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          if (kDebugMode) {
            debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
            debugPrint('Headers: ${options.headers}');
            debugPrint('Data: ${options.data}');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
            debugPrint('Data: ${response.data}');
          }
          handler.next(response);
        },
        onError: (err, handler) async {
          if (err.response?.statusCode == 401) {
            final refreshToken = await _secureStorage.getValue(
              AppStorageKey.refreshToken,
            );

            if (refreshToken != null) {
              _retryQueue.add(err.requestOptions);

              if (!_isRefreshing) {
                _isRefreshing = true;
                try {
                  final refreshResponse = await _dio.post(
                    refreshTokenUrl,
                    data: {AppStorageKey.refreshToken: refreshToken},
                    options: Options(
                      extra: {'requiresAuth': false},
                    ), // لا حاجة لتوكن هنا
                  );

                  final newAccess =
                      refreshResponse.data[AppStorageKey.accessToken];
                  final newRefresh =
                      refreshResponse.data[AppStorageKey.refreshToken];

                  await _secureStorage.setValue(
                    AppStorageKey.accessToken,
                    newAccess,
                  );
                  await _secureStorage.setValue(
                    AppStorageKey.refreshToken,
                    newRefresh,
                  );

                  while (_retryQueue.isNotEmpty) {
                    final options = _retryQueue.removeFirst();
                    options.headers['Authorization'] = 'Bearer $newAccess';
                    await _dio.request(
                      options.path,
                      data: options.data,
                      queryParameters: options.queryParameters,
                      options: Options(
                        method: options.method,
                        headers: options.headers,
                        extra: options.extra,
                      ),
                    );
                  }
                  _isRefreshing = false;
                  return handler.resolve(
                    await _dio.request(
                      err.requestOptions.path,
                      data: err.requestOptions.data,
                      queryParameters: err.requestOptions.queryParameters,
                      options: Options(
                        method: err.requestOptions.method,
                        headers: err.requestOptions.headers,
                        extra: err.requestOptions.extra,
                      ),
                    ),
                  );
                } catch (e) {
                  _isRefreshing = false;
                  await _secureStorage.clearAll();
                  return handler.reject(err);
                }
              } else {
                return;
              }
            }
          }

          handler.next(err);
        },
      ),
    );
  }

  // GET request
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //  POST request (has)
  Future<Map<String, dynamic>> postFile(
    String path,
    FormData formData, {
    bool requiresAuth = true, // Auth مطلوب عادة
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          extra: {'requiresAuth': requiresAuth},
        ),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // تحويل أخطاء Dio إلى Exceptions
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
      case DioExceptionType.cancel:
        return RequestCancelledException();
      case DioExceptionType.connectionError:
        return NoInternetException();
      default:
        return UnknownException();
    }
  }

  Exception _handleResponseError(Response? response) {
    if (response == null) return UnknownException();

    switch (response.statusCode) {
      case StatusCode.badRequest:
        return BadRequestException(response.data['message']);
      case StatusCode.unauthorized:
        return UnauthorizedException();
      case StatusCode.forbidden:
        return ForbiddenException();
      case StatusCode.notFound:
        return NotFoundException();
      case StatusCode.conflict:
        return ConflictException();
      case StatusCode.serverError:
        return ServerException();
      case StatusCode.validationError:
        return ValidationException(
          response.data['errors'],
        ); // إذا كانت errors Map

      default:
        return UnknownException();
    }
  }
}
