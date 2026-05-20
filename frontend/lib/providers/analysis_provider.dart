import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../models/analysis_response.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final analysisStateProvider = StateNotifierProvider<AnalysisNotifier, AsyncValue<AnalysisResponse?>>((ref) {
  return AnalysisNotifier(ref.read(apiServiceProvider));
});

class AnalysisNotifier extends StateNotifier<AsyncValue<AnalysisResponse?>> {
  final ApiService _apiService;

  AnalysisNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<void> analyzeData({
    required String inputType,
    String? rawData,
    String? url,
    PlatformFile? file,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _apiService.analyzeData(
        inputType: inputType,
        rawData: rawData,
        url: url,
        file: file,
      );
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
