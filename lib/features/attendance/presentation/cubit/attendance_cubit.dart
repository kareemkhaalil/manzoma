import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manzoma/core/location/location_helper.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart';
import 'package:manzoma/features/attendance/domain/usecases/check_in_with_qr_usecase.dart';
import 'package:manzoma/features/attendance/domain/usecases/get_attendance_history_tennent_usecase.dart';
import 'package:manzoma/features/branches/domain/entities/branch_entity.dart';
import 'package:manzoma/features/branches/domain/usecases/get_branches_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/check_in_usecase.dart';
import '../../domain/usecases/check_out_usecase.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../../domain/usecases/get_attendance_history_usecase.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final CheckInUseCase _checkInUseCase;
  final CheckInWithQrUseCase _checkInWithQrUseCase;

  final CheckOutUseCase _checkOutUseCase;
  final GetAttendanceHistoryUseCase _getAttendanceHistoryUseCase;
  final GetAttendanceHistoryByTennentidUseCase
      _getAttendanceHistoryByTennentidUseCase;
  final GetBranchesUseCase _getBranchesUseCase;

  static const int _limit = 20;
  int _currentOffset = 0;
  final SupabaseClient _supabase;

  // QR session fields
  Timer? _qrTimer;
  String? _qrSessionId;
  String? _qrTokenHex;
  DateTime? _qrExpiresAt;
  int _qrWindowSeconds = 58;
  String? _lastBranchId;
  AttendanceCubit({
    CheckInUseCase? checkInUseCase,
    CheckInWithQrUseCase? checkInWithQrUseCase,
    CheckOutUseCase? checkOutUseCase,
    GetAttendanceHistoryUseCase? getAttendanceHistoryUseCase,
    GetAttendanceHistoryByTennentidUseCase?
        getAttendanceHistoryByTennentidUseCase,
    GetBranchesUseCase? getBranchesUseCase,
    SupabaseClient? supabaseClient, // جديد
  })  : _checkInUseCase = checkInUseCase ?? sl<CheckInUseCase>(),
        _checkInWithQrUseCase =
            checkInWithQrUseCase ?? sl<CheckInWithQrUseCase>(),
        _checkOutUseCase = checkOutUseCase ?? sl<CheckOutUseCase>(),
        _getAttendanceHistoryUseCase =
            getAttendanceHistoryUseCase ?? sl<GetAttendanceHistoryUseCase>(),
        _getAttendanceHistoryByTennentidUseCase =
            getAttendanceHistoryByTennentidUseCase ??
                sl<GetAttendanceHistoryByTennentidUseCase>(),
        _getBranchesUseCase = getBranchesUseCase ?? sl<GetBranchesUseCase>(),
        _supabase = supabaseClient ?? Supabase.instance.client, // جديد
        super(AttendanceInitial());
  @override
  Future<void> close() {
    _qrTimer?.cancel();
    return super.close();
  }

  // ميثود مريحة لتحديث سجل المستخدم الحالي
  Future<void> refreshCurrentUserHistory(
      {DateTime? startDate, DateTime? endDate}) async {
    final user = SharedPrefHelper.getUser();
    final userId = _extractUserIdFromPrefs(user);
    if (userId == null) {
      emit(const AttendanceError(message: 'لا يوجد مستخدم حالياً في الذاكرة'));
      return;
    }
    await getAttendanceHistoryByTenant(
      tenantId: user!.tenantId,
      refresh: true,
    );
  }

  String? _extractUserIdFromPrefs(dynamic user) {
    if (user == null) return null;
    try {
      if (user is Map) {
        return (user['id'] ?? user['user_id'] ?? user['uid'])?.toString();
      } else {
        final dynamic maybe = (user as dynamic);
        if (maybe.id != null) return maybe.id.toString();
        if (maybe.userId != null) return maybe.userId.toString();
        if (maybe.uid != null) return maybe.uid.toString();
      }
    } catch (_) {}
    return null;
  }

  String? _extractBranchIdFromPrefs() {
    final user = SharedPrefHelper.getUser();
    if (user == null) return null;

    try {
      final branches = _getBranchesUseCase(GetBranchesParams(
        tenantId: user.tenantId,
      ));
      // الحالة الأولى: UserEntity
      return (user.branchId?.isNotEmpty ?? false) ? user.branchId : null;

      // الحالة الثانية: Map<dynamic, dynamic>
    } catch (e) {
      print('[QR] extractBranchId error: $e');
    }

    return null;
  }

  /* =========================
     QR session API + timer
     ========================= */
  Future<void> startQrSession({int ttlSeconds = 58}) async {
    emit(AttendanceQrCreating());
    print("[QR EMIT] AttendanceQrCreating");

    try {
      print("========== [QR DEBUG] START SESSION ==========");
      print("[QR] TTL Seconds: $ttlSeconds");

      // ✅ 1. الموقع
      final position = await LocationHelper.getCurrentLocation();
      print(
          "[QR] Current location: ${position.latitude}, ${position.longitude}");

      // ✅ 2. الفروع
      final branchesResult = await _getBranchesUseCase(GetBranchesParams(
        tenantId: SharedPrefHelper.getUser()?.tenantId ?? '',
      ));

      BranchEntity? matchedBranch;

      await branchesResult.fold(
        (failure) async {
          print("[QR ERROR] Failed to fetch branches: ${failure.message}");
          emit(AttendanceQrError("فشل في تحميل الفروع: ${failure.message}"));
          print("[QR EMIT] AttendanceQrError");
        },
        (branches) async {
          const currentLat = 31.3943409;
          const currentLng = 31.7623989;

          print("[QR] Total branches fetched: ${branches.length}");
          for (final branch in branches) {
            final distance = LocationHelper.calculateDistanceMeters(
              currentLat,
              currentLng,
              branch.latitude,
              branch.longitude,
            );
            print("[QR] Checking branch ${branch.name}, distance=$distance m");

            if (distance <= (branch.radiusMeters ?? 5.0)) {
              matchedBranch = branch;
              print("[QR ✅] Matched branch: ${branch.name} (${branch.id})");
              break;
            }
          }

          if (matchedBranch == null) {
            emit(const AttendanceQrError("لم يتم العثور على فرع قريب"));
            print("[QR EMIT] AttendanceQrError (no branch)");
            return;
          }

          // ✅ 3. Supabase
          final res = await _supabase.rpc('generate_qr_session', params: {
            'p_branch_id': matchedBranch!.id,
            'p_ttl_seconds': ttlSeconds,
          });

          print("[QR] Supabase response: $res");

          dynamic data = res;
          if (data is List && data.isNotEmpty) data = data.first;

          if (data == null || data is! Map) {
            emit(const AttendanceQrError("استجابة غير متوقعة من الخادم"));
            print("[QR EMIT] AttendanceQrError (unexpected response)");
            return;
          }

          final sessionId = data['out_session_id']?.toString();
          final sessionTokenHex = data['out_token_hex']?.toString();
          final expiresAtStr = data['out_expires_at']?.toString();

          if (sessionId == null || sessionTokenHex == null) {
            emit(const AttendanceQrError("فشل في إنشاء الجلسة: بيانات مفقودة"));
            print("[QR EMIT] AttendanceQrError (missing data)");
            return;
          }

          final expiresAt = expiresAtStr != null
              ? DateTime.tryParse(expiresAtStr)?.toLocal()
              : null;

          _qrSessionId = sessionId;
          _qrTokenHex = sessionTokenHex;
          _qrExpiresAt = expiresAt;
          _qrWindowSeconds = ttlSeconds;

          // ✅ 4. أول QR
          final first =
              _generateCurrentQr(sessionId, sessionTokenHex, _qrWindowSeconds);

          final active = AttendanceQrActive(
            sessionId: sessionId,
            tokenHex: sessionTokenHex,
            expiresAt: expiresAt,
            windowSeconds: _qrWindowSeconds,
            qrText: first.qrText,
            remainingSeconds: first.remaining,
          );

          emit(active);
          print("[QR EMIT] $active");

          // ✅ 5. المؤقت
          _qrTimer?.cancel();
          _qrTimer = Timer.periodic(const Duration(seconds: 1), (_) {
            if (_qrExpiresAt != null &&
                DateTime.now().toLocal().isAfter(_qrExpiresAt!)) {
              _qrTimer?.cancel();
              emit(AttendanceQrExpired());
              print("[QR EMIT] AttendanceQrExpired");
              return;
            }

            if (_qrSessionId == null || _qrTokenHex == null) return;

            final upd = _generateCurrentQr(
                _qrSessionId!, _qrTokenHex!, _qrWindowSeconds);

            final current = state;
            if (current is AttendanceQrActive) {
              emit(current.copyWith(
                  qrText: upd.qrText, remainingSeconds: upd.remaining));
              print("[QR EMIT] Updated QR (remaining=${upd.remaining})");
            } else {
              emit(AttendanceQrActive(
                sessionId: _qrSessionId!,
                tokenHex: _qrTokenHex!,
                expiresAt: _qrExpiresAt,
                windowSeconds: _qrWindowSeconds,
                qrText: upd.qrText,
                remainingSeconds: upd.remaining,
              ));
              print("[QR EMIT] Re-emitted AttendanceQrActive");
            }
          });
        },
      );
    } catch (e) {
      emit(AttendanceQrError("خطأ: $e"));
      print("[QR EXCEPTION] $e");
      print("[QR EMIT] AttendanceQrError (exception)");
    }
  }

  Future<void> renewQrSession() async {
    await startQrSession(ttlSeconds: _qrWindowSeconds);
  }

  void endQrSession() {
    _qrTimer?.cancel();
    emit(AttendanceQrExpired());
  }

  ({String qrText, int remaining}) _generateCurrentQr(
      String sessionId, String tokenHex, int windowSeconds) {
    final nowEpoch = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final window = nowEpoch ~/ windowSeconds;
    final message = '$sessionId|$window';
    final macHex = _hmacSha256Hex(keyHex: tokenHex, message: message);
    final qrText = '$sessionId|$window|$macHex';

    final nextWindowStart = (window + 1) * windowSeconds;
    final remaining = nextWindowStart - nowEpoch;
    return (qrText: qrText, remaining: remaining);
  }

  String _hmacSha256Hex({required String keyHex, required String message}) {
    final key = _hexDecode(keyHex);
    final hmacObj = Hmac(sha256, key);
    final digest = hmacObj.convert(utf8.encode(message));
    return _bytesToHex(digest.bytes);
  }

  List<int> _hexDecode(String hex) {
    final cleaned = hex.length % 2 == 1 ? '0$hex' : hex;
    final bytes = <int>[];
    for (var i = 0; i < cleaned.length; i += 2) {
      bytes.add(int.parse(cleaned.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  String _bytesToHex(List<int> bytes) {
    final sb = StringBuffer();
    for (final b in bytes) {
      sb.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
  }

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

  Future<void> checkInWithQr({
    required String token,
    required double lat,
    required double lng,
  }) async {
    emit(AttendanceLoading());

    final result = await _checkInWithQrUseCase(
      CheckInWithQrParams(token: token, lat: lat, lng: lng),
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

  Future<void> getAttendanceHistoryByTenant({
    required String tenantId,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentOffset = 0;
      emit(AttendanceLoading());
    } else if (state is AttendanceHistoryLoaded) {
      final currentState = state as AttendanceHistoryLoaded;
      if (currentState.hasReachedMax) return;
    }

    final result = await _getAttendanceHistoryByTennentidUseCase(
      GetAttendanceHistoryByTennentidParams(
        tenantId: tenantId,
        limit: _limit,
        offset: _currentOffset,
      ),
    );

    result.fold(
      (failure) {
        emit(AttendanceError(message: failure.message));
        print('get all attendance error: ${failure.message}');
      },
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
          print('get all attendance success: ${updatedList.length}');
        } else {
          emit(AttendanceHistoryLoaded(
            attendanceList: newAttendanceList,
            hasReachedMax: hasReachedMax,
          ));
          print('get all attendance success: ${newAttendanceList.length}');
        }
      },
    );
  }

  void resetState() {
    _currentOffset = 0;
    emit(AttendanceInitial());
  }
}
