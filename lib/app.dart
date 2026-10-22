
import 'package:flutter/material.dart';
import 'package:quran/theme.dart';
import 'main_shell.dart';

class IslamicCompanionApp extends StatelessWidget {
  const IslamicCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islamic Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}
