import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';

import '../../../authentication.dart';

@Injectable(as: AuthenticationClient)
class IAuthenticationClient extends  AuthenticationClient {
  final Dio dio;
  final IConfig config;
  final RestClient client;

   IAuthenticationClient({
    required this.dio,
    required this.config,
  }) : client = RestClient(dio, baseUrl: config.baseUrl);
}
