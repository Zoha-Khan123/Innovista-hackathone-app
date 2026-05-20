import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/analysis_provider.dart';
import 'analysis_result_screen.dart';
import '../widgets/loading_agent_widget.dart';

class ReportInputScreen extends ConsumerStatefulWidget {
  const ReportInputScreen({super.key});

  @override
  ConsumerState<ReportInputScreen> createState() => _ReportInputScreenState();
}

class _ReportInputScreenState extends ConsumerState<ReportInputScreen> {
  String _inputMode = 'text'; // 'text', 'pdf', 'url'
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  PlatformFile? _selectedFile;

  void _loadSampleData() {
    setState(() {
      _inputMode = 'text';
      _textController.text = '''Monthly Sales Report – April 2026
Sales in Karachi dropped by 28% compared to last month.
Customer feedback indicates that prices are higher than competitors.
Website analytics show a 35% increase in cart abandonment.
Fuel prices increased by 12%, raising delivery costs.
At the same time, Lahore experienced a 15% increase in orders after running a 10% discount campaign.''';
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _analyzeData() {
    if (_inputMode == 'text' && _textController.text.trim().isEmpty) {
      _showError('Please enter a business report.');
      return;
    }
    if (_inputMode == 'url' && _urlController.text.trim().isEmpty) {
      _showError('Please enter a valid URL.');
      return;
    }
    if (_inputMode == 'pdf' && _selectedFile == null) {
      _showError('Please select a PDF file first.');
      return;
    }

    ref.read(analysisStateProvider.notifier).analyzeData(
      inputType: _inputMode,
      rawData: _textController.text,
      url: _urlController.text,
      file: _selectedFile,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final analysisState = ref.watch(analysisStateProvider);

    ref.listen(analysisStateProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisResultScreen(response: next.value!),
          ),
        );
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed: ${next.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    if (analysisState is AsyncLoading) {
      return const LoadingAgentWidget();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Analysis'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Ingestion',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your input source. The agent will automatically extract, clean, and analyze the data.',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 24),
              
              // Input Mode Toggle
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'text', label: Text('Text'), icon: Icon(Icons.text_fields)),
                    ButtonSegment(value: 'pdf', label: Text('PDF File'), icon: Icon(Icons.picture_as_pdf)),
                    ButtonSegment(value: 'url', label: Text('Website URL'), icon: Icon(Icons.link)),
                  ],
                  selected: {_inputMode},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _inputMode = newSelection.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Dynamic Input Area
              Expanded(
                child: _buildInputArea(),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _loadSampleData,
                    icon: const Icon(Icons.description),
                    label: const Text('Sample Data'),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _analyzeData,
                      icon: const Icon(Icons.smart_toy),
                      label: const Text('Run Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    if (_inputMode == 'text') {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)),
        ),
        child: TextField(
          controller: _textController,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            hintText: 'Paste raw text or notes...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(20),
          ),
        ),
      );
    } else if (_inputMode == 'url') {
      return Column(
        children: [
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: 'Article or Website URL',
              hintText: 'https://example.com/report',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.public),
            ),
          ),
        ],
      );
    } else {
      // PDF Mode
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upload_file, size: 64, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.folder_open),
              label: const Text('Select PDF Document'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.primary,
                elevation: 0,
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            if (_selectedFile != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      _selectedFile!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              )
            ]
          ],
        ),
      );
    }
  }
}
