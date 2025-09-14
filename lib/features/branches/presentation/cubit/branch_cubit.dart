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
    String? clientId, // 👈 دعم فلترة العميل
    int? limit,
    int? offset,
  }) async {
    emit(BranchLoading());

    final result = await getBranchesUseCase(
      GetBranchesParams(
        tenantId: clientId, // 👈 نربطه بالـ tenantId اللي موجود في الـ usecase
        limit: limit,
        offset: offset,
      ),
    );

    result.fold(
      (failure) => emit(BranchError(message: failure.message)),
      (branches) => emit(BranchLoaded(branches: branches)),
    );
  }

  Future<void> createBranch(BranchEntity branch) async {
    emit(BranchLoading());

    final result =
        await createBranchUseCase(CreateBranchParams(branch: branch));

    result.fold(
      (failure) => emit(BranchError(message: failure.message)),
      (createdBranch) {
        emit(BranchCreated(branch: createdBranch));

        // لو حابب تعمل refresh بعد الإنشاء مباشرة
        // getBranches(clientId: createdBranch.tenantId);
      },
    );
  }

  // افترض وجود UpdateBranchUseCase
  Future<void> updateBranch(BranchEntity branch) async {
    emit(BranchLoading());
    // final result = await updateBranchUseCase(branch);
    // result.fold(
    //   (failure) => emit(BranchError(message: failure.message)),
    //   (updatedBranch) {
    //     emit(BranchUpdated(branch: updatedBranch));
    //     getBranches(); // لإعادة تحميل القائمة
    //   },
    // );
  }

  void resetState() {
    emit(BranchInitial());
  }
}
