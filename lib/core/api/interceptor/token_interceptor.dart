import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    thutaLog(
      'Requested URL is ======> ${options.uri} '
          'and data is ===> ${options.data}',
    );

    options.headers['Accept'] = Headers.jsonContentType;
    options.contentType = Headers.jsonContentType;

    options.connectTimeout = const Duration(seconds: 20);
    options.receiveTimeout = const Duration(seconds: 20);
    options.sendTimeout = const Duration(seconds: 20);

    final path = options.path;

    final isPublicEndpoint =
        path.contains('register/initiate') ||
            path.contains('register/verify') ||
            path.contains('register/complete') ||
            path.endsWith('/login') ||
            path.contains('forgot-password') ||
            path.contains('reset-password') ||
            path.contains('onboarding-options');

    final token = AuthSessionBox.token;

    if (!isPublicEndpoint && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('Authenticated request: $path');
    } else {
      debugPrint('Public request: $path');
    }

    handler.next(options);
  }
}