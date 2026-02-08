/// Lab Result Model - Database ready
class LabResult {
  final String id;
  final String category;
  final String name;
  final String value;
  final String unit;
  final String status; // 'Normal' | 'Bajo' | 'Alto'
  final String referenceRange;
  final String color;
  final DateTime? testDate;
  final String? userId;

  LabResult({
    required this.id,
    required this.category,
    required this.name,
    required this.value,
    required this.unit,
    required this.status,
    required this.referenceRange,
    required this.color,
    this.testDate,
    this.userId,
  });

  /// JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'value': value,
      'unit': unit,
      'status': status,
      'referenceRange': referenceRange,
      'color': color,
      'testDate': testDate?.toIso8601String(),
      'userId': userId,
    };
  }

  /// JSON deserialization
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
      testDate: json['testDate'] != null 
          ? DateTime.parse(json['testDate']) 
          : null,
      userId: json['userId'],
    );
  }

  /// Check if result is abnormal
  bool get isAbnormal => status != 'Normal';
}
