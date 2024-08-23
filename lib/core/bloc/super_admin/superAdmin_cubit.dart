import 'package:bashkatep/core/bloc/attend_cubit/attendance_cubit.dart';
import 'package:bashkatep/core/models/user_model.dart';
import 'package:bashkatep/presintation/screens/user_report_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:bashkatep/core/models/client_model.dart';
import 'package:bashkatep/core/helpers/firebase_helper/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:bashkatep/core/models/branches_model.dart';

part 'superAdmin_states.dart';

class SuperAdminCubit extends Cubit<SuperAdminState> {
  final FirestoreHelper firestoreHelper;
  List<ClientModel> _clients = [];
  List<DataGridRow> _selectedRows = [];

  SuperAdminCubit({required this.firestoreHelper}) : super(SuperAdminInitial());

  List<ClientModel> get clients => _clients;

  void addUser(String clientId, UserModel user) async {
    try {
      emit(SuperAdminAddingUser());
      await firestoreHelper.addUserToClient(clientId, user);
      emit(SuperAdminUserAdded());
    } catch (e) {
      emit(SuperAdminError(e.toString()));
    }
  }

  void toggleEditClient(ClientModel? client) {
    emit(state is SuperAdminEditingClient
        ? SuperAdminLoaded(_clients)
        : SuperAdminEditingClient(client));
  }

  Future<void> saveChanges(
      ClientModel updatedClient, BuildContext context) async {
    try {
      emit(SuperAdminLoading());
      await firestoreHelper.updateDocument(
          'clients', updatedClient.clientId, updatedClient.toJson());
      emit(SuperAdminOperationSuccess('Client updated successfully'));
      await getClients();
      Navigator.pop(context);
    } catch (e) {
      emit(SuperAdminError(e.toString()));
    }
  }

  Future<void> updateClient(ClientModel client, BuildContext context) async {
    try {
      emit(SuperAdminLoading());
      await firestoreHelper.updateDocument(
          'clients', client.clientId, client.toJson());
      emit(SuperAdminOperationSuccess('Client updated successfully'));
      await getClients();
      Navigator.pop(context);
    } catch (e) {
      emit(SuperAdminError(e.toString()));
    }
  }

  void updateUser(String clientId, UserModel updatedUser) async {
    emit(SuperAdminLoading());
    try {
      await firestoreHelper.updateUser(clientId, updatedUser);
      emit(SuperAdminOperationSuccess('User updated successfully'));
    } catch (e) {
      emit(SuperAdminError(e.toString()));
    }
  }

  Future<void> deleteClient(String clientId) async {
    try {
      emit(SuperAdminLoading());
      await firestoreHelper.deleteDocument('clients', clientId);
      emit(SuperAdminOperationSuccess('Client deleted successfully'));
      await getClients();
    } catch (e) {
      emit(SuperAdminError(e.toString()));
    }
  }

  Future<void> getClients() async {
    try {
      emit(SuperAdminLoading());
      QuerySnapshot querySnapshot =
          await firestoreHelper.getAllDocuments('clients');
      _clients = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ClientModel.fromJson(data, doc.id);
      }).toList();

