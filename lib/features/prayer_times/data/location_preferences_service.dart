
import 'package:shared_preferences/shared_preferences.dart';

import 'location_service.dart';

class LocationPreferencesService {
  static const String _latitudeKey = 'saved_location_latitude';
  static const String _longitudeKey = 'saved_location_longitude';
  static const String _timeZoneKey = 'saved_location_timezone';

  Future<DeviceLocation?> loadLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final latitude = prefs.getDouble(_latitudeKey);
    final longitude = prefs.getDouble(_longitudeKey);
    final timeZoneId = prefs.getString(_timeZoneKey);

    if (latitude == null ||
        longitude == null ||
        timeZoneId == null ||
        timeZoneId.isEmpty) {
      return null;
    }

    return DeviceLocation(
      latitude: latitude,
      longitude: longitude,
      timeZoneId: timeZoneId,
    );
  }

  Future<void> saveLocation(DeviceLocation location) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(_latitudeKey, location.latitude);
    await prefs.setDouble(_longitudeKey, location.longitude);
    await prefs.setString(_timeZoneKey, location.timeZoneId);
  }

  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_latitudeKey);
    await prefs.remove(_longitudeKey);
    await prefs.remove(_timeZoneKey);
  }
}
