import 'package:bashkatep/core/models/client_model.dart';
import 'package:bashkatep/presintation/screens/superAdmin/addClint_screen.dart';
import 'package:bashkatep/presintation/screens/superAdmin/clients_viewScreen.dart';
import 'package:flutter/material.dart';

class ClientDataTable extends StatelessWidget {
  const ClientDataTable({required this.clients, Key? key}) : super(key: key);

  final List<ClientModel> clients;

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) {
      return const Center(child: Text('No clients found'));
    }

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Client Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientsViewScreen()),
                    );
                  },
                  child: const Text(
                    "More ...",
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: clients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.business),
                    title: Text('${clients[index].clientName}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admins: ${clients[index].admins.length}'),
                        Text('Users: ${clients[index].users.length}'),
                        Text('Branches: ${clients[index].branches.length}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Handle edit client here
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
