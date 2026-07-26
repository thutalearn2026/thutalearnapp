

import 'package:injectable/injectable.dart';

import '../domain.dart';

@Injectable()
class HomeUseCase{
  final HomeRepo homeRepo;
  HomeUseCase ({required this.homeRepo});

}