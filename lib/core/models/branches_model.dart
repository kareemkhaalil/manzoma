import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  String id;
  GeoPoint location;
  String managerId;
  String name;
  String qrCode;

  BranchModel({
    required this.id,
    required this.location,
    required this.managerId,
    required this.name,
    required this.qrCode,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json, String docId) {
    return BranchModel(
      id: docId,
      location: json['location'] ?? const GeoPoint(0, 0),
      managerId: json['manager_id'] ?? '',
      name: json['name'] ?? '',
      qrCode: json['qr_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'manager_id': managerId,
      'name': name,
      'qr_code': qrCode,
    };
  }
}
