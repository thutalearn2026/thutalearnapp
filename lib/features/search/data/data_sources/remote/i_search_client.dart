import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';

import '../../../search.dart';

@Injectable(as: SearchClient)
class ISearchClient extends  SearchClient {
  final Dio dio;
  final IConfig config;
  final RestClient client;

   ISearchClient({
    required this.dio,
    required this.config,
  }) : client = RestClient(dio, baseUrl: config.baseUrl);
}
