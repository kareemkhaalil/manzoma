import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/core/helpers/firebase_helper/firestore_helper.dart';
import 'package:bashkatep/presintation/screens/superAdmin/dashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bashkatep/core/models/client_model.dart';

class SuperAdminScreen extends StatelessWidget {
  const SuperAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return const DashboardScreen();
  }
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Super Admin Panel'),
  //     ),
  //     body: BlocBuilder<SuperAdminCubit, SuperAdminState>(
  //       builder: (context, state) {
  //         if (state is SuperAdminLoading) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (state is SuperAdminLoaded) {
  //           var clients = state.clients;

  //           return GridView.count(
  //             padding: const EdgeInsets.all(20.0),
  //             crossAxisCount: size.width > 600 ? 3 : 2,
  //             crossAxisSpacing: 20.0,
  //             mainAxisSpacing: 20.0,
  //             children: clients.map((client) {
  //               return GestureDetector(
  //                 onTap: () {
  //                   // Navigator.push(
  //                   //   context,
  //                   //   MaterialPageRoute(
  //                   //     builder: (context) => EditClientScreen(client: client),
  //                   //   ),
  //                   // );
  //                 },
  //                 child: Card(
  //                   elevation: 3,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           client.clientName,
  //                           style: const TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 10),
  //                         Text(
  //                           'Admins: ${client.admins.length}',
  //                           style: const TextStyle(fontSize: 16),
  //                         ),
  //                         Text(
  //                           'Users: ${client.users.length}',
  //                           style: const TextStyle(fontSize: 16),
  //                         ),
  //                         Text(
  //                           'Branches: ${client.branches.length}',
  //                           style: const TextStyle(fontSize: 16),
  //                         ),
  //                         const Spacer(),
  //                         Align(
  //                           alignment: Alignment.bottomRight,
  //                           child: IconButton(
  //                             icon: const Icon(Icons.edit),
  //                             onPressed: () {
  //                               // Navigator.push(
  //                               //   context,
  //                               //   MaterialPageRoute(
  //                               //     builder: (context) => EditClientScreen(client: client),
  //                               //   ),
  //                               // );
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             }).toList(),
  //           );
  //         } else if (state is SuperAdminError) {
  //           return Center(
  //             child: Text('Error: ${state.error}'),
  //           );
  //         } else {
  //           return const Center(child: Text('Unknown state'));
  //         }
  //       },
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(
  //         //     builder: (context) => const AddClientScreen(),
  //         //   ),
  //         // );
  //       },
  //       child: const Icon(Icons.add),
  //     ),
  //   );
  // }
}
