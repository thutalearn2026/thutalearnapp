import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Injectable(as: HomeRepo)
class IHomeRepo implements HomeRepo {
  final HomeClient client;

  IHomeRepo({required this.client});
  
  ///TODO: Todo function
}
