
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../bloc/qibla/qibla_cubit.dart';
import '../bloc/qibla/qibla_state.dart';
import '../widgets/qiblaCompassDial.dart';
import '../widgets/qiblaDirectionText.dart';
import '../widgets/qiblaInfoCard.dart';

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
  // Prevents duplicate initialization when dependencies or widgets update.
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

    // Wait until the current frame finishes before accessing the Cubit.
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
            // The compass heading is the direction the phone faces.
            // Subtract it from the geographic Qibla bearing to find
            // the direction the marker should point relative to the phone.
            final relativeBearing =
            state.qiblaBearing != null && state.heading != null
                ? (state.qiblaBearing! - state.heading! + 360) % 360
                : null;

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

                // The screen passes values to the dial; the dial
                // does not need to know about the Cubit.
                QiblaCompassDial(
                  heading: state.heading,
                  relativeBearing: relativeBearing,
                ),

                const SizedBox(height: 24),

                QiblaDirectionText(
                  relativeBearing: relativeBearing,
                  isLoading: state.isLoading,
                ),

                if (state.isLoading) ...[
                  const SizedBox(height: 20),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Loading location…',
                    textAlign: TextAlign.center,
                  ),
                ],

                // A location can be available even if the compass sensor
                // has not produced a usable heading.
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

                QiblaInfoCard(
                  qiblaBearing: state.qiblaBearing,
                  heading: state.heading,
                  distanceKm: state.distanceKm,
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
