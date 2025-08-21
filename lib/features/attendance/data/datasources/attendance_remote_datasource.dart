import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceModel> checkIn({
    required String userId,
    required String location,
    String? notes,
  });

  Future<AttendanceModel> checkOut({
    required String attendanceId,
    String? notes,
  });

  Future<List<AttendanceModel>> getAttendanceHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  Future<List<AttendanceModel>> getAllAttendance({
    DateTime? date,
    String? userId,
    int? limit,
    int? offset,
  });

  Future<AttendanceModel> updateAttendance({
    required String attendanceId,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? status,
    String? notes,
  });

  Future<void> deleteAttendance({required String attendanceId});
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final SupabaseClient supabaseClient;

  AttendanceRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<AttendanceModel> checkIn({
    required String userId,
    required String location,
    String? notes,
  }) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Check if user already checked in today
      final existingAttendance = await supabaseClient
          .from('attendance')
          .select()
          .eq('user_id', userId)
          .eq('date', today.toIso8601String().split('T')[0])
          .maybeSingle();

      if (existingAttendance != null) {
        throw const ServerException(
            message: 'تم تسجيل الحضور مسبقاً لهذا اليوم');
      }

      // Get user info
      final userProfile = await supabaseClient
          .from('profiles')
          .select('name')
          .eq('id', userId)
          .single();

      final attendanceData = {
        'user_id': userId,
        'user_name': userProfile['name'],
        'date': today.toIso8601String().split('T')[0],
        'check_in_time': now.toIso8601String(),
        'status': 'present',
        'location': location,
        'notes': notes,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final response = await supabaseClient
          .from('attendance')
          .insert(attendanceData)
          .select()
          .single();

      return AttendanceModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AttendanceModel> checkOut({
    required String attendanceId,
    String? notes,
  }) async {
    try {
      final now = DateTime.now();

      final updateData = {
        'check_out_time': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      if (notes != null) {
        updateData['notes'] = notes;
      }

      final response = await supabaseClient
          .from('attendance')
          .update(updateData)
          .eq('id', attendanceId)
          .select()
          .single();

      return AttendanceModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendanceHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query =
          supabaseClient.from('attendance').select().eq('user_id', userId);

      if (startDate != null) {
        query = query.gte('date', startDate.toIso8601String().split('T')[0]);
      }

      if (endDate != null) {
        query = query.lte('date', endDate.toIso8601String().split('T')[0]);
      }

      query = query.order('date', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;

      return response.map((json) => AttendanceModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<AttendanceModel>> getAllAttendance({
    DateTime? date,
    String? userId,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = supabaseClient.from('attendance').select();

      if (date != null) {
        query = query.eq('date', date.toIso8601String().split('T')[0]);
      }

      if (userId != null) {
        query = query.eq('user_id', userId);
      }

      query = query.order('date', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;

      return response.map((json) => AttendanceModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AttendanceModel> updateAttendance({
    required String attendanceId,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? status,
    String? notes,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (checkInTime != null) {
        updateData['check_in_time'] = checkInTime.toIso8601String();
      }

      if (checkOutTime != null) {
        updateData['check_out_time'] = checkOutTime.toIso8601String();
      }

      if (status != null) {
        updateData['status'] = status;
      }

      if (notes != null) {
        updateData['notes'] = notes;
      }

      final response = await supabaseClient
          .from('attendance')
          .update(updateData)
          .eq('id', attendanceId)
          .select()
          .single();

      return AttendanceModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteAttendance({required String attendanceId}) async {
    try {
      await supabaseClient.from('attendance').delete().eq('id', attendanceId);
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code != null ? int.tryParse(e.code!) : null,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
