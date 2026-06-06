import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';


abstract class IConfig {
  String get baseUrl;

  Map<String, String> get headers;
}

@Injectable(as: IConfig)
class AppConfig extends IConfig {

  @override
  String get baseUrl => dotenv.get("URL");

  @override
  Map<String, String> get headers => {};
}