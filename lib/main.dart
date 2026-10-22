
import 'package:flutter/material.dart';
import 'package:quran_library/quran_library.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();

  await QuranLibrary.init();

  runApp(const IslamicCompanionApp());
}