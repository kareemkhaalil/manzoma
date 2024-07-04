part of 'qr_cubit.dart';

abstract class QRScanState extends Equatable {
  const QRScanState();

  @override
  List<Object?> get props => [];
}

class QRScanInitial extends QRScanState {}

class QRScanSuccess extends QRScanState {
  final BranchModel result;
  final bool isCheckIn; // Add this property

  const QRScanSuccess(this.result, {required this.isCheckIn});

  @override
  List<Object?> get props => [result, isCheckIn];
}

class QRScanLoading extends QRScanState {}

class QRScanFailure extends QRScanState {
  final String error;

  const QRScanFailure(this.error);

  @override
  List<Object?> get props => [error];
}
