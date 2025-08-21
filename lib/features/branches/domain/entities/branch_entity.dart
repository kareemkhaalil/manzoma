import 'dart:math';

import 'package:equatable/equatable.dart';

class BranchEntity extends Equatable {
  final String id;
  final String tenantId;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final double radiusMeters;
  final Map<String, dynamic> details;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BranchEntity({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.radiusMeters = 5.0,
    this.details = const {},
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        tenantId,
        name,
        latitude,
        longitude,
        address,
        radiusMeters,
        details,
        createdAt,
        updatedAt,
      ];

  // Helper methods
  String get displayName => name;

  String get fullAddress => address ?? 'No address provided';

  bool isWithinRadius(double userLat, double userLon) {
    // Simple distance calculation (Haversine formula would be more accurate)
    final double distance =
        _calculateDistance(latitude, longitude, userLat, userLon);
    return distance <= radiusMeters;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth radius in meters
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
}
