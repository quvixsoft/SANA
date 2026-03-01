
enum AppView {
  onboarding,
  login,
  dashboard,
  history,
  chat,
  report,
  labReportDetail,
  profile,
  labValidation,
  splash,
}

class LabResult {
  final String id;
  final String category;
  final String name;
  final String value;
  final String unit;
  final String status; // 'Normal' | 'Bajo' | 'Alto'
  final String referenceRange;
  final String color;

  LabResult({
    required this.id,
    required this.category,
    required this.name,
    required this.value,
    required this.unit,
    required this.status,
    required this.referenceRange,
    required this.color,
  });

  factory LabResult.fromJson(Map<String, dynamic> json) {
    return LabResult(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      unit: json['unit'] ?? '',
      status: json['status'] ?? 'Normal',
      referenceRange: json['referenceRange'] ?? '',
      color: json['color'] ?? '',
    );
  }
}

class ChatMessage {
  final String id;
  final String role; // 'user' | 'model'
  final String text;
  final String timestamp;
  final int? methodologyStep;

  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.methodologyStep,
  });

  bool get isUser => role == 'user';
}

class DiagnosticProbability {
  final String name;
  final double probability;
  final String risk; // 'Bajo' | 'Moderado' | 'Alto'
  final String description;

  DiagnosticProbability({
    required this.name,
    required this.probability,
    required this.risk,
    required this.description,
  });

  factory DiagnosticProbability.fromJson(Map<String, dynamic> json) {
    return DiagnosticProbability(
      name: json['name'] ?? '',
      probability: (json['probability'] ?? 0).toDouble(),
      risk: json['risk'] ?? 'Bajo',
      description: json['description'] ?? '',
    );
  }
}

class RecommendedStep {
  final int id;
  final String title;
  final String description;
  final String? action;
  final String icon;

  RecommendedStep({
    required this.id,
    required this.title,
    required this.description,
    this.action,
    required this.icon,
  });
}

// v0.2 New Models

class UserProfile {
  final String name;
  final int age;
  final String bloodType;
  final double height; // cm
  final double weight; // kg
  final List<String> allergies;
  final List<String> conditions;

  UserProfile({
    required this.name,
    required this.age,
    required this.bloodType,
    required this.height,
    required this.weight,
    required this.allergies,
    required this.conditions,
  });
}

enum ConsultationType {
  chat,
  labAnalysis,
}

class Consultation {
  final String id;
  final String title;
  final DateTime date;
  final String snippet;
  final ConsultationType type;

  Consultation({
    required this.id,
    required this.title,
    required this.date,
    required this.snippet,
    required this.type,
  });
}
