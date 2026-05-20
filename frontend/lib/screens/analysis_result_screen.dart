import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/analysis_response.dart';
import '../widgets/section_card.dart';
import '../theme/app_theme.dart';

class AnalysisResultScreen extends StatelessWidget {
  final AnalysisResponse response;

  const AnalysisResultScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSuccessBanner(context).animate().fadeIn().slideY(begin: -0.2),
                  const SizedBox(height: 24),
                  SectionCard(
                    title: 'Original Input',
                    icon: Icons.description,
                    iconColor: Colors.grey[600]!,
                    initiallyExpanded: false,
                    child: Text(
                      response.originalInput,
                      style: TextStyle(height: 1.6, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)),
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
                  
                  SectionCard(
                    title: 'Extracted Facts',
                    icon: Icons.bar_chart,
                    iconColor: AppTheme.primaryBlue,
                    child: Column(
                      children: response.factsExtracted.asMap().entries.map((e) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${e.key + 1}. ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Expanded(child: Text(e.value, style: const TextStyle(fontSize: 16, height: 1.5))),
                            ],
                          ),
                        )
                      ).toList(),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                  SectionCard(
                    title: 'Key Insights',
                    icon: Icons.lightbulb,
                    iconColor: AppTheme.warningAmber[600]!,
                    child: Column(
                      children: response.insights.map((insight) => 
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.warningAmber[600]!.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.warningAmber[600]!.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.bolt, color: AppTheme.warningAmber[700]!, size: 20),
                              const SizedBox(width: 12),
                              Expanded(child: Text(insight, style: const TextStyle(fontSize: 15, height: 1.5))),
                            ],
                          ),
                        )
                      ).toList(),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                  SectionCard(
                    title: 'Impact Analysis',
                    icon: Icons.warning_amber,
                    iconColor: AppTheme.errorRed,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.errorRed.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        response.impactAnalysis,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                  SectionCard(
                    title: 'Recommended Action',
                    icon: Icons.track_changes,
                    iconColor: AppTheme.primaryBlue,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryBlue, AppTheme.primaryBlue.withValues(alpha: 0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
                              ),
                              const SizedBox(width: 12),
                              const Text('EXECUTIVE ACTION PLAN', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            response.recommendedAction,
                            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),

                  SectionCard(
                    title: 'Action Simulation Trace',
                    icon: Icons.terminal,
                    iconColor: Colors.deepPurple,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppTheme.secondaryEmerald.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle, color: AppTheme.secondaryEmerald, size: 16),
                              const SizedBox(width: 8),
                              Text('Status: ${response.actionSimulation.status}', style: const TextStyle(color: AppTheme.secondaryEmerald, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...response.actionSimulation.executedSteps.asMap().entries.map((e) => 
                          _buildTimelineStep(context, e.value, isLast: e.key == response.actionSimulation.executedSteps.length - 1)
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),

                  SectionCard(
                    title: 'Projected Resulting State',
                    icon: Icons.trending_up,
                    iconColor: AppTheme.secondaryEmerald,
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: response.resultingState.entries.map((e) => 
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 88) / 2, // 2 columns
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatKey(e.key),
                                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  e.value.toString(),
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.secondaryEmerald),
                                ),
                              ],
                            ),
                          ),
                        )
                      ).toList(),
                    ),
                  ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryEmerald,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Simulation Executed Successfully', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text('The agent has formulated and tested the plan.', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(BuildContext context, String text, {required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.deepPurple.withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, fontFamily: 'monospace'),
            ),
          ),
        ),
      ],
    );
  }

  String _formatKey(String key) {
    return key.split('_').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ');
  }
}
