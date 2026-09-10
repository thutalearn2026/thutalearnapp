import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Injectable(as: ReelsRepo)
class IReelsRepo implements ReelsRepo {
  final ReelsClient client;

  IReelsRepo({required this.client});
  
  ///TODO: Todo function
}
