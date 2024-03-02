import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "errorRequestCancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "errorConnectionTimeout";
        break;
      case DioErrorType.receiveTimeout:
        message = "errorReceiveTimeout";
        break;
      case DioErrorType.response:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioErrorType.sendTimeout:
        message = "errorSendTimeout";
        break;
      case DioErrorType.other:
        if (dioError.message.contains("SocketException")) {
          message =
              'No Internet!!! Ensure You Have An Active Internet Connection';
          break;
        }
        message = "Unexpected error occurred";
        break;
      default:
        message = "errorInternetConnection";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Customer with Similar credentials already exists';
      case 404:
        return error['message'];
      case 422:
        return "The provided credentials are invalid";
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
