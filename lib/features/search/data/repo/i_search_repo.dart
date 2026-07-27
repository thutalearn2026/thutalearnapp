import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Injectable(as: SearchRepo)
class ISearchRepo implements SearchRepo {
  final SearchClient client;

  ISearchRepo({required this.client});
  
  ///TODO: Todo function
}
