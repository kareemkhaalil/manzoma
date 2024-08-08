import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  final String branchId;
  final String name;
  final String managerId;
  final String qrCode;
  final GeoPoint location;

  BranchModel({
    required this.branchId,
    required this.name,
    required this.managerId,
    required this.qrCode,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': branchId,
      'name': name,
      'manager_id': managerId,
      'qr_code': qrCode,
      'location': location,
    };
  }

  factory BranchModel.fromJson(Map<String, dynamic> json, String id) {
    return BranchModel(
      branchId: id,
      name: json['name'] ?? '',
      managerId: json['manager_id'] ?? '',
      qrCode: json['qr_code'] ?? '',
      location: json['location'] as GeoPoint,
    );
  }

  BranchModel copyWith({
    String? branchId,
    String? name,
    String? managerId,
    String? qrCode,
    GeoPoint? location,
  }) {
    return BranchModel(
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      managerId: managerId ?? this.managerId,
      qrCode: qrCode ?? this.qrCode,
      location: location ?? this.location,
    );
  }
}
