import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Injectable(as: {{name.pascalCase()}}Repo)
class I{{name.pascalCase()}}Repo implements {{name.pascalCase()}}Repo {
  final {{name.pascalCase()}}Client client;

  I{{name.pascalCase()}}Repo({required this.client});
  
  ///TODO: Todo function
}
