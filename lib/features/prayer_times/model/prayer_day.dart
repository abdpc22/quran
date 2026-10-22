class PrayerTimeEntry {
  final String name;
  final DateTime time;
  final bool isSunrise;

  const PrayerTimeEntry({
    required this.name,
    required this.time,
    this.isSunrise = false,
  });
}

class PrayerDay {
  final DateTime date;
  final List<PrayerTimeEntry> entries;

  const PrayerDay({
    required this.date,
    required this.entries,
  });
}