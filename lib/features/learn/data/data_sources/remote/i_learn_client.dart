import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';

import '../../../learn.dart';

@Injectable(as: LearnClient)
class ILearnClient extends  LearnClient {
  final Dio dio;
  final IConfig config;
  final RestClient client;

   ILearnClient({
    required this.dio,
    required this.config,
  }) : client = RestClient(dio, baseUrl: config.baseUrl);
}
