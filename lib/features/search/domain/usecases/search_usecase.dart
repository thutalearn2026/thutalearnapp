

import 'package:injectable/injectable.dart';

import '../domain.dart';

@Injectable()
class SearchUseCase{
  final SearchRepo searchRepo;
  SearchUseCase ({required this.searchRepo});

}