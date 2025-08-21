import '../../domain/entities/branch_entity.dart';

class BranchModel extends BranchEntity {
  const BranchModel({
    required super.id,
    required super.tenantId,
    required super.name,
    required super.latitude,
    required super.longitude,
    super.address,
    super.radiusMeters,
    super.details,
    super.createdAt,
    super.updatedAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      name: json['name'] as String,
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      address: json['address'] as String?,
      radiusMeters: json['radius_meters'] != null 
          ? double.parse(json['radius_meters'].toString()) 
          : 5.0,
      details: json['details'] as Map<String, dynamic>? ?? {},
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'radius_meters': radiusMeters,
      'details': details,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'tenant_id': tenantId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'radius_meters': radiusMeters,
      'details': details,
    };
  }

  BranchModel copyWith({
    String? id,
    String? tenantId,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    double? radiusMeters,
    Map<String, dynamic>? details,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BranchModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

