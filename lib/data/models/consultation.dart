/// Consultation Type Enum
enum ConsultationType {
  chat,
  labAnalysis,
}

/// Consultation Model - Database ready
class Consultation {
  final String id;
  final String title;
  final DateTime date;
  final String snippet;
  final ConsultationType type;
  final String? userId;

  Consultation({
    required this.id,
    required this.title,
    required this.date,
    required this.snippet,
    required this.type,
    this.userId,
  });

  /// JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'snippet': snippet,
      'type': type.toString().split('.').last,
      'userId': userId,
    };
  }

  /// JSON deserialization
  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      snippet: json['snippet'] ?? '',
      type: ConsultationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ConsultationType.chat,
      ),
      userId: json['userId'],
    );
  }
}
