import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/presintation/screens/superAdmin/client_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bashkatep/core/models/client_model.dart';
import 'package:bashkatep/presintation/screens/superAdmin/dashboardScreen.dart';

class ClientsViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<SuperAdminCubit>().getClients(); // Fetch clients data

    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(),
              ),
            );
          },
        ),
      ),
      body: BlocBuilder<SuperAdminCubit, SuperAdminState>(
        builder: (context, state) {
          if (state is SuperAdminLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SuperAdminLoaded) {
            final clients = state.clients;

            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientDetailScreen(
                              clientId: client.clientId,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          title: Text(client.clientName),
                          subtitle: Text(
                            'Total Costs: ${client.adminCost + client.userCost + client.branchCost}',
                          ),
                          trailing: Icon(Icons.arrow_forward),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (state is SuperAdminError) {
            return Center(
                child: Text('Failed to load clients: ${state.error}'));
          } else {
            return Center(child: Text('No clients found.'));
          }
        },
      ),
    );
  }
}
