
import 'package:flutter/material.dart';

class QiblaDirectionText extends StatelessWidget {
  const QiblaDirectionText({
    super.key,
    required this.relativeBearing,
    required this.isLoading,
  });

  // Relative angle between the phone's heading and the Qibla.
  final double? relativeBearing;
  final bool isLoading;

  String get _directionText {
    if (relativeBearing == null) {
      return isLoading
          ? 'Finding your direction…'
          : 'Waiting for compass heading';
    }

    // A small tolerance accounts for normal compass movement.
    if (relativeBearing! <= 5 || relativeBearing! >= 355) {
      return 'You are facing the Qibla';
    }

    if (relativeBearing! < 180) {
      return 'Turn right ${relativeBearing!.round()}°';
    }

    return 'Turn left ${(360 - relativeBearing!).round()}°';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      _directionText,
      textAlign: TextAlign.center,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
