import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';

import '../../../home.dart';

@Injectable(as: HomeClient)
class IHomeClient extends  HomeClient {
  final Dio dio;
  final IConfig config;
  final RestClient client;

   IHomeClient({
    required this.dio,
    required this.config,
  }) : client = RestClient(dio, baseUrl: config.baseUrl);
}
