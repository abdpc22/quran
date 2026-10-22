
class QiblaState {
  final bool isLoading;
  final bool compassAvailable;
  final double? qiblaBearing;
  final double? heading;
  final double? distanceKm;
  final String? error;

  const QiblaState({
    this.isLoading = false,
    this.compassAvailable = false,
    this.qiblaBearing,
    this.heading,
    this.distanceKm,
    this.error,
  });

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
      qiblaBearing: qiblaBearing ?? this.qiblaBearing,
      heading: heading ?? this.heading,
      distanceKm: distanceKm ?? this.distanceKm,
      error: clearError ? null : error ?? this.error,
    );
  }
}
