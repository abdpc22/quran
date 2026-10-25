
import 'dart:math' as math;

import 'package:flutter/material.dart';

class QiblaCompassDial extends StatelessWidget {
  const QiblaCompassDial({
    super.key,
    required this.heading,
    required this.relativeBearing,
  });

  // Direction the phone is facing, measured from north.
  final double? heading;

  // Direction from the phone's current facing to the Qibla.
  final double? relativeBearing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.surface,
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.35),
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rotate the compass labels opposite to the phone heading.
            // This keeps the dial aligned with the real-world directions.
            if (heading != null)
              Transform.rotate(
                angle: -heading! * math.pi / 180,
                child: SizedBox.expand(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _CardinalLabel(
                        label: 'N',
                        alignment: Alignment.topCenter,
                        textStyle: textTheme.titleMedium,
                      ),
                      _CardinalLabel(
                        label: 'E',
                        alignment: Alignment.centerRight,
                        textStyle: textTheme.titleMedium,
                      ),
                      _CardinalLabel(
                        label: 'S',
                        alignment: Alignment.bottomCenter,
                        textStyle: textTheme.titleMedium,
                      ),
                      _CardinalLabel(
                        label: 'W',
                        alignment: Alignment.centerLeft,
                        textStyle: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              )
            else
            // Before a compass reading arrives, show north as a reference.
              const _CardinalLabel(
                label: 'N',
                alignment: Alignment.topCenter,
              ),

            // Rotate the Kaaba marker to the relative Qibla direction.
            if (relativeBearing != null)
              Transform.rotate(
                angle: relativeBearing! * math.pi / 180,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Icon(
                      Icons.mosque_rounded,
                      size: 30,
                      color: colors.primary,
                    ),
                  ),
                ),
              )
            else
              Icon(
                Icons.explore_outlined,
                size: 90,
                color: colors.onSurface.withValues(alpha: 0.35),
              ),

            // Keep the original navigation arrow at the center.
            Icon(
              Icons.navigation,
              size: 80,
              color: colors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// A small reusable label positioned around the compass dial.
class _CardinalLabel extends StatelessWidget {
  const _CardinalLabel({
    required this.label,
    required this.alignment,
    this.textStyle,
  });

  final String label;
  final Alignment alignment;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    // Padding keeps labels away from the outer border.
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          label,
          style: textStyle?.copyWith(fontWeight: FontWeight.bold) ??
              Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
