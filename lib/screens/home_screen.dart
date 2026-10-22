
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/bloc/theme/theme_cubit.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const HomeScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.darkSurface
                        : AppTheme.paleGold,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.nightlight_round,
                    color: isDark
                        ? AppTheme.gold
                        : AppTheme.forestGreen,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Islamic Companion',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Your daily worship, in one place',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isDark
                      ? 'Switch to light mode'
                      : 'Switch to dark mode',
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  icon: Icon(
                    isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Text(
              'السلام عليكم',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.left,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'What would you like to do today?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),

            // Featured Quran card.
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.forestGreen,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 32,
                    color: AppTheme.gold,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reconnect with the Quran',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Read, listen, and return to your reading '
                        'whenever you like.',
                    style: TextStyle(
                      color: Color(0xFFDCE8E1),
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 44,
                    child: FilledButton(
                      onPressed: () => onNavigate(1),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        foregroundColor: AppTheme.deepGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Open Quran',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Text(
              'Your essentials',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _FeatureCard(
                    title: 'Prayer Times',
                    subtitle: 'Daily schedule',
                    icon: Icons.access_time_rounded,
                    onTap: () => onNavigate(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FeatureCard(
                    title: 'Qibla Compass',
                    subtitle: 'Find the direction of the Kaaba',
                    icon: Icons.explore_rounded,
                    onTap: () => onNavigate(3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.dividerColor,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.offline_pin_rounded,
                    color: theme.colorScheme.primary,
                    size: 25,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Designed for offline use',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'The Quran reader and saved location '
                              'settings help keep essential features '
                              'available without an internet connection.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.darkBorder
                      : AppTheme.paleGold,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isDark
                      ? AppTheme.gold
                      : AppTheme.forestGreen,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
