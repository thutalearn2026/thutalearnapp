import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';

@module
abstract class DioProvider {
  @singleton
  Dio dio(IConfig config) {
    Dio dio = Dio();
    dio.options.headers = config.headers;
    dio.interceptors.addAll({
      // DioCacheInterceptor(options: cacheOptions),
      TokenInterceptor(dio),
      ErrorHandle(dio),
    });
    return dio;
  }
}