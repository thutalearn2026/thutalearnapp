import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Injectable(as: ProfileRepo)
class IProfileRepo implements ProfileRepo {
  final ProfileClient client;

  IProfileRepo({required this.client});
  
  ///TODO: Todo function
}
