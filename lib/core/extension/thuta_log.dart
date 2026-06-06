import 'dart:developer';

void thutaLog(String message) {
  log(
    message,
    name: "Thuta Learn LOG ::::::::::::::::::::::::",
    time: DateTime.now(),
  );
}

void thutaError(String message, {Object? error}) {
  log(
    message,
    name: "Thuta Learn ERROR ::::::::::::::::::::::",
    error: error,
  );
}
