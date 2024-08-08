import 'package:bashkatep/core/models/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:bashkatep/core/models/branches_model.dart';
import 'package:bashkatep/core/models/user_model.dart';

class FirestoreHelper {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUserToClient(String clientId, UserModel user) async {
    try {
      final clientDoc = firestore.collection('clients').doc(clientId);
      final userDoc = clientDoc.collection('users').doc(user.employeeId);
      final adminDoc = clientDoc.collection('admins').doc(user.employeeId);

      await firestore.runTransaction((transaction) async {
        final clientSnapshot = await transaction.get(clientDoc);

        if (clientSnapshot.exists) {
          final clientData = clientSnapshot.data() as Map<String, dynamic>;
          List<dynamic> admins = clientData['admins'] ?? [];
          List<dynamic> users = clientData['users'] ?? [];

          if (user.role == 'admin') {
            admins.add(user.toJson());
            transaction.update(clientDoc, {'admins': admins});
            transaction.set(adminDoc, user.toJson());
          } else {
            users.add(user.toJson());
            transaction.update(clientDoc, {'users': users});
            transaction.set(userDoc, user.toJson());
          }
        }
      });
    } on FirebaseException catch (e) {
      throw Exception('Error adding user to client: $e');
    }
  }

  Future<void> addAttendanceToClient(
      String clientId, AttendanceRecordModel attendanceRecord) async {
    try {
      final clientDoc = firestore.collection('clients').doc(clientId);
      final userDoc =
          clientDoc.collection('attendanceRecords').doc(attendanceRecord.id);

      await firestore.runTransaction((transaction) async {
        final clientSnapshot = await transaction.get(clientDoc);

        if (clientSnapshot.exists) {
          final clientData = clientSnapshot.data() as Map<String, dynamic>;
          List<dynamic> attendanceRecords =
              clientData['attendanceRecords'] ?? [];

          attendanceRecords.add(attendanceRecord.toJson());
          transaction
              .update(clientDoc, {'attendanceRecords': attendanceRecords});
          transaction.set(userDoc, attendanceRecord.toJson());
        }
      });
    } on FirebaseException catch (e) {
      throw Exception('Error adding user to client: $e');
    }
  }

  Future<DocumentReference> addAttendanceRecord(
      String clientId, AttendanceRecordModel attendanceRecord) async {
    try {
      debugPrint('Adding attendance record for client: $clientId');
      final clientDoc = firestore.collection('clients').doc(clientId);
      final attendanceDoc = clientDoc.collection('attendanceRecords').doc();

      await firestore.runTransaction(
        (transaction) async {
          final clientSnapshot = await transaction.get(clientDoc);

          if (clientSnapshot.exists) {
            final clientData = clientSnapshot.data() as Map<String, dynamic>;
            List<dynamic> attendanceRecords =
                clientData['attendanceRecords'] ?? [];

            attendanceRecords.add(attendanceRecord.toJson());
            transaction
                .update(clientDoc, {'attendanceRecords': attendanceRecords});
            transaction.set(attendanceDoc, attendanceRecord.toJson());
            debugPrint('Added attendance record: ${attendanceRecord.id}');
          } else {
            debugPrint('Client document does not exist.');
            throw Exception('Client document does not exist.');
          }
        },
      );

      return attendanceDoc;
    } on FirebaseException catch (e) {
      debugPrint('Error adding attendance record: $e');
      throw Exception('Error adding attendance record: $e');
    }
  }

  Future<void> updateAttendanceRecordWithSessionId(
      String clientId, String docId, String sessionId) async {
    try {
      debugPrint(
          'Updating attendance record with sessionId for client: $clientId, record: $docId');
      final clientDoc = firestore.collection('clients').doc(clientId);
      final attendanceDoc =
          clientDoc.collection('attendanceRecords').doc(docId);

      await firestore.runTransaction((transaction) async {
        final attendanceSnapshot = await transaction.get(attendanceDoc);

        if (attendanceSnapshot.exists) {
          final attendanceData =
              attendanceSnapshot.data() as Map<String, dynamic>;

          // تحديث السجل ليشمل sessionId
          final updatedData = {
            ...attendanceData,
            'sessionId': sessionId,
          };

          transaction.update(attendanceDoc, updatedData);
          debugPrint('Updated attendance record with sessionId: $sessionId');
        } else {
          debugPrint('Attendance record does not exist.');
          throw Exception('Attendance record does not exist.');
        }
      });
    } on FirebaseException catch (e) {
      debugPrint('Error updating attendance record with sessionId: $e');
      throw Exception('Error updating attendance record with sessionId: $e');
    }
  }

