
import 'package:flutter/material.dart';
import 'package:quran_library/quran_library.dart';

import '../ayahActions.dart';
import '../theme.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (readerContext) {
        return QuranLibraryScreen(
          parentContext: readerContext,
          isDark: false,
          appLanguageCode: 'ar',
          useDefaultAppBar: true,
          withPageView: true,
          showAyahBookmarkedIcon: true,
          backgroundColor: AppTheme.background,
          textColor: AppTheme.primaryText,
          ayahIconColor: AppTheme.forestGreen,
          ayahSelectedBackgroundColor:
          AppTheme.paleGold,
          ayahMenuStyle: AyahActions.menuStyle(
            context: readerContext,
            isDark: false,
          ),
        );
      },
    );
  }
}
