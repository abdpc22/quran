
import 'package:adhan_dart/adhan_dart.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../model/prayer_day.dart';

class PrayerTimesService {
  PrayerTimesService() {
    tzdata.initializeTimeZones();
  }

  PrayerDay calculatePrayerDay({
    required double latitude,
    required double longitude,
    required String timeZoneId,
    DateTime? date,
  }) {
    final timeZone = tz.getLocation(timeZoneId);

    final localDate = date == null
        ? tz.TZDateTime.now(timeZone)
        : tz.TZDateTime.from(date, timeZone);

    final coordinates = Coordinates(latitude, longitude);

    final parameters =
    CalculationMethodParameters.muslimWorldLeague()
      ..madhab = Madhab.shafi
      ..highLatitudeRule =
      HighLatitudeRule.recommended(coordinates);

    final prayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: localDate,
      calculationParameters: parameters,
    );

    return PrayerDay(
      date: localDate,
      entries: [
        PrayerTimeEntry(
          name: 'Fajr',
          time: tz.TZDateTime.from(
            prayerTimes.fajr,
            timeZone,
          ),
        ),
        PrayerTimeEntry(
          name: 'Sunrise',
          time: tz.TZDateTime.from(
            prayerTimes.sunrise,
            timeZone,
          ),
          isSunrise: true,
        ),
        PrayerTimeEntry(
          name: 'Dhuhr',
          time: tz.TZDateTime.from(
            prayerTimes.dhuhr,
            timeZone,
          ),
        ),
        PrayerTimeEntry(
          name: 'Asr',
          time: tz.TZDateTime.from(
            prayerTimes.asr,
            timeZone,
          ),
        ),
        PrayerTimeEntry(
          name: 'Maghrib',
          time: tz.TZDateTime.from(
            prayerTimes.maghrib,
            timeZone,
          ),
        ),
        PrayerTimeEntry(
          name: 'Isha',
          time: tz.TZDateTime.from(
            prayerTimes.isha,
            timeZone,
          ),
        ),
      ],
    );
  }
}
