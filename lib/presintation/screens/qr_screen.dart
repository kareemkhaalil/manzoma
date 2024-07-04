// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hudor/core/bloc/attend_cubit/qr_cubit.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:flutter/foundation.dart';

// class QRViewExample extends StatelessWidget {
//   const QRViewExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//     QRViewController? controller;

//     return BlocProvider(
//       create: (context) => QRScanCubit(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('QR Scanner'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Expanded(
//               flex: 5,
//               child: QRView(
//                 key: qrKey,
//                 onQRViewCreated: (QRViewController qrController) {
//                   controller = qrController;
//                   qrController.scannedDataStream.listen((scanData) {
//                     context.read<QRScanCubit>().scanResult(scanData);
//                     debugPrint('Scan data: ${scanData.code}');
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Center(
//                 child: BlocBuilder<QRScanCubit, QRScanState>(
//                   builder: (context, state) {
//                     if (state is QRScanLoading) {
//                       return const CircularProgressIndicator();
//                     } else if (state is QRScanSuccess) {
//                       return Text(
//                         'Branch Name: ${state.result.branch.name}, Location: ${state.result.branch.location.latitude}, ${state.result.branch.location.longitude}',
//                       );
//                     } else if (state is QRScanFailure) {
//                       return Text('Scan Error: ${state.error}');
//                     } else {
//                       return const Text('Scan a code');
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
