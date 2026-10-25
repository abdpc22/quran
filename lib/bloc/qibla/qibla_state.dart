
class QiblaState {
  const QiblaState({
    this.isLoading = false,
    this.compassAvailable = false,
    this.qiblaBearing,
    this.heading,
    this.distanceKm,
    this.error,
  });

  // True while the location is being loaded or refreshed.
  final bool isLoading;

  // Indicates whether the compass stream is functioning.
  final bool compassAvailable;

  // Direction from the user's location to the Kaaba, in degrees.
  final double? qiblaBearing;

  // Current direction the phone is facing, in degrees.
  final double? heading;

  // Distance from the user's location to the Kaaba, in kilometres.
  final double? distanceKm;

  // A user-facing error message, if an operation failed.
  final String? error;

  // A bearing is only available after a location has been calculated.
  bool get hasLocation => qiblaBearing != null;

  QiblaState copyWith({
    bool? isLoading,
    bool? compassAvailable,
    double? qiblaBearing,
    double? heading,
    double? distanceKm,
    String? error,
    bool clearError = false,
  }) {
    return QiblaState(
      isLoading: isLoading ?? this.isLoading,
      compassAvailable: compassAvailable ?? this.compassAvailable,

      // Nullable values retain their previous values when omitted.
      // This matches the behavior of your original state class.
      qiblaBearing: qiblaBearing ?? this.qiblaBearing,
      heading: heading ?? this.heading,
      distanceKm: distanceKm ?? this.distanceKm,

      // Errors persist until explicitly cleared or replaced.
      error: clearError ? null : error ?? this.error,
    );
  }
}