  Future<void> updateClientRecord(
      String clientId, AttendanceRecordModel record) async {
    try {
      final clientDoc = firestore.collection('clients').doc(clientId);
      final attendanceDoc =
          clientDoc.collection('attendanceRecords').doc(record.id);

      await firestore.runTransaction((transaction) async {
        final clientSnapshot = await transaction.get(clientDoc);
        final attendanceSnapshot = await transaction.get(attendanceDoc);

        if (clientSnapshot.exists && attendanceSnapshot.exists) {
          // تحديث بيانات الحضور
          final updatedData = record.toJson();
          transaction.update(attendanceDoc, updatedData);

          // تحديث البيانات في قائمة attendanceRecords
          final clientData = clientSnapshot.data() as Map<String, dynamic>;
          List<dynamic> attendanceRecords =
              clientData['attendanceRecords'] ?? [];
          final attendanceIndex =
              attendanceRecords.indexWhere((r) => r['id'] == record.id);

          if (attendanceIndex != -1) {
            attendanceRecords[attendanceIndex] = updatedData;
            transaction
                .update(clientDoc, {'attendanceRecords': attendanceRecords});
          } else {
            throw Exception(
                'Attendance record not found in client attendance records list.');
          }
        } else {
          throw Exception(
              'Client document or Attendance record does not exist.');
        }
      });
    } on FirebaseException catch (e) {
      print('Error updating client record: $e');
      throw Exception('Error updating client record: $e');
    }
  }

  Future<void> updateAttendanceRecord(
      String clientId, String recordId, Map<String, Timestamp> updates) async {
    try {
      final clientDoc = firestore.collection('clients').doc(clientId);
      final attendanceDoc =
          clientDoc.collection('attendanceRecords').doc(recordId);

      await firestore.runTransaction((transaction) async {
        final clientSnapshot = await transaction.get(clientDoc);
        final attendanceSnapshot = await transaction.get(attendanceDoc);

        if (clientSnapshot.exists && attendanceSnapshot.exists) {
          final updatedData = attendanceSnapshot.data() as Map<String, dynamic>;
          updatedData.addAll(updates);
          transaction.update(attendanceDoc, updatedData);

          final clientData = clientSnapshot.data() as Map<String, dynamic>;
          List<dynamic> attendanceRecords =
              clientData['attendanceRecords'] ?? [];
          final attendanceIndex =
              attendanceRecords.indexWhere((r) => r['id'] == recordId);

          if (attendanceIndex != -1) {
            attendanceRecords[attendanceIndex] = updatedData;
            transaction
                .update(clientDoc, {'attendanceRecords': attendanceRecords});
          } else {
            throw Exception(
                'Attendance record not found in client attendance records list.');
          }
        } else {
          throw Exception(
              'Client document or Attendance record does not exist.');
        }
      });
    } on FirebaseException catch (e) {
      print('Error updating attendance record: $e');
      throw Exception('Error updating attendance record: $e');
    }
  }

  Future<void> addBranchToClient(String clientId, BranchModel branch) async {
    try {
      final clientDoc = firestore.collection('clients').doc(clientId);
      final branchDoc = clientDoc.collection('branches').doc(branch.branchId);

      await firestore.runTransaction((transaction) async {
        final clientSnapshot = await transaction.get(clientDoc);

        if (clientSnapshot.exists) {
          final clientData = clientSnapshot.data() as Map<String, dynamic>;
          List<dynamic> branches = clientData['branches'] ?? [];

          branches.add(branch.toJson());
          transaction.update(clientDoc, {'branches': branches});
          transaction.set(branchDoc, branch.toJson());
        } else {
          print('Client document does not exist.');
          throw Exception('Client document does not exist.');
        }
      });
    } on FirebaseException catch (e) {
      print('Error adding branch to client: $e');
      throw Exception('Error adding branch to client: $e');
    }
  }

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

