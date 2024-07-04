import 'package:dio/dio.dart';

abstract class Failure {
  final String errMesage;
  const Failure(this.errMesage);
}

class ServerFailure extends Failure {
  ServerFailure({required String message}) : super(message);

  factory ServerFailure.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(message: 'Connection timeout');
      case DioExceptionType.sendTimeout:
        return ServerFailure(message: 'Send timeout');
      case DioExceptionType.receiveTimeout:
        return ServerFailure(message: 'Receive timeout');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            e.response!.statusCode!, e.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure(message: 'Request cancelled');

      case DioExceptionType.unknown:
        if (e.message!.contains(
          'SocketException',
        )) {
          return ServerFailure(message: 'No internet connection');
        }
        return ServerFailure(message: 'Unexpected error, Please try again!');

      default:
        return ServerFailure(
            message: 'Opps Ther was an Error, Pleasy try later!');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(
        message: response['msg'],
      );
    } else if (statusCode == 404) {
      return ServerFailure(
        message: "Your request not found, Pleasy try later!",
      );
    } else if (statusCode == 500) {
      return ServerFailure(
        message: "Internal Server error, Pleasy try later!",
      );
    } else {
      return ServerFailure(
        message: "Opps Ther was an Error, Pleasy try later!",
      );
    }
  }
}

class AuthinFailure extends Failure {
  AuthinFailure({required String message}) : super(message);

  factory AuthinFailure.fromResponse(dynamic response) {
    return AuthinFailure(
      message: " هناك خطأ في اسم المستخدم و كلمة المرور أو الحساب غير موجود ",
    );
  }
}
