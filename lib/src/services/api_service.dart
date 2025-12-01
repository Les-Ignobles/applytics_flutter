import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/analytics_event.dart';
import '../models/analytics_config.dart';

/// Service responsible for sending analytics events to the API
class ApiService {
  final AnalyticsConfig config;
  final http.Client _client;

  ApiService({
    required this.config,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Send a single event to the API
  Future<bool> sendEvent(AnalyticsEvent event) async {
    try {
      final url = Uri.parse(config.apiUrl);
      final response = await _client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'x-applytics-key': config.apiKey,
            },
            body: jsonEncode(event.toJson()),
          )
          .timeout(Duration(seconds: config.timeoutSeconds));

      if (config.debug) {
        print('Applytics: Sent event: ${event.name}. Status: ${response.statusCode}');
        print('Applytics: Response body: ${response.body}');
      }

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      if (config.debug) {
        print('Applytics: Error sending event: $e');
      }
      return false;
    }
  }

  /// Send multiple events in a batch to the API
  Future<bool> sendEvents(List<AnalyticsEvent> events) async {
    if (events.isEmpty) return true;

    // Send events one by one since the API doesn't support batching
    bool allSuccess = true;
    for (final event in events) {
      final success = await sendEvent(event);
      if (!success) {
        allSuccess = false;
      }
    }

    return allSuccess;
  }

  /// Test the API connection
  Future<bool> testConnection() async {
    try {
      final url = Uri.parse('${config.apiUrl}/health');
      final response = await _client
          .get(
            url,
            headers: {
              'Authorization': 'Bearer ${config.apiKey}',
            },
          )
          .timeout(Duration(seconds: config.timeoutSeconds));

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      if (config.debug) {
        print('Applytics: Error testing connection: $e');
      }
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}
