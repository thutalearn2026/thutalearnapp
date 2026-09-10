

import 'package:injectable/injectable.dart';

import '../domain.dart';

@Injectable()
class SplashUseCase{
  final SplashRepo splashRepo;
  SplashUseCase ({required this.splashRepo});

}