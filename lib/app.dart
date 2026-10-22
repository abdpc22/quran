
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/theme/theme_cubit.dart';
import 'main_shell.dart';
import 'theme.dart';

class IslamicCompanionApp extends StatelessWidget {
  const IslamicCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Islamic Companion',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          home: const MainShell(),
        );
      },
    );
  }
}
