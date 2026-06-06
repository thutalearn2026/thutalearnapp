

import 'package:injectable/injectable.dart';

import '../domain.dart';

@Injectable()
class {{name.pascalCase()}}UseCase{
  final {{name.pascalCase()}}Repo {{name.camelCase()}}Repo;
  {{name.pascalCase()}}UseCase ({required this.{{name.camelCase()}}Repo});

}