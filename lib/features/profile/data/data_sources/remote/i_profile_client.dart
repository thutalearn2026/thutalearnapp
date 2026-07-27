import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';

import '../../../profile.dart';

@Injectable(as: ProfileClient)
class IProfileClient extends  ProfileClient {
  final Dio dio;
  final IConfig config;
  final RestClient client;

   IProfileClient({
    required this.dio,
    required this.config,
  }) : client = RestClient(dio, baseUrl: config.baseUrl);
}
