
import 'package:flutter/material.dart';

import '../theme.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const HomeScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.paleGold,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.nightlight_round,
                    color: AppTheme.forestGreen,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Islamic Companion',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.forestGreen,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Your daily worship, in one place',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            const Text(
              'Assalamu Alaikum',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'What would you like to do today?',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryText,
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
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
                    'Read, listen, and return to your '
                        'reading whenever you like.',
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
                          borderRadius:
                          BorderRadius.circular(12),
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
            const SizedBox(height: 24),

            const Text(
              'Your essentials',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _FeatureCard(
                    title: 'Hadith',
                    subtitle: 'Read collections',
                    icon: Icons.auto_stories_rounded,
                    onTap: () => onNavigate(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FeatureCard(
                    title: 'Prayer Times',
                    subtitle: 'Daily schedule',
                    icon: Icons.access_time_rounded,
                    onTap: () => onNavigate(3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              title: 'Qibla Compass',
              subtitle: 'Find the direction of the Kaaba',
              icon: Icons.explore_rounded,
              onTap: () => onNavigate(4),
              horizontal: true,
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.border,
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.offline_pin_rounded,
                    color: AppTheme.mediumGreen,
                    size: 25,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Designed for offline use',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryText,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'The Quran reader and downloaded '
                              'content can remain available '
                              'without an internet connection.',
                          style: TextStyle(
                            color: AppTheme.secondaryText,
                            height: 1.5,
                            fontSize: 12,
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
  final bool horizontal;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: horizontal
              ? Row(
            children: [
              _icon(),
              const SizedBox(width: 14),
              Expanded(child: _labels()),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: AppTheme.secondaryText,
              ),
            ],
          )
              : Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _icon(),
              const SizedBox(height: 16),
              _labels(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.paleGold,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: AppTheme.forestGreen,
        size: 24,
      ),
    );
  }

  Widget _labels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
