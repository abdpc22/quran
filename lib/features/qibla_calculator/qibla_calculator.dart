
import 'dart:math' as math;

/// Pure calculations used by the Qibla feature.
///
/// Keeping the mathematics here prevents the Cubit from becoming responsible
/// for both application logic and geographic calculations.
class QiblaCalculator {
  // Private constructor: this class only exposes static methods.
  QiblaCalculator._();

  // Geographic coordinates of the Kaaba in Makkah.
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  // Approximate mean radius of the Earth, used for distance calculations.
  static const double earthRadiusKm = 6371.0;

  /// Calculates the initial bearing from the user's location to the Kaaba.
  ///
  /// The result is measured clockwise from north:
  /// 0° = north, 90° = east, 180° = south, 270° = west.
  static double calculateBearing({
    required double latitude,
    required double longitude,
  }) {
    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(kaabaLatitude);

    final deltaLongitude =
    _toRadians(kaabaLongitude - longitude);

    final y = math.sin(deltaLongitude) * math.cos(lat2);

    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) *
            math.cos(lat2) *
            math.cos(deltaLongitude);

    final bearing = math.atan2(y, x) * 180 / math.pi;

    // atan2 can return a negative angle. Normalize it to 0–360°.
    return normalizeDegrees(bearing);
  }

  /// Calculates the great-circle distance to the Kaaba in kilometres.
  ///
  /// This uses the Haversine formula, which accounts for Earth's curvature.
  static double calculateDistanceKm({
    required double latitude,
    required double longitude,
  }) {
    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(kaabaLatitude);

    final deltaLatitude = lat2 - lat1;
    final deltaLongitude =
    _toRadians(kaabaLongitude - longitude);

    final a = math.pow(math.sin(deltaLatitude / 2), 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.pow(math.sin(deltaLongitude / 2), 2);

    // Floating-point rounding can occasionally push this slightly
    // outside 0–1, which would make the square root invalid.
    final boundedA = a.clamp(0.0, 1.0).toDouble();

    final centralAngle = 2 *
        math.atan2(
          math.sqrt(boundedA),
          math.sqrt(1 - boundedA),
        );

    return earthRadiusKm * centralAngle;
  }

  /// Converts any angle to the range 0° inclusive to 360° exclusive.
  ///
  /// For example, -10° becomes 350°, and 370° becomes 10°.
  static double normalizeDegrees(double degrees) {
    return (degrees % 360 + 360) % 360;
  }

  /// Trigonometric functions use radians rather than degrees.
  static double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}
