import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Injectable(as: SplashRepo)
class ISplashRepo implements SplashRepo {
  final SplashClient client;

  ISplashRepo({required this.client});
  
  ///TODO: Todo function
}
