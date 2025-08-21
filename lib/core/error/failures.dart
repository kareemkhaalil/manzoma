import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  
  const Failure({
    required this.message,
    this.statusCode,
  });
  
  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
  });
}

class AuthFailure extends Failure {
  final String? code;
  
  const AuthFailure({
    required super.message,
    this.code,
    super.statusCode,
  });
  
  @override
  List<Object?> get props => [message, statusCode, code];
}

class ValidationFailure extends Failure {
  final Map<String, String>? errors;
  
  const ValidationFailure({
    required super.message,
    this.errors,
  });
  
  @override
  List<Object?> get props => [message, errors];
}

