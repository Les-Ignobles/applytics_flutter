/// Configuration for the Applytics client
class AnalyticsConfig {
  /// The API endpoint URL where events will be sent
  final String apiUrl;

  /// API key for authentication
  final String apiKey;

  /// Enable debug logging
  final bool debug;

  /// Batch size - number of events to accumulate before sending
  final int batchSize;

  /// Flush interval in seconds - how often to send batched events
  final int flushIntervalSeconds;

  /// Timeout for API requests in seconds
  final int timeoutSeconds;

  /// Enable automatic session tracking
  final bool enableSessionTracking;

  const AnalyticsConfig({
    required this.apiUrl,
    required this.apiKey,
    this.debug = false,
    this.batchSize = 10,
    this.flushIntervalSeconds = 30,
    this.timeoutSeconds = 10,
    this.enableSessionTracking = true,
  });

  AnalyticsConfig copyWith({
    String? apiUrl,
    String? apiKey,
    bool? debug,
    int? batchSize,
    int? flushIntervalSeconds,
    int? timeoutSeconds,
    bool? enableSessionTracking,
  }) {
    return AnalyticsConfig(
      apiUrl: apiUrl ?? this.apiUrl,
      apiKey: apiKey ?? this.apiKey,
      debug: debug ?? this.debug,
      batchSize: batchSize ?? this.batchSize,
      flushIntervalSeconds: flushIntervalSeconds ?? this.flushIntervalSeconds,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      enableSessionTracking: enableSessionTracking ?? this.enableSessionTracking,
    );
  }
}

