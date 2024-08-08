// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bashkatep/core/bloc/attend_cubit/attendance_cubit.dart';
// import 'package:bashkatep/core/models/user_model.dart';

// class UserStatisticsScreen extends StatelessWidget {
//   const UserStatisticsScreen({super.key, Key? key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read()<AttendanceCubit>(); // Correct usage

//     final Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('إحصائيات المستخدمين'),
//       ),
//       body: Center(
//         child: FutureBuilder<List<UserModel>>(
//           future: cubit.fetchUsers(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No data found.'));
//             } else {
//               List<UserModel> users = snapshot.data!;
//               return ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   UserModel user = users[index];
//                   return Card(
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             user.name,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             'User ID: ${user.id}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 10),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       UserAttendanceScreen(userId: user.id),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const AppColors.colorGreen,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 10.0, horizontal: 20.0),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: Text(
//                               "View Attendance",
//                               style: TextStyle(
//                                 fontSize: size.width * 0.01,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w900,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
