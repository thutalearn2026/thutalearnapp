

import 'package:injectable/injectable.dart';

import '../domain.dart';

@Injectable()
class OnboardingUseCase{
  final OnboardingRepo onboardingRepo;
  OnboardingUseCase ({required this.onboardingRepo});

}