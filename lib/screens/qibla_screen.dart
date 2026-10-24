
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../bloc/qibla/qibla_cubit.dart';
import '../bloc/qibla/qibla_state.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QiblaCubit(),
      child: _QiblaView(isActive: isActive),
    );
  }
}

class _QiblaView extends StatefulWidget {
  const _QiblaView({required this.isActive});

  final bool isActive;

  @override
  State<_QiblaView> createState() => _QiblaViewState();
}

class _QiblaViewState extends State<_QiblaView> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeIfActive();
  }

  @override
  void didUpdateWidget(covariant _QiblaView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeIfActive();
  }

  void _initializeIfActive() {
    if (!widget.isActive || _started) return;

    _started = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<QiblaCubit>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Compass'),
        actions: [
          IconButton(
            tooltip: 'Refresh location',
            onPressed: () {
              context.read<QiblaCubit>().refreshLocation();
            },
            icon: const Icon(Icons.my_location_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<QiblaCubit, QiblaState>(
          builder: (context, state) {
            final relativeBearing =
            state.qiblaBearing != null && state.heading != null
                ? (state.qiblaBearing! - state.heading! + 360) % 360
                : null;

            final String directionText;

            if (relativeBearing == null) {
              directionText = state.isLoading
                  ? 'Finding your direction…'
                  : 'Waiting for compass heading';
            } else if (relativeBearing <= 5 ||
                relativeBearing >= 355) {
              directionText = 'You are facing the Qibla';
            } else if (relativeBearing < 180) {
              directionText = 'Turn right ${relativeBearing.round()}°';
            } else {
              directionText =
              'Turn left ${(360 - relativeBearing).round()}°';
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Find the direction of the Kaaba in Makkah.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),

                // Compass dial.
                Center(
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
                        // The dial rotates opposite to the phone heading.
                        if (state.heading != null)
                          Transform.rotate(
                            angle: -state.heading! * math.pi / 180,
                            child: SizedBox.expand(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    top: 16,
                                    child: Text(
                                      'N',
                                      style:
                                      theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 16,
                                    child: Text(
                                      'E',
                                      style:
                                      theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    child: Text(
                                      'S',
                                      style:
                                      theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 16,
                                    child: Text(
                                      'W',
                                      style:
                                      theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Positioned(
                            top: 16,
                            child: Text(
                              'N',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        // Kaaba-direction marker rotates to the Qibla bearing.
                        if (relativeBearing != null)
                          Transform.rotate(
                            angle: relativeBearing * math.pi / 180,
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

                        // The user's position remains in the center.
                        Icon(
                          Icons.navigation,
                          size: 80,
                          color: colors.secondary,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  directionText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),

                if (state.isLoading) ...[
                  const SizedBox(height: 20),
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 8),
                  const Text(
                    'Loading location…',
                    textAlign: TextAlign.center,
                  ),
                ],

                if (!state.isLoading &&
                    state.qiblaBearing != null &&
                    state.heading == null) ...[
                  const SizedBox(height: 12),
                  Text(
                    state.compassAvailable
                        ? 'Hold the phone flat and wait for a compass reading.'
                        : 'The compass sensor is unavailable on this device.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],

                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _InfoRow(
                          label: 'Qibla bearing',
                          value: state.qiblaBearing == null
                              ? '—'
                              : '${state.qiblaBearing!.toStringAsFixed(1)}°',
                        ),
                        const Divider(height: 24),
                        _InfoRow(
                          label: 'Compass heading',
                          value: state.heading == null
                              ? '—'
                              : '${state.heading!.toStringAsFixed(1)}°',
                        ),
                        const Divider(height: 24),
                        _InfoRow(
                          label: 'Distance to Kaaba',
                          value: state.distanceKm == null
                              ? '—'
                              : '${state.distanceKm!.toStringAsFixed(0)} km',
                        ),
                      ],
                    ),
                  ),
                ),

                if (state.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.error),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          context.read<QiblaCubit>().refreshLocation();
                        },
                        child: const Text('Try again'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Geolocator.openLocationSettings();
                        },
                        child: const Text('Location settings'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Geolocator.openAppSettings();
                        },
                        child: const Text('App permissions'),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),
                Text(
                  'For better accuracy, keep the phone away from magnets '
                      'and electronic interference. Calibrate the compass if '
                      'its direction seems incorrect.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
