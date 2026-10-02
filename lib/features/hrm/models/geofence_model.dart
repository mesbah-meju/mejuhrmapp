import 'dart:math' as math;
import 'auth_response_model.dart';

class MatchedLocationModel {
  final int id;
  final String locationName;
  final int branchId;
  final String branchName;
  final double latitude;
  final double longitude;
  final double allowedRadius;
  final double distance;

  MatchedLocationModel({
    required this.id,
    required this.locationName,
    required this.branchId,
    required this.branchName,
    required this.latitude,
    required this.longitude,
    required this.allowedRadius,
    required this.distance,
  });

  factory MatchedLocationModel.fromJson(Map<String, dynamic> json) => MatchedLocationModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        locationName: json['location_name']?.toString() ?? '',
        branchId: json['branch_id'] is int ? json['branch_id'] : int.tryParse(json['branch_id']?.toString() ?? '0') ?? 0,
        branchName: json['branch_name']?.toString() ?? '',
        latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
        longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
        allowedRadius: (json['allowed_radius'] is num) ? (json['allowed_radius'] as num).toDouble() : (json['radius'] is num ? (json['radius'] as num).toDouble() : double.tryParse(json['allowed_radius']?.toString() ?? '150.0') ?? 150.0),
        distance: (json['distance'] is num) ? (json['distance'] as num).toDouble() : double.tryParse(json['distance']?.toString() ?? '0.0') ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_name': locationName,
        'branch_id': branchId,
        'branch_name': branchName,
        'latitude': latitude,
        'longitude': longitude,
        'allowed_radius': allowedRadius,
        'distance': distance,
      };
}

class GeofenceCheckResult {
  final bool isInsideGeofence;
  final String reason;
  final String message;
  final MatchedLocationModel? matchedLocation;

  GeofenceCheckResult({
    required this.isInsideGeofence,
    required this.reason,
    required this.message,
    this.matchedLocation,
  });

  factory GeofenceCheckResult.fromJson(Map<String, dynamic> json) => GeofenceCheckResult(
        isInsideGeofence: json['is_inside_geofence'] == true || json['is_inside_geofence'] == 1,
        reason: json['reason']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        matchedLocation: json['matched_location'] != null
            ? MatchedLocationModel.fromJson(Map<String, dynamic>.from(json['matched_location']))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'is_inside_geofence': isInsideGeofence,
        'reason': reason,
        'message': message,
        'matched_location': matchedLocation?.toJson(),
      };

  /// Compute haversine distance in meters between two lat/lng points locally
  static double calculateDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusMeters = 6371000.0;
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusMeters * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  /// Client-side nearest geofence evaluator
  static GeofenceCheckResult evaluateLocalGeofence({
    required double userLat,
    required double userLng,
    required List<TenantLocationModel> locations,
  }) {
    if (locations.isEmpty) {
      return GeofenceCheckResult(
        isInsideGeofence: false,
        reason: 'no_locations_found',
        message: 'No active tenant locations configured.',
      );
    }

    TenantLocationModel? nearestLoc;
    double minDistance = double.infinity;

    for (final loc in locations.where((l) => l.isActive)) {
      final dist = calculateDistanceMeters(userLat, userLng, loc.latitude, loc.longitude);
      if (dist < minDistance) {
        minDistance = dist;
        nearestLoc = loc;
      }
    }

    if (nearestLoc == null) {
      return GeofenceCheckResult(
        isInsideGeofence: false,
        reason: 'no_active_location',
        message: 'No active branch locations found.',
      );
    }

    final bool isInside = minDistance <= nearestLoc.radius;
    return GeofenceCheckResult(
      isInsideGeofence: isInside,
      reason: isInside ? 'inside_geofence' : 'outside_geofence',
      message: isInside
          ? 'Inside ${nearestLoc.locationName} allowed area.'
          : 'Outside Attendance Area: You are approximately ${minDistance.toStringAsFixed(1)}m away from ${nearestLoc.locationName}. Allowed radius is ${nearestLoc.radius.toInt()}m.',
      matchedLocation: MatchedLocationModel(
        id: nearestLoc.id,
        locationName: nearestLoc.locationName,
        branchId: nearestLoc.branchId,
        branchName: nearestLoc.branchName,
        latitude: nearestLoc.latitude,
        longitude: nearestLoc.longitude,
        allowedRadius: nearestLoc.radius,
        distance: minDistance,
      ),
    );
  }
}
