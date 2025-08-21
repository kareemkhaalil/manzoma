import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/check_in_usecase.dart';
import '../../domain/usecases/check_out_usecase.dart';
import '../../domain/usecases/get_attendance_history_usecase.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final CheckInUseCase _checkInUseCase;
  final CheckOutUseCase _checkOutUseCase;
  final GetAttendanceHistoryUseCase _getAttendanceHistoryUseCase;

  static const int _limit = 20;
  int _currentOffset = 0;

  AttendanceCubit({
    CheckInUseCase? checkInUseCase,
    CheckOutUseCase? checkOutUseCase,
    GetAttendanceHistoryUseCase? getAttendanceHistoryUseCase,
  })  : _checkInUseCase = checkInUseCase ?? sl<CheckInUseCase>(),
        _checkOutUseCase = checkOutUseCase ?? sl<CheckOutUseCase>(),
        _getAttendanceHistoryUseCase = getAttendanceHistoryUseCase ?? sl<GetAttendanceHistoryUseCase>(),
        super(AttendanceInitial());

  Future<void> checkIn({
    required String userId,
    required String location,
    String? notes,
  }) async {
    emit(AttendanceLoading());
    
    final result = await _checkInUseCase(
      CheckInParams(
        userId: userId,
        location: location,
        notes: notes,
      ),
    );
    
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (attendance) => emit(AttendanceCheckInSuccess(attendance: attendance)),
    );
  }

  Future<void> checkOut({
    required String attendanceId,
    String? notes,
  }) async {
    emit(AttendanceLoading());
    
    final result = await _checkOutUseCase(
      CheckOutParams(
        attendanceId: attendanceId,
        notes: notes,
      ),
    );
    
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (attendance) => emit(AttendanceCheckOutSuccess(attendance: attendance)),
    );
  }

  Future<void> getAttendanceHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentOffset = 0;
      emit(AttendanceLoading());
    } else if (state is AttendanceHistoryLoaded) {
      final currentState = state as AttendanceHistoryLoaded;
      if (currentState.hasReachedMax) return;
    }
    
    final result = await _getAttendanceHistoryUseCase(
      GetAttendanceHistoryParams(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
        limit: _limit,
        offset: _currentOffset,
      ),
    );
    
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (newAttendanceList) {
        final hasReachedMax = newAttendanceList.length < _limit;
        _currentOffset += newAttendanceList.length;

        if (state is AttendanceHistoryLoaded && !refresh) {
          final currentState = state as AttendanceHistoryLoaded;
          final updatedList = List.of(currentState.attendanceList)
            ..addAll(newAttendanceList);
          
          emit(AttendanceHistoryLoaded(
            attendanceList: updatedList,
            hasReachedMax: hasReachedMax,
          ));
        } else {
          emit(AttendanceHistoryLoaded(
            attendanceList: newAttendanceList,
            hasReachedMax: hasReachedMax,
          ));
        }
      },
    );
  }

  void resetState() {
    _currentOffset = 0;
    emit(AttendanceInitial());
  }
}

