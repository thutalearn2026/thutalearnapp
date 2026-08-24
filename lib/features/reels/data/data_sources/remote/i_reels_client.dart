import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';

import '../../../reels.dart';

@Injectable(as: ReelsClient)
class IReelsClient extends  ReelsClient {
  final Dio dio;
  final IConfig config;
  final RestClient client;

   IReelsClient({
    required this.dio,
    required this.config,
  }) : client = RestClient(dio, baseUrl: config.baseUrl);
}
