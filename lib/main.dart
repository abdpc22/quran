import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'app.dart';
import 'bloc/theme/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tzdata.initializeTimeZones();

  final preferences = await SharedPreferences.getInstance();

  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(preferences),
      child: const IslamicCompanionApp(),
    ),
  );
}