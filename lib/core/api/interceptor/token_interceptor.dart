import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    thutaLog(
        "Requested URL is ======> ${options.path} and ${options.queryParameters} and path is ===> ${options.path} and data is ===> ${options.data}");

    options.headers["Accept"] = Headers.jsonContentType;
    options.contentType = Headers.jsonContentType;

    options.connectTimeout = const Duration(seconds: 20);
    options.receiveTimeout = const Duration(seconds: 20);
    options.sendTimeout = const Duration(seconds: 20);
    String path = options.uri.toString();
    if (path.endsWith("login") ||
        path.endsWith('register') ||
        path.contains("without_auth") ||
        path.contains("password/reset/user")) {
      debugPrint("un auth-========-> $path");
    } else {
      debugPrint("auth-========-> $path");

      // UserBox userBox = await UserBox.instance;
      // UserModel userModel = userBox.getUser() ?? UserModel();
      // if (userModel.token != null ||
      //     (userModel.token ?? "").isNotEmpty) {
      //   options.headers['Authorization'] =
      //   'Bearer ${userModel.token}';
      // }
    }
    return handler.next(options);
  }
}