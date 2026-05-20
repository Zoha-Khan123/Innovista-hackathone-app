import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class LoadingAgentWidget extends StatefulWidget {
  const LoadingAgentWidget({super.key});

  @override
  State<LoadingAgentWidget> createState() => _LoadingAgentWidgetState();
}

class _LoadingAgentWidgetState extends State<LoadingAgentWidget> {
  final List<String> _steps = [
    "Preprocessing unstructured text...",
    "Extracting factual metrics...",
    "Generating business insights...",
    "Calculating business impact...",
    "Formulating recommended action...",
    "Simulating action execution in backend...",
    "Compiling resulting state..."
  ];
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _cycleSteps();
  }

  Future<void> _cycleSteps() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() => _currentStep = i);
      await Future.delayed(const Duration(milliseconds: 1800));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.smart_toy, size: 64, color: Color(0xFF1E3A8A))
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 1500.ms)
                .scaleXY(end: 1.1, duration: 800.ms, curve: Curves.easeInOut)
                .then()
                .scaleXY(end: 1 / 1.1, duration: 800.ms, curve: Curves.easeInOut),
            const SizedBox(height: 32),
            const Text(
              'Agent Analyzing...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                _steps[_currentStep],
                key: ValueKey<int>(_currentStep),
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
