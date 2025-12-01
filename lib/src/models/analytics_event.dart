/// Represents an analytics event to be sent to the server
class AnalyticsEvent {
  final String name;
  final Map<String, dynamic>? properties;
  final DateTime createdAt;
  final String? userId;
  final String? sessionId;
  final Map<String, dynamic>? deviceInfo;

  AnalyticsEvent({
    required this.name,
    this.properties,
    DateTime? createdAt,
    this.userId,
    this.sessionId,
    this.deviceInfo,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Convert the event to JSON format for API calls
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'properties': properties ?? {},
      'created_at': createdAt.toIso8601String(),
      if (userId != null) 'user_id': userId,
      if (sessionId != null) 'session_id': sessionId,
      if (deviceInfo != null) 'device_info': deviceInfo,
    };
  }

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvent(
      name: json['name'] as String,
      properties: json['properties'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String?,
      sessionId: json['session_id'] as String?,
      deviceInfo: json['device_info'] as Map<String, dynamic>?,
    );
  }
}
