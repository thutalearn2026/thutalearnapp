import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Injectable(as: OnboardingRepo)
class IOnboardingRepo implements OnboardingRepo {
  final OnboardingClient client;

  IOnboardingRepo({required this.client});
  
  ///TODO: Todo function
}
