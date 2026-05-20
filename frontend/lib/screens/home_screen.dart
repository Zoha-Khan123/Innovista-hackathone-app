import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'report_input_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InsightFlow Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
            tooltip: 'History',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transform Business Reports into Actions',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.1),
                    const SizedBox(height: 16),
                    Text(
                      'The Google Antigravity autonomous agent analyzes your unstructured data, extracts insights, and executes simulations.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ReportInputScreen()),
                          );
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text(
                          'Analyze New Report',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),
                    const SizedBox(height: 48),
                    const Text(
                      'System Overview',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Reports',
                            value: '24',
                            icon: Icons.description,
                            color: AppTheme.primaryBlue,
                            delay: 600,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Actions',
                            value: '18',
                            icon: Icons.show_chart,
                            color: AppTheme.secondaryEmerald,
                            delay: 700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _StatCard(
                      title: 'Revenue Protected (Est.)',
                      value: '\$142,500',
                      icon: Icons.trending_up,
                      color: AppTheme.warningAmber[600]!,
                      delay: 800,
                      isWide: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;
  final bool isWide;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                if (isWide) const SizedBox(width: 12),
                if (isWide) Text(title, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            if (!isWide) const SizedBox(height: 4),
            if (!isWide)
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.1);
  }
}
