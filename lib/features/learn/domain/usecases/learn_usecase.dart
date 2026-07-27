

import 'package:injectable/injectable.dart';

import '../domain.dart';

@Injectable()
class LearnUseCase{
  final LearnRepo learnRepo;
  LearnUseCase ({required this.learnRepo});

}