import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:bashkatep/core/helpers/firebase_helper/firestore_helper.dart';
import 'package:bashkatep/core/models/branches_model.dart';

part 'add_branch_state.dart';

class AddBranchCubit extends Cubit<AddBranchState> {
  final FirestoreHelper firestoreHelper;

  AddBranchCubit(this.firestoreHelper) : super(AddBranchInitial());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController managerIdController = TextEditingController();
  final TextEditingController qrCodeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  GeoPoint? location;
  Future<void> addBranch(
    String clientId, // هذا هو معرف العميل
    String name,
    GeoPoint location, // هنا يجب أن يكون النوع GeoPoint
    String managerId,
    String qrCode,
  ) async {
    if (formKey.currentState!.validate()) {
      try {
        emit(AddBranchLoading());

        BranchModel branch = BranchModel(
          name: name,
          location: location, // تأكد من أن نوع location هو GeoPoint
          managerId: managerId,
          qrCode: qrCode, branchId: qrCode,
        );

        await firestoreHelper.addBranchToClient(clientId, branch);

        emit(AddBranchSuccess());
      } catch (e) {
        emit(AddBranchFailure('Failed to add branch: $e'));
      }
    }
  }

  void setLocation(double latitude, double longitude) {
    location = GeoPoint(latitude, longitude);
  }
}
