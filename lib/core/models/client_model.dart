import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  String clientId;
  String clientName;
  List<String> admins;
  List<String> users;
  List<String> branches;

  ClientModel({
    required this.clientId,
    required this.clientName,
    required this.admins,
    required this.users,
    required this.branches,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json, String docId) {
    return ClientModel(
      clientId: docId,
      clientName: json['clientName'] ?? '',
      admins: List<String>.from(json['admins'] ?? []),
      users: List<String>.from(json['users'] ?? []),
      branches: List<String>.from(json['branches'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'admins': admins,
      'users': users,
      'branches': branches,
    };
  }
}
