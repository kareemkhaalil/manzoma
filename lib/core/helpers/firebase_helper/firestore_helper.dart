import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Add a document to a collection and return the DocumentReference
  Future<DocumentReference> addDocument(
      String collectionPath, Map<String, dynamic> data) async {
    try {
      DocumentReference docRef =
          await firestore.collection(collectionPath).add(data);
      return docRef;
    } catch (e) {
      print("Error adding document: $e");
      rethrow;
    }
  }

  // Add a document with a specific ID
  Future<void> addDocumentWithId(
      String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await firestore.collection(collectionPath).doc(docId).set(data);
    } catch (e) {
      print("Error adding document with ID: $e");
      rethrow;
    }
  }

  // Update a document in a collection
  Future<void> updateDocument(
      String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await firestore.collection(collectionPath).doc(docId).update(data);
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  // Delete a document from a collection
  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  // Get a document from a collection
  Future<DocumentSnapshot> getDocument(
      String collectionPath, String docId) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection(collectionPath).doc(docId).get();
      return doc;
    } catch (e) {
      print("Error getting document: $e");
      rethrow;
    }
  }

  // Get all documents from a collection
  Future<QuerySnapshot> getAllDocuments(String collectionPath) async {
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection(collectionPath).get();
      return querySnapshot;
    } catch (e) {
      print("Error getting documents: $e");
      rethrow;
    }
  }
}
