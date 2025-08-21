part of 'branch_cubit.dart';

abstract class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object> get props => [];
}

class BranchInitial extends BranchState {}

class BranchLoading extends BranchState {}

class BranchLoaded extends BranchState {
  final List<BranchEntity> branches;

  const BranchLoaded({required this.branches});

  @override
  List<Object> get props => [branches];
}

class BranchError extends BranchState {
  final String message;

  const BranchError({required this.message});

  @override
  List<Object> get props => [message];
}

