import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';

import '../../../onboarding.dart';

@Injectable(as: OnboardingClient)
class IOnboardingClient extends  OnboardingClient {
  final Dio dio;
  final IConfig config;
  final RestClient client;

   IOnboardingClient({
    required this.dio,
    required this.config,
  }) : client = RestClient(dio, baseUrl: config.baseUrl);
}
