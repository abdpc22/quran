
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart';

import '../ayahActions.dart';
import '../bloc/theme/theme_cubit.dart';
import '../theme.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = QuranLibrary.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'The Quran reader could not be initialized.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _initialization = QuranLibrary.init();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDark = state.themeMode == ThemeMode.dark;

            final backgroundColor = isDark
                ? AppTheme.darkBackground
                : AppTheme.background;

            final textColor = isDark
                ? AppTheme.darkPrimaryText
                : AppTheme.primaryText;

            final ayahIconColor = isDark
                ? const Color(0xFF78B69A)
                : AppTheme.forestGreen;

            final selectedAyahColor = isDark
                ? AppTheme.darkSelectedAyah
                : AppTheme.paleGold;

            return QuranLibraryScreen(
              key: ValueKey(isDark),
              parentContext: context,
              isDark: isDark,
              appLanguageCode: 'ar',
              useDefaultAppBar: true,
              withPageView: true,
              showAyahBookmarkedIcon: true,
              backgroundColor: backgroundColor,
              textColor: textColor,
              ayahIconColor: ayahIconColor,
              ayahSelectedBackgroundColor: selectedAyahColor,
              ayahMenuStyle: AyahActions.menuStyle(
                context: context,
                isDark: isDark,
              ),
            );
          },
        );
      },
    );
  }
}
