import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://generativelanguage.googleapis.com",
        headers: {
          // "Authorization":
          //     "Bearer ${dotenv.env['OPENAI_API_KEY']}",
          "Content-Type": "application/json",
        },
      ),
    );

    _initializeInterceptors();
  }

  Dio get dio => _dio;

  void _initializeInterceptors() {
    // 🔹 Logging (disable in production)
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );

    // 🔹 Main App Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach auth token if available
          final token = await _getToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle token expiration
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final retryResponse = await _retry(error.requestOptions);
              return handler.resolve(retryResponse);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// =========================
  /// 🔐 TOKEN HANDLING (EDIT)
  /// =========================

  Future<String?> _getToken() async {
    // TODO: Load from secure storage
    return null;
  }

  Future<bool> _refreshToken() async {
    // TODO: Call refresh token API
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// =========================
  /// 🌍 HTTP METHODS
  /// =========================

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParams,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// =========================
  /// ⬆️ FILE UPLOAD
  /// =========================

  Future<Response> uploadFile(
    String path,
    File file, {
    String fieldName = "file",
    Map<String, dynamic>? extraData,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path),
        ...?extraData,
      });

      return await _dio.post(path, data: formData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// =========================
  /// ⬇️ FILE DOWNLOAD
  /// =========================

  Future<void> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(url, savePath, onReceiveProgress: onReceiveProgress);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// =========================
  /// ❌ ERROR HANDLER
  /// =========================

  String _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return "Connection timeout. Please try again.";
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return "Server took too long to respond.";
    } else if (error.type == DioExceptionType.badResponse) {
      return error.response?.data["message"] ?? "Server error occurred.";
    } else if (error.type == DioExceptionType.cancel) {
      return "Request was cancelled.";
    } else if (error.type == DioExceptionType.unknown) {
      return "No internet connection.";
    } else {
      return "Something went wrong.";
    }
  }
}
