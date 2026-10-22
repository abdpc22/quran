import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._preferences)
      : super(
    ThemeState(
      themeMode: _preferences.getBool(_isDarkKey) == true
          ? ThemeMode.dark
          : ThemeMode.light,
    ),
  );

  static const String _isDarkKey = 'is_dark_mode';

  final SharedPreferences _preferences;

  Future<void> toggleTheme() async {
    final nextMode = state.isDark
        ? ThemeMode.light
        : ThemeMode.dark;

    emit(state.copyWith(themeMode: nextMode));

    await _preferences.setBool(
      _isDarkKey,
      nextMode == ThemeMode.dark,
    );
  }
}