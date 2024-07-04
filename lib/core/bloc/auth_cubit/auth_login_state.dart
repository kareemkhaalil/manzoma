part of 'auth_login_cubit.dart';

@immutable
sealed class AuthLoginState extends Equatable {
  const AuthLoginState();

  @override
  List<Object> get props => [];
}

final class AuthLoginInitial extends AuthLoginState {}

final class AuthLoginLoading extends AuthLoginState {}

final class AuthLoginFailure extends AuthLoginState {
  final String message;

  const AuthLoginFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthLoginSuccess extends AuthLoginState {
  final bool isAdmin;

  const AuthLoginSuccess({required this.isAdmin});

  @override
  List<Object> get props => [isAdmin];
}

final class AuthLoginValidationError extends AuthLoginState {
  final String message;

  const AuthLoginValidationError(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthLoginValid extends AuthLoginState {}