      if (_clients.isEmpty) {
        emit(SuperAdminNoClients(_clients));
      } else {
        emit(SuperAdminLoaded(_clients));
      }
    } on FirebaseException catch (e) {
      emit(SuperAdminError(e.toString()));
    }
  }

  Future<void> updateAdmin(String clientId, UserModel admin) async {
    try {
      emit(SuperAdminLoading());
      await firestoreHelper.updateAdmin(clientId, admin);
      emit(SuperAdminOperationSuccess('Admin updated successfully'));
      // Optionally, refresh the data
      await getClients();
    } on FirebaseException catch (e) {
      emit(SuperAdminError(e.toString()));
    }
  }

  Future<void> deleteAdminWithConfirmation(
      BuildContext context, String clientId, String adminId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد أنك تريد حذف هذا المسؤول؟'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteAdmin(clientId, adminId);
              },
              child: Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAdmin(String clientId, String adminId) async {
    try {
      emit(SuperAdminLoading());
      await firestoreHelper.deleteAdmin(clientId, adminId);
      emit(SuperAdminOperationSuccess('Admin deleted successfully'));
      // Optionally, refresh the data
      await getClients();
    } on FirebaseException catch (e) {
      emit(SuperAdminError(e.toString()));
    }
  }

  Future<void> deleteBranchWithConfirmation(
      BuildContext context, String clientId, String branchId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد أنك تريد حذف هذا الفرع؟'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteBranch(clientId, branchId);
              },
              child: Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUserWithConfirmation(
      BuildContext context, String clientId, String userId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد أنك تريد حذف هذا المستخدم؟'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                await deleteUser(clientId, userId);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => AttendanceCubit(),
                      child: UserReportsScreen(clientId: clientId),
                    ),
                  ),
                );
              },
              child: Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUser(String clientId, String userId) async {
    try {
      // حذف المستخدم من مجموعة `users`
      await FirebaseFirestore.instance
          .collection('clients')
          .doc(clientId)
          .collection('users')
          .doc(userId)
          .delete();

      // جلب وثيقة العميل لإيجاد المستخدم وإزالته من المصفوفة
      DocumentSnapshot clientDoc = await FirebaseFirestore.instance
          .collection('clients')
          .doc(clientId)
          .get();

      if (clientDoc.exists) {
        Map<String, dynamic> clientData =
            clientDoc.data() as Map<String, dynamic>;
        List<dynamic> users = clientData['users'] ?? [];

        // إيجاد المستخدم في المصفوفة
        var userToRemove = users.firstWhere(
            (user) => user['employee_id'] == userId,
            orElse: () => null);
        debugPrint('User to remove: $userToRemove');

        if (userToRemove != null) {
          // إزالة المستخدم من المصفوفة
          await FirebaseFirestore.instance
              .collection('clients')
              .doc(clientId)
              .update({
            'users': FieldValue.arrayRemove([userToRemove])
          });
          debugPrint('User is removed');
        } else {
          debugPrint('User not found in array.');
        }
      } else {
        debugPrint('Client document does not exist.');
      }

      // حذف المستخدم من Firebase Authentication
      await FirebaseAuth.instance.currentUser?.delete();
      debugPrint('User deleted from Firebase Authentication');
    } on FirebaseException catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }

  Future<void> deleteBranch(String clientId, String branchId) async {
    try {
      emit(SuperAdminLoading());
      await firestoreHelper.deleteBranch(clientId, branchId);
      emit(SuperAdminOperationSuccess('تم حذف الفرع بنجاح'));
      // Optionally, refresh the data
      await getClients();
    } on FirebaseException catch (e) {
      emit(SuperAdminError(e.toString()));
    }
  }

  Future<void> updateBranch(String clientId, BranchModel branch) async {
    try {
      emit(SuperAdminLoading());
      await firestoreHelper.updateBranch(clientId, branch);
      emit(SuperAdminOperationSuccess('Branch updated successfully'));
      await getClients(); // Refresh data
    } on FirebaseException catch (e) {
      emit(SuperAdminError(e.toString()));
    } catch (e) {
      emit(SuperAdminError('Unexpected error: $e'));
    }
  }

  Future<void> toggleSuspendClient(
      ClientModel client, BuildContext context) async {
    try {
      emit(SuperAdminLoading());
      client.isSuspended = !client.isSuspended;
      await firestoreHelper.updateDocument(
          'clients', client.clientId, client.toJson());
      emit(SuperAdminOperationSuccess(client.isSuspended
          ? 'Client suspended successfully'
          : 'Client activated successfully'));
      await getClients();
      Navigator.pop(context);
    } catch (e) {
      emit(SuperAdminError(e.toString()));
    }
  }

  Future<void> addClient(ClientModel client) async {
    try {
      emit(SuperAdminAddClientLoading());
      await firestoreHelper.addDocument('clients', client.toJson());
      emit(SuperAdminAddClientSuccess());
      await getClients();
    } catch (e) {
      emit(SuperAdminAddClientError(e.toString()));
    }
  }

  void deleteClientWithConfirmation(BuildContext context, String clientId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this client?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteClient(clientId);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void setSelectedRows(List<DataGridRow> selectedRows) {
    _selectedRows = selectedRows;
  }

  void deleteSelected() {
    for (var row in _selectedRows) {
      final clientName = row.getCells().first.value;
      _clients.removeWhere((client) => client.clientName == clientName);
    }
    emit(SuperAdminLoaded(_clients));
  }

  void addNewClient() {
    // Implement add new client logic
  }
}
