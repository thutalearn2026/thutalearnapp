import 'package:dio/dio.dart';

String getApiErrorMessage(DioException error) {
  final responseData = error.response?.data;

  if (responseData is Map) {
    final errors = responseData['errors'];

    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }

        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
    }

    final message = responseData['message'];

    if (message != null && message.toString().isNotEmpty) {
      return message.toString();
    }
  }

  return error.message ?? error.toString();
}