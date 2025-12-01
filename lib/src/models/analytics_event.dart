/// Represents an analytics event to be sent to the server
class AnalyticsEvent {
  final String name;
  final Map<String, dynamic>? properties;
  final DateTime timestamp;
  final String? userId;
  final String? sessionId;

  AnalyticsEvent({
    required this.name,
    this.properties,
    DateTime? timestamp,
    this.userId,
    this.sessionId,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Convert the event to JSON format for API calls
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'properties': properties ?? {},
      'timestamp': timestamp.toIso8601String(),
      if (userId != null) 'user_id': userId,
      if (sessionId != null) 'session_id': sessionId,
    };
  }

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvent(
      name: json['name'] as String,
      properties: json['properties'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['user_id'] as String?,
      sessionId: json['session_id'] as String?,
    );
  }
}

