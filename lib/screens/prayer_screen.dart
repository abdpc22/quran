
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../features/prayer_times/data/location_preferences_service.dart';
import '../features/prayer_times/data/location_service.dart';
import '../features/prayer_times/data/prayer_time_service.dart';
import '../features/prayer_times/model/prayer_day.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final LocationPreferencesService _preferencesService =
  LocationPreferencesService();

  final LocationService _locationService = LocationService();

  final PrayerTimesService _prayerTimesService = PrayerTimesService();

  DeviceLocation? _location;
  PrayerDay? _prayerDay;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLocationAndPrayerTimes();
  }

  Future<void> _loadLocationAndPrayerTimes({
    bool refreshLocation = false,
  }) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final savedLocation =
      await _preferencesService.loadLocation();

      DeviceLocation location;

      if (savedLocation != null && !refreshLocation) {
        // Use the saved location without requesting GPS.
        location = savedLocation;
      } else {
        try {
          // Obtain a fresh location when needed.
          location = await _locationService.getCurrentLocation();

          // Save the location for future launches.
          await _preferencesService.saveLocation(location);
        } catch (_) {
          // Keep working offline if a previous location exists.
          if (savedLocation == null) {
            rethrow;
          }

          location = savedLocation;
        }
      }

      final prayerDay = _prayerTimesService.calculatePrayerDay(
        latitude: location.latitude,
        longitude: location.longitude,
        timeZoneId: location.timeZoneId,
      );

      if (!mounted) return;

      setState(() {
        _location = location;
        _prayerDay = prayerDay;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(BuildContext context, DateTime date) {
    return TimeOfDay.fromDateTime(date).format(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Prayer Times'),
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading prayer times...'),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Prayer Times'),
          actions: [
            IconButton(
              tooltip: 'Refresh location',
              onPressed: () => _loadLocationAndPrayerTimes(
                refreshLocation: true,
              ),
              icon: const Icon(Icons.my_location),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_off_outlined,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Location unavailable',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _loadLocationAndPrayerTimes(
                      refreshLocation: true,
                    ),
                    child: const Text('Try again'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _openLocationSettings,
                    child: const Text(
                      'Open device location settings',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final location = _location!;
    final prayerDay = _prayerDay!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        actions: [
          IconButton(
            tooltip: 'Refresh location',
            onPressed: () => _loadLocationAndPrayerTimes(
              refreshLocation: true,
            ),
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadLocationAndPrayerTimes(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your location',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Timezone: ${location.timeZoneId}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${location.latitude.toStringAsFixed(4)}, '
                        '${location.longitude.toStringAsFixed(4)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatDate(prayerDay.date),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Today's schedule",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (int i = 0;
                  i < prayerDay.entries.length;
                  i++) ...[
                    _buildPrayerRow(
                      context,
                      prayerDay.entries[i],
                    ),
                    if (i < prayerDay.entries.length - 1)
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Calculation: Muslim World League',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              'Asr rule: Shafi',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Times are calculated on your device.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerRow(
      BuildContext context,
      PrayerTimeEntry entry,
      ) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        entry.isSunrise
            ? Icons.wb_sunny_outlined
            : Icons.access_time,
        color: entry.isSunrise
            ? theme.colorScheme.secondary
            : theme.colorScheme.primary,
      ),
      title: Text(
        entry.name,
        style: TextStyle(
          fontWeight: entry.isSunrise
              ? FontWeight.normal
              : FontWeight.w600,
          color: entry.isSunrise
              ? theme.colorScheme.onSurface.withValues(alpha: 0.65)
              : theme.colorScheme.onSurface,
        ),
      ),
      trailing: Text(
        _formatTime(context, entry.time),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
