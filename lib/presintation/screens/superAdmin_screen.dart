import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hudor/core/models/client_model.dart';

class SuperAdminScreen extends StatelessWidget {
  const SuperAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Panel'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('clients').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var clients = snapshot.data!.docs
              .map((doc) => ClientModel.fromJson(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(clients[index].clientName),
                subtitle: Text(
                    'Admins: ${clients[index].admins.length}, Users: ${clients[index].users.length}, Branches: ${clients[index].branches.length}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit client screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditClientScreen(client: clients[index]),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add new client screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddClientScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EditClientScreen extends StatelessWidget {
  final ClientModel client;

  const EditClientScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: client.clientName);
    final TextEditingController adminController = TextEditingController();
    final TextEditingController userController = TextEditingController();
    final TextEditingController branchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Client Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: adminController,
              decoration: const InputDecoration(labelText: 'Add Admin'),
            ),
            ElevatedButton(
              onPressed: () {
                client.admins.add(adminController.text);
                adminController.clear();
              },
              child: const Text('Add Admin'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: userController,
              decoration: const InputDecoration(labelText: 'Add User'),
            ),
            ElevatedButton(
              onPressed: () {
                client.users.add(userController.text);
                userController.clear();
              },
              child: const Text('Add User'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: branchController,
              decoration: const InputDecoration(labelText: 'Add Branch'),
            ),
            ElevatedButton(
              onPressed: () {
                client.branches.add(branchController.text);
                branchController.clear();
              },
              child: const Text('Add Branch'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection('clients')
                    .doc(client.clientId)
                    .update(client.toJson())
                    .then((value) => Navigator.pop(context));
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection('clients')
                    .doc(client.clientId)
                    .delete()
                    .then((value) => Navigator.pop(context));
              },
              child: const Text('Delete Client'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddClientScreen extends StatelessWidget {
  const AddClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController adminController = TextEditingController();
    final TextEditingController userController = TextEditingController();
    final TextEditingController branchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Client Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: adminController,
              decoration: const InputDecoration(labelText: 'Add Admin'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: userController,
              decoration: const InputDecoration(labelText: 'Add User'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: branchController,
              decoration: const InputDecoration(labelText: 'Add Branch'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FirebaseFirestore.instance.collection('clients').add({
                  'clientName': nameController.text,
                  'admins': [adminController.text],
                  'users': [userController.text],
                  'branches': [branchController.text],
                }).then((value) => Navigator.pop(context));
              },
              child: const Text('Add Client'),
            ),
          ],
        ),
      ),
    );
  }
}
