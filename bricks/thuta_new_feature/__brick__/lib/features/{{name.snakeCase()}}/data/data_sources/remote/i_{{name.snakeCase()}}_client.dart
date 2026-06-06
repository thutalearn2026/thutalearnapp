import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';

import '../../../{{name.snakeCase()}}.dart';

@Injectable(as: {{name.pascalCase()}}Client)
class I{{name.pascalCase()}}Client extends  {{name.pascalCase()}}Client {
  final Dio dio;
  final IConfig config;
  final RestClient client;

   I{{name.pascalCase()}}Client({
    required this.dio,
    required this.config,
  }) : client = RestClient(dio, baseUrl: config.baseUrl);
}
