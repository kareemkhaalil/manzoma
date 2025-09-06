import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manzoma/core/enums/user_role.dart';
import 'package:manzoma/core/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUsersUseCase getUsersUseCase;
  final CreateUserUseCase createUserUseCase;

  UserCubit({
    required this.getUsersUseCase,
    required this.createUserUseCase,
  }) : super(UserInitial());

  Future<void> getUsers({
    String? tenantId,
    String? branchId,
    UserRole? role,
    int? limit,
    int? offset,
  }) async {
    emit(UserLoading());

    final result = await getUsersUseCase(GetUsersParams(
      tenantId: tenantId,
      branchId: branchId,
      role: role,
      limit: limit,
      offset: offset,
    ));

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (users) => emit(UserLoaded(users: users)),
    );
  }

  Future<void> createUser(UserEntity user) async {
    emit(UserLoading());

    final result = await createUserUseCase(CreateUserParams(user: user));

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (createdUser) {
        // Refresh the users list after creating a new user
        if (state is UserCreated) {
          final currentUsers = (state as UserCreated).users;
          emit(UserCreated(users: [...currentUsers, createdUser]));
        } else {
          emit(UserCreated(users: [createdUser]));
        }
      },
    );
  }

  void resetState() {
    emit(UserInitial());
  }
}
