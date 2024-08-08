import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodesy/geodesy.dart';

import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:bashkatep/core/helpers/firebase_helper/firestore_helper.dart';
import 'package:bashkatep/core/models/attendance_model.dart';
import 'package:bashkatep/core/models/branches_model.dart';
import 'package:bashkatep/core/repos/hive_repo/hive_repo.dart';
import 'package:bashkatep/core/repos/hive_repo/hive_repo_impl.dart';
import 'package:bashkatep/presintation/screens/home_screen.dart';
import 'package:bashkatep/core/models/client_model.dart';

part 'qr_state.dart';

class QRScanCubit extends Cubit<QRScanState> {
  QRScanCubit() : super(QRScanInitial()) {
    _requestLocationPermission();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController controller = TextEditingController();
  final FirestoreHelper firestoreHelper = FirestoreHelper();
  final HiveRepo hiveRepo = HiveRepoImpl(Hive.box('token'));
  final HiveRepo hiveUserNameRepo = HiveRepoImpl(Hive.box('userName'));
  final HiveRepo hiveClientRepo = HiveRepoImpl(Hive.box('clientId'));
  final HiveRepo hiveAttendanceRepo =
      HiveRepoImpl(Hive.box('attendanceRecordId'));
  final HiveRepo hiveIsAttendRepo = HiveRepoImpl(Hive.box<bool>('isAttend'));

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }
    }
  }

  Future<String?> getClientName(String clientId) async {
    try {
      DocumentSnapshot clientDoc =
          await _firestore.collection('clients').doc(clientId).get();
      if (clientDoc.exists) {
        ClientModel client = ClientModel.fromJson(
            clientDoc.data() as Map<String, dynamic>, clientDoc.id);
        return client
            .clientName; // assuming client model has a `clientName` field
      }
    } catch (e) {
      debugPrint('Error fetching client name: $e');
    }
    return null;
  }

  Future<ClientModel?> getClient(String clientId) async {
    try {
      DocumentSnapshot clientDoc =
          await _firestore.collection('clients').doc(clientId).get();
      if (clientDoc.exists) {
        return ClientModel.fromJson(
            clientDoc.data() as Map<String, dynamic>, clientDoc.id);
      }
    } catch (e) {
      debugPrint('Error fetching client: $e');
    }
    return null;
  }

  Future<num> _checkLocation(BranchModel branch) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    Geodesy geodesy = Geodesy();
    LatLng branchLatLng = LatLng(
      branch.location.latitude,
      branch.location.longitude,
    );
    LatLng currentLatLng = LatLng(
      position.latitude,
      position.longitude,
    );
    return geodesy.distanceBetweenTwoGeoPoints(
      branchLatLng,
      currentLatLng,
    );
  }

  void scanResult(
      String result, String id, String userName, BuildContext context) async {
    try {
      emit(QRScanLoading());
      String? clientId = hiveClientRepo.get('clientId');

      if (clientId == null) {
        emit(const QRScanFailure('Client ID not found.'));
        return;
      }

      DocumentSnapshot clientSnapshot =
          await firestoreHelper.getDocument('clients', clientId);
      ClientModel client = ClientModel.fromJson(
          clientSnapshot.data() as Map<String, dynamic>, clientSnapshot.id);

      BranchModel? matchedBranch;
      for (var branch in client.branches) {
        if (branch.qrCode == result) {
          matchedBranch = branch;
          break;
        }
      }

      if (matchedBranch != null) {
        num distance = await _checkLocation(matchedBranch);
        if (distance <= 5) {
          String recordId =
              await addAttendanceRecord(matchedBranch, id, userName, clientId);
          await hiveAttendanceRepo.put('attendanceRecordId', recordId);
          await hiveIsAttendRepo.put('isAttend', true);
          emit(QRScanSuccess(matchedBranch, isCheckIn: true));
        } else {
          emit(const QRScanFailure('انت خارج نطاق الفرع'));
        }
      } else {
        emit(const QRScanFailure('خطأ في كود الفرع'));
      }
    } catch (e) {
      emit(QRScanFailure('Error while scanning: $e'));
    }
  }

  void checkBranchCode(String branchCode, String id, String userName,
      BuildContext context) async {
    try {
      emit(QRScanLoading());
      String? clientId = hiveClientRepo.get('clientId');

      if (clientId == null) {
        emit(const QRScanFailure('Client ID not found.'));
        return;
      }

      DocumentSnapshot clientSnapshot =
          await firestoreHelper.getDocument('clients', clientId);
      ClientModel client = ClientModel.fromJson(
          clientSnapshot.data() as Map<String, dynamic>, clientSnapshot.id);

      BranchModel? matchedBranch;
      for (var branch in client.branches) {
        if (branch.qrCode == branchCode) {
          matchedBranch = branch;
          break;
        }
      }

      if (matchedBranch != null) {
        num distance = await _checkLocation(matchedBranch);
        if (distance <= 5) {
          String recordId =
              await addAttendanceRecord(matchedBranch, id, userName, clientId);
          await hiveAttendanceRepo.put('attendanceRecordId', recordId);
          await hiveIsAttendRepo.put('isAttend', true);

          await firestoreHelper.updateAttendanceRecordWithSessionId(
              clientId, recordId, id);

          emit(QRScanSuccess(matchedBranch, isCheckIn: true));
          controller.clear();
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => QRScanCubit(),
                  child: const HomeScreen(),
                ),
              ),
            );
          }
        } else {
          emit(const QRScanFailure('انت خارج نطاق الفرع'));
        }
      } else {
        emit(const QRScanFailure('خطأ في كود الفرع'));
      }
    } catch (e) {
      emit(QRScanFailure('Error while checking branch code: $e'));
    }
  }

  Future<String> addAttendanceRecord(
      BranchModel branch, String id, String userName, String clientId) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      AttendanceRecordModel attendanceRecord = AttendanceRecordModel(
        branchId: branch.branchId,
        branchName: branch.name,
        checkInTime: Timestamp.now(),
        employeeId: id,
        employeeName: userName,
        location: GeoPoint(position.latitude, position.longitude),
        mobileIp: "",
      );

      // إضافة السجل الجديد إلى قاعدة البيانات
      DocumentReference docRef =
          await firestoreHelper.addAttendanceRecord(clientId, attendanceRecord);

      // تحديث السجل ليشمل id الجديد
      await docRef.update({'id': docRef.id});

      // تخزين معرف الجلسة في Hive أو أي تخزين محلي آخر
      await hiveAttendanceRepo.put('attendanceRecordId', docRef.id);

      return docRef.id;
    } catch (e) {
      throw Exception('Error while adding attendance record: $e');
    }
  }

  void scanResultCheckOut(String result, BuildContext context) async {
    try {
      emit(QRScanLoading());
      String? clientId = hiveClientRepo.get('clientId');

      if (clientId == null) {
        emit(const QRScanFailure('Client ID not found.'));
        return;
      }

      DocumentSnapshot clientSnapshot =
          await firestoreHelper.getDocument('clients', clientId);
      ClientModel client = ClientModel.fromJson(
          clientSnapshot.data() as Map<String, dynamic>, clientSnapshot.id);

      BranchModel? matchedBranch;
      for (var branch in client.branches) {
        if (branch.qrCode == result) {
          matchedBranch = branch;
          break;
        }
      }

      if (matchedBranch != null) {
        num distance = await _checkLocation(matchedBranch);
        if (distance <= 5) {
          String? lastRecordId = hiveAttendanceRepo.get('attendanceRecordId');

          if (lastRecordId != null) {
            await firestoreHelper.updateDocument(
                'attendance', lastRecordId, {'checkOutTime': Timestamp.now()});
            await hiveAttendanceRepo.delete('attendanceRecordId');
            await hiveIsAttendRepo.put('isAttend', false);
            emit(QRScanSuccess(matchedBranch, isCheckIn: false));
          } else {
            emit(const QRScanFailure('لم يتم العثور على سجل الحضور'));
          }
        } else {
          emit(const QRScanFailure('انت خارج نطاق الفرع'));
        }
      } else {
        emit(const QRScanFailure('خطأ في كود الفرع'));
      }
    } catch (e) {
      emit(QRScanFailure('Error while scanning for checkout: $e'));
    }
  }

  void checkBranchCodeCheckOut(String branchCode, BuildContext context) async {
    try {
      emit(QRScanLoading());
      String? clientId = hiveClientRepo.get('clientId');

      if (clientId == null) {
        emit(const QRScanFailure('Client ID not found.'));
        return;
      }

      DocumentSnapshot clientSnapshot =
          await firestoreHelper.getDocument('clients', clientId);
      ClientModel client = ClientModel.fromJson(
          clientSnapshot.data() as Map<String, dynamic>, clientSnapshot.id);

      BranchModel? matchedBranch;
      for (var branch in client.branches) {
        if (branch.qrCode == branchCode) {
          matchedBranch = branch;
          break;
        }
      }

      if (matchedBranch != null) {
        num distance = await _checkLocation(matchedBranch);
        if (distance <= 5) {
          String? lastRecordId = hiveAttendanceRepo.get('attendanceRecordId');

          if (lastRecordId != null) {
            await firestoreHelper.updateAttendanceRecordWithCheckOut(
                clientId, lastRecordId, Timestamp.now());
            await hiveAttendanceRepo.delete('attendanceRecordId');
            await hiveIsAttendRepo.put('isAttend', false);
            emit(QRScanSuccess(matchedBranch, isCheckIn: false));
          } else {
            emit(const QRScanFailure('لم يتم العثور على سجل الحضور'));
          }
        } else {
          emit(const QRScanFailure('انت خارج نطاق الفرع'));
        }
      } else {
        emit(const QRScanFailure('خطأ في كود الفرع'));
      }
    } catch (e) {
      emit(QRScanFailure('Error while checking branch code for checkout: $e'));
    }
  }
}
