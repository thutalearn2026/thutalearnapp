import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Injectable(as: AuthenticationRepo)
class IAuthenticationRepo implements AuthenticationRepo {
  final AuthenticationClient client;

  IAuthenticationRepo({required this.client});
  
  ///TODO: Todo function
}
