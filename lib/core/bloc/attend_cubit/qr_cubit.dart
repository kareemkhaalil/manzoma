import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hudor/core/helpers/firebase_helper/firestore_helper.dart';
import 'package:hudor/core/models/attendance_model.dart';
import 'package:hudor/core/models/branches_model.dart';
import 'package:hudor/core/repos/hive_repo/hive_repo.dart';
import 'package:hudor/core/repos/hive_repo/hive_repo_impl.dart';
import 'package:hudor/presintation/screens/home_screen.dart';

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
  final HiveRepo hiveAttendanceRepo = HiveRepoImpl(
      Hive.box('attendanceRecordId')); // تأكد من أن الصندوق مفتوح هنا
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

  Future<num> _checkLocation(BranchModel branch) async {
    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Check if current location is within 5 meters of branch location
    Geodesy geodesy = Geodesy();
    LatLng branchLatLng =
        LatLng(branch.location.latitude, branch.location.longitude);
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    num distance =
        geodesy.distanceBetweenTwoGeoPoints(branchLatLng, currentLatLng);

    return distance;
  }

  void scanResult(
      String result, String id, String userName, BuildContext context) async {
    try {
      emit(QRScanLoading());

      // Fetch all branches
      QuerySnapshot snapshot = await _firestore.collection('branch').get();
      debugPrint(
          'Snapshot data: ${snapshot.docs.map((doc) => doc.data()).toList()}');

      List<BranchModel> branches = snapshot.docs.map((doc) {
        return BranchModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      debugPrint('Fetched ${branches.length} branches');

      // Check if the scanned QR code matches any branch QR code
      BranchModel? matchedBranch;
      for (var branch in branches) {
        if (branch.qrCode == result) {
          matchedBranch = branch;
          break;
        }
      }

      if (matchedBranch != null) {
        debugPrint('Matched branch: ${matchedBranch.name}');

        num distance = await _checkLocation(matchedBranch);

        if (distance <= 5) {
          // Add attendance record to Firestore and get the ID
          String recordId =
              await addAttendanceRecord(matchedBranch, id, userName);

          // Store the record ID in Hive
          await hiveAttendanceRepo.put('attendanceRecordId', recordId);

          // تحديث قيمة isAttend إلى true
          await hiveIsAttendRepo.put('isAttend', true);

          // Print the stored record ID
          debugPrint(
              'Stored Attendance Record ID: ${hiveAttendanceRepo.get('attendanceRecordId')}');

          emit(QRScanSuccess(matchedBranch, isCheckIn: true));
        } else {
          emit(const QRScanFailure('انت خارج نطاق الفرع'));
        }
      } else {
        emit(const QRScanFailure('خطأ في كود الفرع'));
      }
    } catch (e) {
      debugPrint('Error while scanning: $e');
      emit(QRScanFailure('Error while scanning: $e'));
    }
  }

  void checkBranchCode(String branchCode, String id, String userName,
      BuildContext context) async {
    try {
      emit(QRScanLoading());
      debugPrint('Entered branch code: $branchCode');

      // Fetch all branches
      QuerySnapshot snapshot = await _firestore.collection('branch').get();
      debugPrint('Snapshot docs count: ${snapshot.docs.length}');

      List<BranchModel> branches = snapshot.docs.map((doc) {
        return BranchModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      debugPrint('Fetched ${branches.length} branches');

      BranchModel? matchedBranch;

      for (var branch in branches) {
        debugPrint('Comparing with branch code: ${branch.qrCode}');
        if (branch.qrCode == branchCode) {
          matchedBranch = branch;
          break;
        }
      }
      debugPrint('Matched branch: ${matchedBranch?.qrCode}');

      if (matchedBranch != null) {
        num distance = await _checkLocation(matchedBranch);

        if (distance <= 5) {
          // Add attendance record to Firestore and get the ID
          String recordId =
              await addAttendanceRecord(matchedBranch, id, userName);

          // Store the record ID in Hive
          await hiveAttendanceRepo.put('attendanceRecordId', recordId);

          // تحديث قيمة isAttend إلى true
          await hiveIsAttendRepo.put('isAttend', true);

          // Print the stored record ID
          debugPrint(
              'Stored Attendance Record ID: ${hiveAttendanceRepo.get('attendanceRecordId')}');

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
      debugPrint('Error while checking branch code: $e');
      emit(QRScanFailure('Error while checking branch code: $e'));
    }
  }

  Future<String> addAttendanceRecord(
      BranchModel branch, String id, String userName) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      AttendanceRecordModel attendanceRecord = AttendanceRecordModel(
        branchId: branch.id,
        branchName: branch.name,
        checkInTime: Timestamp.now(),
        employeeId: id, // Replace with actual employee id
        employeeName: userName, // Replace with actual employee name
        location: GeoPoint(position.latitude, position.longitude),
        mobileIp: "", // Assign appropriate value for mobile IP
      );

      DocumentReference docRef = await _firestore
          .collection('attendance')
          .add(attendanceRecord.toJson());

      debugPrint('Added attendance record with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Error while adding attendance record: $e');
      throw Exception('Error while adding attendance record: $e');
    }
  }

  void scanResultCheckOut(String result, BuildContext context) async {
    try {
      emit(QRScanLoading());

      // Fetch all branches
      QuerySnapshot snapshot = await _firestore.collection('branch').get();
      debugPrint(
          'Snapshot data: ${snapshot.docs.map((doc) => doc.data()).toList()}');

      List<BranchModel> branches = snapshot.docs.map((doc) {
        return BranchModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      debugPrint('Fetched ${branches.length} branches');

      // Check if the scanned QR code matches any branch QR code
      BranchModel? matchedBranch;
      for (var branch in branches) {
        if (branch.qrCode == result) {
          matchedBranch = branch;
          break;
        }
      }

      debugPrint('Matched branch: ${matchedBranch?.qrCode}');

      if (matchedBranch != null) {
        num distance = await _checkLocation(matchedBranch);

        if (distance <= 5) {
          // Retrieve last attendance record ID from Hive
          String? lastRecordId = hiveAttendanceRepo.get('attendanceRecordId');

          if (lastRecordId != null) {
            // Update check-out time for last attendance record
            await firestoreHelper.updateDocument(
              'attendance',
              lastRecordId,
              {'checkOutTime': Timestamp.now()},
            );

            // Delete last attendance record ID from Hive
            await hiveAttendanceRepo.delete('attendanceRecordId');

            // تحديث قيمة isAttend إلى false
            await hiveIsAttendRepo.put('isAttend', false);

            emit(QRScanSuccess(matchedBranch, isCheckIn: false));

            controller.clear();
            if (context.mounted) Navigator.pop(context);
          } else {
            emit(const QRScanFailure('لا يوجد سجل حضور نشط.'));
          }
        } else {
          emit(const QRScanFailure('أنت خارج نطاق الفرع'));
        }
      } else {
        emit(const QRScanFailure('خطأ في رمز الفرع'));
      }
    } catch (e) {
      debugPrint('خطأ أثناء التحقق من رمز الفرع: $e');
      emit(QRScanFailure('خطأ أثناء التحقق من رمز الفرع: $e'));
    }
  }

  void checkOut(String branchCode, String id, String userName,
      BuildContext context) async {
    try {
      emit(QRScanLoading());
      debugPrint('الرمز المدخل: $branchCode');

      // جلب كافة الفروع
      QuerySnapshot snapshot = await _firestore.collection('branch').get();
      debugPrint('عدد مستندات اللقطة: ${snapshot.docs.length}');

      List<BranchModel> branches = snapshot.docs.map((doc) {
        return BranchModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      debugPrint('تم جلب ${branches.length} فرع');

      BranchModel? matchedBranch;

      for (var branch in branches) {
        debugPrint('المقارنة مع رمز الفرع: ${branch.qrCode}');
        if (branch.qrCode == branchCode) {
          matchedBranch = branch;
          break;
        }
      }
      debugPrint('الفرع المتطابق: ${matchedBranch?.qrCode}');

      if (matchedBranch != null) {
        num distance = await _checkLocation(matchedBranch);

        if (distance <= 5) {
          // استرجاع هوية سجل الحضور الأخير من Hive
          String? lastRecordId = hiveAttendanceRepo.get('attendanceRecordId');

          if (lastRecordId != null) {
            // تحديث وقت الانصراف لسجل الحضور الأخير
            await firestoreHelper.updateDocument(
              'attendance',
              lastRecordId,
              {'checkOutTime': Timestamp.now()},
            );

            // حذف هوية سجل الحضور الأخير من Hive
            await hiveAttendanceRepo.delete('attendanceRecordId');

            // تحديث قيمة isAttend إلى false
            await hiveIsAttendRepo.put('isAttend', false);

            emit(QRScanSuccess(matchedBranch, isCheckIn: false));

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
            emit(const QRScanFailure('لا يوجد سجل حضور نشط.'));
          }
        } else {
          emit(const QRScanFailure('أنت خارج نطاق الفرع'));
        }
      } else {
        emit(const QRScanFailure('خطأ في رمز الفرع'));
      }
    } catch (e) {
      debugPrint('خطأ أثناء التحقق من رمز الفرع: $e');
      emit(QRScanFailure('خطأ أثناء التحقق من رمز الفرع: $e'));
    }
  }

  void resetScan() {
    emit(QRScanInitial());
  }
}
