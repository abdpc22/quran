
import 'package:flutter/material.dart';

class QiblaInfoCard extends StatelessWidget {
  const QiblaInfoCard({
    super.key,
    required this.qiblaBearing,
    required this.heading,
    required this.distanceKm,
  });

  final double? qiblaBearing;
  final double? heading;
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _InfoRow(
              label: 'Qibla bearing',
              value: qiblaBearing == null
                  ? '—'
                  : '${qiblaBearing!.toStringAsFixed(1)}°',
            ),
            const Divider(height: 24),
            _InfoRow(
              label: 'Compass heading',
              value: heading == null
                  ? '—'
                  : '${heading!.toStringAsFixed(1)}°',
            ),
            const Divider(height: 24),
            _InfoRow(
              label: 'Distance to Kaaba',
              value: distanceKm == null
                  ? '—'
                  : '${distanceKm!.toStringAsFixed(0)} km',
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays one label/value pair inside the information card.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
