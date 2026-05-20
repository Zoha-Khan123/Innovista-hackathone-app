class AnalysisResponse {
  final String originalInput;
  final List<String> factsExtracted;
  final List<String> insights;
  final String impactAnalysis;
  final String recommendedAction;
  final ActionSimulation actionSimulation;
  final Map<String, dynamic> resultingState;

  AnalysisResponse({
    required this.originalInput,
    required this.factsExtracted,
    required this.insights,
    required this.impactAnalysis,
    required this.recommendedAction,
    required this.actionSimulation,
    required this.resultingState,
  });

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisResponse(
      originalInput: json['original_input'] ?? '',
      factsExtracted: List<String>.from(json['facts_extracted'] ?? []),
      insights: List<String>.from(json['insights'] ?? []),
      impactAnalysis: json['impact_analysis'] ?? '',
      recommendedAction: json['recommended_action'] ?? '',
      actionSimulation: ActionSimulation.fromJson(json['action_simulation'] ?? {}),
      resultingState: Map<String, dynamic>.from(json['resulting_state'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original_input': originalInput,
      'facts_extracted': factsExtracted,
      'insights': insights,
      'impact_analysis': impactAnalysis,
      'recommended_action': recommendedAction,
      'action_simulation': actionSimulation.toJson(),
      'resulting_state': resultingState,
    };
  }
}

class ActionSimulation {
  final String status;
  final List<String> executedSteps;

  ActionSimulation({
    required this.status,
    required this.executedSteps,
  });

  factory ActionSimulation.fromJson(Map<String, dynamic> json) {
    return ActionSimulation(
      status: json['status'] ?? '',
      executedSteps: List<String>.from(json['executed_steps'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'executed_steps': executedSteps,
    };
  }
}
