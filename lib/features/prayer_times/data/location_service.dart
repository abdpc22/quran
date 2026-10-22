
import 'package:geolocator/geolocator.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone_finder/timezone_finder.dart';

class DeviceLocation {
  final double latitude;
  final double longitude;
  final String timeZoneId;

  const DeviceLocation({
    required this.latitude,
    required this.longitude,
    required this.timeZoneId,
  });
}

class LocationService {
  Future<DeviceLocation> getCurrentLocation() async {
    // Ensure timezone data is initialized before looking up a zone.
    tzdata.initializeTimeZones();

    final serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        'Location services are turned off. Enable location '
            'in your device settings, then try again.',
      );
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception(
        'Location permission was denied. Allow location access '
            'to calculate prayer times for your area.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is permanently denied. Open your '
            'app settings and allow location access.',
      );
    }

    final position = await Geolocator.getLastKnownPosition()
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () => null,
    ) ??
        await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 30),
          ),
        );

    // findLocation takes longitude first, then latitude.
    final timeZone = findLocation(
      position.longitude,
      position.latitude,
    );

    if (timeZone == null) {
      throw Exception(
        'Could not determine the timezone for this location. '
            'Please try again.',
      );
    }

    return DeviceLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      timeZoneId: timeZone.name,
    );
  }
}
