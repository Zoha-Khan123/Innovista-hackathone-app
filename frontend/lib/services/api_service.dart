import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/analysis_response.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

class ApiService {
  static String get baseUrl {
    // Return the live Google Cloud Run backend URL for all platforms
    return 'https://ai-seekho-backend-898376815936.us-central1.run.app';
  }

  Future<AnalysisResponse> analyzeData({
    required String inputType,
    String? rawData,
    String? url,
    PlatformFile? file,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/analyze'));
      
      request.fields['input_type'] = inputType;
      
      if (inputType == 'text' && rawData != null) {
        request.fields['raw_data'] = rawData;
      } else if (inputType == 'url' && url != null) {
        request.fields['url'] = url;
      } else if (inputType == 'pdf' && file != null) {
        if (kIsWeb && file.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes('file', file.bytes!, filename: file.name));
        } else if (file.path != null) {
          request.files.add(await http.MultipartFile.fromPath('file', file.path!));
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AnalysisResponse.fromJson(data);
      } else {
        throw Exception('Failed to analyze: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
