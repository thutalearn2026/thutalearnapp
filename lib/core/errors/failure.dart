abstract class Failure {
  final dynamic e;

  Failure({this.e});
}

class ConnectionFailure extends Failure {

}

class ServerFailure extends Failure {
  ServerFailure({super.e});
}