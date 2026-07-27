import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';

import '../../../splash.dart';

@Injectable(as: SplashClient)
class ISplashClient extends  SplashClient {
  final Dio dio;
  final IConfig config;
  final RestClient client;

   ISplashClient({
    required this.dio,
    required this.config,
  }) : client = RestClient(dio, baseUrl: config.baseUrl);
}
