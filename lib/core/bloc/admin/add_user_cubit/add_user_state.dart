part of 'add_user_cubit.dart';

abstract class AuthAddUserState extends Equatable {
  const AuthAddUserState();

  @override
  List<Object> get props => [];
}

class AuthAddUserInitial extends AuthAddUserState {}

class AuthAddUserLoading extends AuthAddUserState {}

class AuthAddUserSuccess extends AuthAddUserState {}

class AuthAddUserFailure extends AuthAddUserState {
  final String message;
  const AuthAddUserFailure(this.message);

  @override
  List<Object> get props => [message];
}
