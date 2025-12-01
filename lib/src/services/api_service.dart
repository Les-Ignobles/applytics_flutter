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
    return sendEvents([event]);
  }

  /// Send multiple events in a batch to the API
  Future<bool> sendEvents(List<AnalyticsEvent> events) async {
    if (events.isEmpty) return true;

    try {
      final url = Uri.parse('${config.apiUrl}/events');
      final response = await _client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${config.apiKey}',
            },
            body: jsonEncode({
              'events': events.map((e) => e.toJson()).toList(),
            }),
          )
          .timeout(Duration(seconds: config.timeoutSeconds));

      if (config.debug) {
        print('Applytics: Sent ${events.length} events. Status: ${response.statusCode}');
      }

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      if (config.debug) {
        print('Applytics: Error sending events: $e');
      }
      return false;
    }
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

