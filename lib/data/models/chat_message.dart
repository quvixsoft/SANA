/// Chat Message Model - Database ready with persistence support
class ChatMessage {
  final String id;
  final String role; // 'user' | 'model'
  final String text;
  final DateTime timestamp;
  final int? methodologyStep;
  final String? conversationId;

  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.methodologyStep,
    this.conversationId,
  });

  bool get isUser => role == 'user';
  bool get isModel => role == 'model';

  /// JSON serialization for database/local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'methodologyStep': methodologyStep,
      'conversationId': conversationId,
    };
  }

  /// JSON deserialization
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      role: json['role'] ?? 'user',
      text: json['text'] ?? '',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      methodologyStep: json['methodologyStep'],
      conversationId: json['conversationId'],
    );
  }

  /// Create user message
  factory ChatMessage.user({
    required String id,
    required String text,
    String? conversationId,
  }) {
    return ChatMessage(
      id: id,
      role: 'user',
      text: text,
      timestamp: DateTime.now(),
      conversationId: conversationId,
    );
  }

  /// Create model message
  factory ChatMessage.model({
    required String id,
    required String text,
    int? methodologyStep,
    String? conversationId,
  }) {
    return ChatMessage(
      id: id,
      role: 'model',
      text: text,
      timestamp: DateTime.now(),
      methodologyStep: methodologyStep,
      conversationId: conversationId,
    );
  }
}
