
import 'package:flutter/material.dart';
import 'package:quran_library/quran_library.dart';

class AyahActions {
  // This class only configures the Quran library's ayah menu.
  // Playback and bookmark behavior are still handled by the package.

  AyahActions._();

  static AyahMenuStyle menuStyle({
    required BuildContext context,
    required bool isDark,
  }) {
    return AyahMenuStyle.defaults(
      isDark: isDark,
      context: context,
    ).copyWith(
      showPlayButton: true,
      showPlayAllButton: true,
      showBookmarkButtons: true,
      showCopyButton: true,
      showTafsirButton: true,
    );
  }
}
