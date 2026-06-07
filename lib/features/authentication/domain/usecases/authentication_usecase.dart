

import 'package:injectable/injectable.dart';

import '../domain.dart';

@Injectable()
class AuthenticationUseCase{
  final AuthenticationRepo authenticationRepo;
  AuthenticationUseCase ({required this.authenticationRepo});

}