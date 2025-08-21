import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/branch_entity.dart';
import '../../domain/usecases/get_branches_usecase.dart';
import '../../domain/usecases/create_branch_usecase.dart';

part 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  final GetBranchesUseCase getBranchesUseCase;
  final CreateBranchUseCase createBranchUseCase;

  BranchCubit({
    required this.getBranchesUseCase,
    required this.createBranchUseCase,
  }) : super(BranchInitial());

  Future<void> getBranches({
    String? tenantId,
    int? limit,
    int? offset,
  }) async {
    emit(BranchLoading());
    
    final result = await getBranchesUseCase(GetBranchesParams(
      tenantId: tenantId,
      limit: limit,
      offset: offset,
    ));
    
    result.fold(
      (failure) => emit(BranchError(message: failure.message)),
      (branches) => emit(BranchLoaded(branches: branches)),
    );
  }

  Future<void> createBranch(BranchEntity branch) async {
    emit(BranchLoading());
    
    final result = await createBranchUseCase(CreateBranchParams(branch: branch));
    
    result.fold(
      (failure) => emit(BranchError(message: failure.message)),
      (createdBranch) {
        // Refresh the branches list after creating a new branch
        if (state is BranchLoaded) {
          final currentBranches = (state as BranchLoaded).branches;
          emit(BranchLoaded(branches: [...currentBranches, createdBranch]));
        } else {
          emit(BranchLoaded(branches: [createdBranch]));
        }
      },
    );
  }

  void resetState() {
    emit(BranchInitial());
  }
}