  Future<void> addDocumentWithId(
      String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await firestore.collection(collectionPath).doc(docId).set(data);
    } catch (e) {
      print("Error adding document with ID: $e");
      rethrow;
    }
  }

  Future<void> updateAttendanceRecordWithCheckOut(
      String clientId, String docId, Timestamp checkOutTime) async {
    try {
      final clientDoc = firestore.collection('clients').doc(clientId);
      final attendanceDoc =
          clientDoc.collection('attendanceRecords').doc(docId);

      await firestore.runTransaction((transaction) async {
        final attendanceSnapshot = await transaction.get(attendanceDoc);

        if (attendanceSnapshot.exists) {
          final attendanceData =
              attendanceSnapshot.data() as Map<String, dynamic>;

          // تحديث السجل ليشمل checkOutTime
          final updatedData = {
            ...attendanceData,
            'checkOutTime': checkOutTime,
          };

          transaction.update(attendanceDoc, updatedData);

          // تحديث الـ map الخاص بالحضور داخل كولكشن العميل
          final clientData = await transaction.get(clientDoc);
          if (clientData.exists) {
            final clientAttendanceRecords =
                clientData.data()?['attendanceRecords'] as List<dynamic>? ?? [];
            final index = clientAttendanceRecords
                .indexWhere((record) => record['id'] == docId);

            if (index != -1) {
              clientAttendanceRecords[index] = updatedData;
              transaction.update(
                  clientDoc, {'attendanceRecords': clientAttendanceRecords});
            }
          }
        } else {
          throw Exception('Attendance record does not exist.');
        }
      });
    } on FirebaseException catch (e) {
      throw Exception('Error updating attendance record with checkOutTime: $e');
    }
  }

  Future<void> updateDocument(
      String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await firestore.collection(collectionPath).doc(docId).update(data);
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

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

  Future<QuerySnapshot> getCollection(String collectionPath) async {
    try {
      return await firestore.collection(collectionPath).get();
    } catch (e) {
      print("Error getting collection: $e");
      rethrow;
    }
  }

  Future<void> updateAdmin(String clientId, UserModel updatedAdmin) async {
    try {
      if (clientId.isEmpty || updatedAdmin.employeeId.isEmpty) {
        throw Exception('Client ID or Admin Employee ID is empty.');
      }

      final clientDoc = firestore.collection('clients').doc(clientId);
      final adminDoc =
          clientDoc.collection('admins').doc(updatedAdmin.employeeId);

      await firestore.runTransaction((transaction) async {
        final clientSnapshot = await transaction.get(clientDoc);

        if (clientSnapshot.exists) {
          final clientData = clientSnapshot.data() as Map<String, dynamic>;
          List<dynamic> admins = clientData['admins'] ?? [];

          final adminIndex = admins.indexWhere(
              (admin) => admin['employee_id'] == updatedAdmin.employeeId);

          if (adminIndex != -1) {
            admins[adminIndex] = updatedAdmin.toJson();
            transaction.update(clientDoc, {'admins': admins});
            transaction.update(adminDoc, updatedAdmin.toJson());
          } else {
            throw Exception('Admin not found in client admins list.');
          }
        } else {
          throw Exception('Client document does not exist.');
        }
      });
    } on FirebaseException catch (e) {
      print('Error updating admin: $e');
      throw Exception('Error updating admin: $e');
    }
  }

  Future<void> updateBranch(String clientId, BranchModel branch) async {
    try {
      if (clientId.isEmpty || branch.branchId.isEmpty) {
        debugPrint('Client ID: $clientId');
        debugPrint('Branch ID: ${branch.branchId}');
        throw Exception('Client ID or Branch ID is empty.');
      }

      debugPrint('Updating branch: ${branch.branchId} for client: $clientId');

      final clientDoc = firestore.collection('clients').doc(clientId);
      final branchDoc = clientDoc.collection('branches').doc(branch.branchId);

      await firestore.runTransaction((transaction) async {
        final clientSnapshot = await transaction.get(clientDoc);
        debugPrint('Client snapshot obtained.');

        if (clientSnapshot.exists) {
          final clientData = clientSnapshot.data() as Map<String, dynamic>;
          List<dynamic> branches = clientData['branches'] ?? [];

          final branchIndex = branches
              .indexWhere((b) => b['id'] == branch.branchId); // Use 'branch_id'

          if (branchIndex != -1) {
            print('Branch found at index: $branchIndex');
            branches[branchIndex] = branch.toJson();
            print('Branch data before update: ${branches[branchIndex]}');
            transaction.update(clientDoc, {'branches': branches});
            transaction.update(branchDoc, branch.toJson());
            print('Branch updated successfully');
          } else {
            throw Exception('Branch not found in client branches list.');
          }
        } else {
          throw Exception('Client document does not exist.');
        }
      });
    } on FirebaseException catch (e) {
      print('Error updating branch: $e');
      throw Exception('Error updating branch: $e');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> updateUser(String clientId, UserModel updatedUser) async {
    try {
      if (clientId.isEmpty || updatedUser.employeeId.isEmpty) {
        throw Exception('Client ID or User Employee ID is empty.');
      }

      final clientDoc = firestore.collection('clients').doc(clientId);
      final userDoc = clientDoc.collection('users').doc(updatedUser.employeeId);

      await firestore.runTransaction((transaction) async {
        final clientSnapshot = await transaction.get(clientDoc);

        if (clientSnapshot.exists) {
          final clientData = clientSnapshot.data() as Map<String, dynamic>;
          List<dynamic> users = clientData['users'] ?? [];

          final userIndex = users.indexWhere(
              (user) => user['employee_id'] == updatedUser.employeeId);

          if (userIndex != -1) {
            users[userIndex] = updatedUser.toJson();
            transaction.update(clientDoc, {'users': users});
            transaction.update(userDoc, updatedUser.toJson());
          } else {
            throw Exception('User not found in client users list.');
          }
        } else {
          throw Exception('Client document does not exist.');
        }
      });
    } on FirebaseException catch (e) {
      print('Error updating user: $e');
      throw Exception('Error updating user: $e');
    }
  }

  Future<void> deleteBranch(String clientId, String branchId) async {
    try {
      if (clientId.isEmpty || branchId.isEmpty) {
        throw Exception('Client ID or Branch ID is empty.');
      }

      final clientDoc = firestore.collection('clients').doc(clientId);
      final branchDoc = clientDoc.collection('branches').doc(branchId);

      await firestore.runTransaction((transaction) async {
        final clientSnapshot = await transaction.get(clientDoc);

        if (clientSnapshot.exists) {
          final clientData = clientSnapshot.data() as Map<String, dynamic>;
          List<dynamic> branches = clientData['branches'] ?? [];

          final branchIndex = branches.indexWhere((b) => b['id'] == branchId);

          if (branchIndex != -1) {
            branches.removeAt(branchIndex);
            transaction.update(clientDoc, {'branches': branches});
            transaction.delete(branchDoc);
          } else {
            throw Exception('Branch not found in client branches list.');
          }
        } else {
          throw Exception('Client document does not exist.');
        }
      });
    } on FirebaseException catch (e) {
      print('Error deleting branch: $e');
      throw Exception('Error deleting branch: $e');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteAdmin(String clientId, String employeeId) async {
    try {
      if (clientId.isEmpty || employeeId.isEmpty) {
        throw Exception('Client ID or Admin Employee ID is empty.');
      }

      final clientDoc = firestore.collection('clients').doc(clientId);
      final adminDoc = clientDoc.collection('admins').doc(employeeId);
      final userDoc = clientDoc.collection('users').doc(employeeId);

      await firestore.runTransaction((transaction) async {
        final clientSnapshot = await transaction.get(clientDoc);

        if (clientSnapshot.exists) {
          final clientData = clientSnapshot.data() as Map<String, dynamic>;
          List<dynamic> admins = clientData['admins'] ?? [];
          List<dynamic> users = clientData['users'] ?? [];

          final adminIndex =
              admins.indexWhere((admin) => admin['employee_id'] == employeeId);
          final userIndex =
              users.indexWhere((user) => user['employee_id'] == employeeId);

          if (adminIndex != -1) {
            admins.removeAt(adminIndex);
            transaction.update(clientDoc, {'admins': admins});
            transaction.delete(adminDoc);
          } else if (userIndex != -1) {
            users.removeAt(userIndex);
            transaction.update(clientDoc, {'users': users});
            transaction.delete(userDoc);
          } else {
            throw Exception('Admin or User not found in client lists.');
          }
        } else {
          throw Exception('Client document does not exist.');
        }
      });
    } on FirebaseException catch (e) {
      print('Error deleting admin: $e');
      throw Exception('Error deleting admin: $e');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

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
