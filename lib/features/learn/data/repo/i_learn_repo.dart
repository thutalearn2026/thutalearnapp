import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Injectable(as: LearnRepo)
class ILearnRepo implements LearnRepo {
  final LearnClient client;

  ILearnRepo({required this.client});
  
  ///TODO: Todo function
}
