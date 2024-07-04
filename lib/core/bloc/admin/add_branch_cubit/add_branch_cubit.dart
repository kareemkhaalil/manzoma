import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hudor/core/helpers/firebase_helper/firestore_helper.dart';

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
      String name, GeoPoint location, String managerId, String qrCode) async {
    if (formKey.currentState!.validate()) {
      try {
        emit(AddBranchLoading());

        Map<String, dynamic> branchData = {
          'name': name,
          'location': location,
          'manager_id': managerId,
          'qr_code': qrCode,
        };

        await firestoreHelper.addDocument('branch', branchData);

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
