
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart';

import '../ayahActions.dart';
import '../bloc/theme/theme_cubit.dart';
import '../theme.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.isDark;

        final backgroundColor = isDark
            ? AppTheme.darkBackground
            : AppTheme.background;

        final textColor = isDark
            ? AppTheme.darkPrimaryText
            : AppTheme.primaryText;

        final ayahIconColor = isDark
            ? AppTheme.gold
            : AppTheme.forestGreen;

        final selectedAyahColor = isDark
            ? AppTheme.darkSelectedAyah
            : AppTheme.paleGold;

        return Builder(
          builder: (readerContext) {
            return QuranLibraryScreen(
              parentContext: readerContext,
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
                context: readerContext,
                isDark: isDark,
              ),
            );
          },
        );
      },
    );
  }
}
