

import 'package:injectable/injectable.dart';

import '../domain.dart';

@Injectable()
class ReelsUseCase{
  final ReelsRepo reelsRepo;
  ReelsUseCase ({required this.reelsRepo});

}