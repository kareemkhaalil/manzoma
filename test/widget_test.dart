// import 'package:bashkatep/core/bloc/attend_cubit/qr_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:bashkatep/core/repos/hive_repo/hive_repo.dart';
// import 'package:bashkatep/core/helpers/firebase_helper/firestore_helper.dart';

// // Mock classes
// class MockFirestoreHelper extends Mock implements FirestoreHelper {}

// class MockHiveRepo extends Mock implements HiveRepo {}

// void main() {
//   late QRScanCubit qrScanCubit;
//   late MockFirestoreHelper mockFirestoreHelper;
//   late MockHiveRepo mockHiveClientRepo;
//   late MockHiveRepo mockHiveAttendanceRepo;
//   late MockHiveRepo mockHiveIsAttendRepo;

//   setUp(() {
//     mockFirestoreHelper = MockFirestoreHelper();
//     mockHiveClientRepo = MockHiveRepo();
//     mockHiveAttendanceRepo = MockHiveRepo();
//     mockHiveIsAttendRepo = MockHiveRepo();
//     qrScanCubit = QRScanCubit();
//   });

//   group('checkBranchCode', () {
//     test('emits QRScanFailure when client ID is not found', () async {
//       when(mockHiveClientRepo.get('Prd3waZVUxy7htMPtJhe')).thenReturn(null);

//       qrScanCubit.checkBranchCode(
//         '888888',
//         'GmFaLYEnD3TdkrxtuQk4IRWeYI92',
//         'جمعه',
//         BuildContext as BuildContext,
//       );
//       expect(qrScanCubit.state,
//           equals(const QRScanFailure('Client ID not found.')));
//     });

//     test('emits QRScanSuccess when everything is correct', () async {
//       // Setup your mock returns here
//       // For example:
//       // when(mockHiveClientRepo.get('clientId')).thenReturn('someClientId');
//       // when(mockFirestoreHelper.getDocument(any, any)).thenAnswer((_) async => someDocumentSnapshot);
//       // when(mockHiveAttendanceRepo.put(any, any)).thenAnswer((_) async => Future.value());

//       qrScanCubit.checkBranchCode(
//         '888888',
//         'GmFaLYEnD3TdkrxtuQk4IRWeYI92',
//         'جمعه',
//         BuildContext as BuildContext,
//       );
//       expect(qrScanCubit.state, equals(isA<QRScanSuccess>()));
//     });
//   });

//   group('checkBranchCodeCheckOut', () {
//     test('emits QRScanFailure when client ID is not found', () async {
//       when(mockHiveClientRepo.get('Prd3waZVUxy7htMPtJhe')).thenReturn(null);

//       qrScanCubit.checkBranchCodeCheckOut(
//         '888888',
//         BuildContext as BuildContext,
//       );
//       expect(qrScanCubit.state,
//           equals(const QRScanFailure('Client ID not found.')));
//     });

//     test('emits QRScanSuccess when everything is correct', () async {
//       // Setup your mock returns here
//       // For example:
//       // when(mockHiveClientRepo.get('clientId')).thenReturn('someClientId');
//       // when(mockFirestoreHelper.getDocument(any, any)).thenAnswer((_) async => someDocumentSnapshot);
//       // when(mockHiveAttendanceRepo.delete(any)).thenAnswer((_) async => Future.value());

//       qrScanCubit.checkBranchCodeCheckOut(
//         '888888',
//         BuildContext as BuildContext,
//       );
//       expect(qrScanCubit.state, equals(isA<QRScanSuccess>()));
//     });
//   });
// }
