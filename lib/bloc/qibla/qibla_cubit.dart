
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../../features/prayer_times/data/location_service.dart';
import '../../features/prayer_times/data/location_preferences_service.dart';
import 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({
    LocationService? locationService,
    LocationPreferencesService? preferencesService,
  })  : _locationService = locationService ?? LocationService(),
        _preferencesService =
            preferencesService ?? LocationPreferencesService(),
        super(const QiblaState());

  static const double _kaabaLatitude = 21.422487;
  static const double _kaabaLongitude = 39.826206;
  static const double _earthRadiusKm = 6371.0;

  final LocationService _locationService;
  final LocationPreferencesService _preferencesService;

  StreamSubscription<CompassEvent>? _compassSubscription;

  bool _initialized = false;
  bool _loadingLocation = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _initialized = true;
    _listenToCompass();

    await refreshLocation();
  }

  void _listenToCompass() {
    final events = FlutterCompass.events;

    if (events == null) {
      emit(state.copyWith(compassAvailable: false));
      return;
    }

    _compassSubscription = events.listen(
          (event) {
        final heading = event.heading;

        if (heading == null || isClosed) return;

        emit(
          state.copyWith(
            heading: (heading + 360) % 360,
            compassAvailable: true,
          ),
        );
      },
      onError: (_) {
        if (isClosed) return;
        emit(state.copyWith(compassAvailable: false));
      },
    );
  }

  Future<void> refreshLocation() async {
    if (_loadingLocation || isClosed) return;

    _loadingLocation = true;
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      // Reuse saved coordinates whenever available. This allows
      // Qibla calculations to work offline without requesting GPS.
      final savedLocation = await _preferencesService.loadLocation();

      final location = savedLocation ??
          await _locationService.getCurrentLocation();

      // Cache a newly acquired location for future offline use.
      if (savedLocation == null) {
        await _preferencesService.saveLocation(location);
      }

      final bearing = _calculateBearing(
        location.latitude,
        location.longitude,
        _kaabaLatitude,
        _kaabaLongitude,
      );

      final distance = _calculateDistance(
        location.latitude,
        location.longitude,
        _kaabaLatitude,
        _kaabaLongitude,
      );

      if (isClosed) return;

      emit(
        state.copyWith(
          isLoading: false,
          qiblaBearing: bearing,
          distanceKm: distance,
          clearError: true,
        ),
      );
    } catch (error) {
      if (isClosed) return;

      emit(
        state.copyWith(
          isLoading: false,
          error: _friendlyError(error),
        ),
      );
    } finally {
      _loadingLocation = false;
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('deniedforever') ||
        message.contains('permanently denied')) {
      return 'Location permission is permanently denied. Enable it in app settings.';
    }

    if (message.contains('denied')) {
      return 'Location permission is required to determine the Qibla.';
    }

    if (message.contains('location services are turned off')) {
      return 'Location services are disabled. Enable GPS or use a saved location.';
    }

    return 'Could not determine your location. Check GPS or try again.';
  }

  double _calculateBearing(
      double latitude,
      double longitude,
      double destinationLatitude,
      double destinationLongitude,
      ) {
    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(destinationLatitude);
    final deltaLongitude =
    _toRadians(destinationLongitude - longitude);

    final y = math.sin(deltaLongitude) * math.cos(lat2);

    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) *
            math.cos(lat2) *
            math.cos(deltaLongitude);

    final bearing = math.atan2(y, x) * 180 / math.pi;

    return (bearing + 360) % 360;
  }

  double _calculateDistance(
      double latitude,
      double longitude,
      double destinationLatitude,
      double destinationLongitude,
      ) {
    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(destinationLatitude);
    final deltaLat = lat2 - lat1;
    final deltaLon =
    _toRadians(destinationLongitude - longitude);

    final a = math.pow(math.sin(deltaLat / 2), 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.pow(math.sin(deltaLon / 2), 2);

    final boundedA = a.clamp(0.0, 1.0).toDouble();

    final centralAngle = 2 *
        math.atan2(
          math.sqrt(boundedA),
          math.sqrt(1 - boundedA),
        );

    return _earthRadiusKm * centralAngle;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;

  @override
  Future<void> close() async {
    await _compassSubscription?.cancel();
    return super.close();
  }
}
