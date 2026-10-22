
import 'package:flutter/material.dart';

import '../theme.dart';

class FeaturePlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;

  const FeaturePlaceholderScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppTheme.paleGold,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Icon(
                    icon,
                    size: 46,
                    color: AppTheme.forestGreen,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: AppTheme.secondaryText,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppTheme.border,
                    ),
                  ),
                  child: const Text(
                    'Feature setup pending',
                    style: TextStyle(
                      color: AppTheme.forestGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
