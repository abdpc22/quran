
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../../features/prayer_times/data/location_preferences_service.dart';
import '../../features/prayer_times/data/location_service.dart';
import '../../features/qibla_calculator/qibla_calculator.dart';
import 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({
    LocationService? locationService,
    LocationPreferencesService? preferencesService,
  })  : _locationService = locationService ?? LocationService(),
        _preferencesService =
            preferencesService ?? LocationPreferencesService(),
        super(const QiblaState());

  final LocationService _locationService;
  final LocationPreferencesService _preferencesService;

  // We keep the subscription so it can be cancelled when the Cubit closes.
  StreamSubscription<CompassEvent>? _compassSubscription;

  bool _initialized = false;

  /// Starts compass listening and loads the user's location.
  ///
  /// The guard prevents repeated initialization if the screen requests it
  /// more than once.
  Future<void> initialize() async {
    if (_initialized || isClosed) return;

    _initialized = true;

    _listenToCompass();
    await refreshLocation();
  }

  /// Listens for the phone's current compass heading.
  void _listenToCompass() {
    final events = FlutterCompass.events;

    // Some devices do not provide a supported compass sensor.
    if (events == null) {
      emit(state.copyWith(compassAvailable: false));
      return;
    }

    _compassSubscription = events.listen(
          (event) {
        final heading = event.heading;

        // A sensor event can occasionally have no heading.
        if (heading == null || isClosed) return;

        emit(
          state.copyWith(
            heading: QiblaCalculator.normalizeDegrees(heading),
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

  /// Loads a saved location or obtains and saves the current location.
  Future<void> refreshLocation() async {
    // Prevent overlapping location requests.
    if (state.isLoading || isClosed) return;

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      // Saved coordinates allow Qibla calculations to work offline.
      final savedLocation = await _preferencesService.loadLocation();

      // GPS is only needed when no saved location is available.
      final location = savedLocation ??
          await _locationService.getCurrentLocation();

      // Cache the location so future calculations can work offline.
      if (savedLocation == null) {
        await _preferencesService.saveLocation(location);
      }

      // Geographic calculations are handled outside the Cubit.
      final bearing = QiblaCalculator.calculateBearing(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      final distance = QiblaCalculator.calculateDistanceKm(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      // An asynchronous operation may finish after the Cubit closes.
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
    }
  }

  /// Converts technical location failures into readable messages.
  ///
  /// This preserves your existing string-based error handling.
  String _friendlyError(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('deniedforever') ||
        message.contains('permanently denied')) {
      return 'Location permission is permanently denied. '
          'Enable it in app settings.';
    }

    if (message.contains('denied')) {
      return 'Location permission is required to determine the Qibla.';
    }

    if (message.contains('location services are turned off')) {
      return 'Location services are disabled. '
          'Enable GPS or use a saved location.';
    }

    return 'Could not determine your location. '
        'Check GPS or try again.';
  }

  @override
  Future<void> close() async {
    // Stop listening to sensor events to avoid a lingering subscription.
    await _compassSubscription?.cancel();

    return super.close();
  }
}
