import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Customer 1'),
                  subtitle: Text('Details about customer 1'),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Customer 2'),
                  subtitle: Text('Details about customer 2'),
                ),
                // Add more ListTile widgets here
              ],
            ),
          ],
        ),
      ),
    );
  }
}
