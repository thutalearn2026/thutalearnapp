

import 'package:injectable/injectable.dart';

import '../domain.dart';

@Injectable()
class ProfileUseCase{
  final ProfileRepo profileRepo;
  ProfileUseCase ({required this.profileRepo});

}