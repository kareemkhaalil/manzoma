import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseHelper {
  final DatabaseReference databaseReference = FirebaseDatabase.instance
      .refFromURL('https://hudor-2a83d-default-rtdb.firebaseio.com');

  Future<void> addDocument(String path, Map<String, dynamic> data) async {
    try {
      await databaseReference.child(path).push().set(data);
    } catch (e) {
      print("Error adding document: $e");
      rethrow;
    }
  }

  Future<void> addDocumentWithId(
      String path, String id, Map<String, dynamic> data) async {
    try {
      await databaseReference.child(path).child(id).set(data);
    } catch (e) {
      print("Error adding document with ID: $e");
      rethrow;
    }
  }

  Future<void> updateDocument(
      String path, String id, Map<String, dynamic> data) async {
    try {
      await databaseReference.child(path).child(id).update(data);
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  Future<void> deleteDocument(String path, String id) async {
    try {
      await databaseReference.child(path).child(id).remove();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  Future<DataSnapshot> getDocument(String path, String id) async {
    try {
      DatabaseEvent event =
          await databaseReference.child(path).child(id).once();
      return event.snapshot;
    } catch (e) {
      print("Error getting document: $e");
      rethrow;
    }
  }

  Future<DataSnapshot> getAllDocuments(String path) async {
    try {
      DatabaseEvent event = await databaseReference.child(path).once();
      return event.snapshot;
    } catch (e) {
      print("Error getting documents: $e");
      rethrow;
    }
  }
}
