import 'package:flutter_test/flutter_test.dart';
import 'package:applytics_flutter/applytics_flutter.dart';

void main() {
  group('AnalyticsEvent', () {
    test('should create event with required fields', () {
      final event = AnalyticsEvent(name: 'test_event');

      expect(event.name, 'test_event');
      expect(event.properties, isNull);
      expect(event.userId, isNull);
      expect(event.sessionId, isNull);
      expect(event.createdAt, isA<DateTime>());
    });

    test('should create event with all fields', () {
      final createdAt = DateTime.now();
      final event = AnalyticsEvent(
        name: 'test_event',
        properties: {'key': 'value'},
        userId: 'user_123',
        sessionId: 'session_456',
        createdAt: createdAt,
      );

      expect(event.name, 'test_event');
      expect(event.properties, {'key': 'value'});
      expect(event.userId, 'user_123');
      expect(event.sessionId, 'session_456');
      expect(event.createdAt, createdAt);
    });

    test('should convert to JSON correctly', () {
      final event = AnalyticsEvent(
        name: 'test_event',
        properties: {'count': 42},
        userId: 'user_123',
      );

      final json = event.toJson();

      expect(json['name'], 'test_event');
      expect(json['properties'], {'count': 42});
      expect(json['user_id'], 'user_123');
      expect(json['created_at'], isA<String>());
    });

    test('should create from JSON correctly', () {
      final json = {
        'name': 'test_event',
        'properties': {'count': 42},
        'user_id': 'user_123',
        'session_id': 'session_456',
        'timestamp': '2025-12-01T10:00:00.000Z',
      };

      final event = AnalyticsEvent.fromJson(json);

      expect(event.name, 'test_event');
      expect(event.properties, {'count': 42});
      expect(event.userId, 'user_123');
      expect(event.sessionId, 'session_456');
    });
  });

  group('AnalyticsConfig', () {
    test('should create config with required fields', () {
      final config = AnalyticsConfig(
        apiKey: 'test_key',
      );

      expect(config.apiKey, 'test_key');
      expect(config.debug, false);
      expect(config.batchSize, 10);
      expect(config.flushIntervalSeconds, 30);
      expect(config.timeoutSeconds, 10);
      expect(config.enableSessionTracking, true);
    });

    test('should create config with custom values', () {
      final config = AnalyticsConfig(
        apiKey: 'test_key',
        debug: true,
        batchSize: 5,
        flushIntervalSeconds: 60,
        timeoutSeconds: 20,
        enableSessionTracking: false,
      );

      expect(config.debug, true);
      expect(config.batchSize, 5);
      expect(config.flushIntervalSeconds, 60);
      expect(config.timeoutSeconds, 20);
      expect(config.enableSessionTracking, false);
    });

    test('should copy config with changes', () {
      final config = AnalyticsConfig(
        apiKey: 'test_key',
      );

      final newConfig = config.copyWith(
        debug: true,
        batchSize: 20,
      );

      expect(newConfig.apiKey, 'test_key');
      expect(newConfig.debug, true);
      expect(newConfig.batchSize, 20);
      expect(newConfig.flushIntervalSeconds, 30); // unchanged
    });
  });

  group('ApplyticsClient', () {
    tearDown(() {
      // Reset singleton between tests
      if (ApplyticsClient.isInitialized) {
        ApplyticsClient.instance.dispose();
      }
    });

    test('should throw error when not initialized', () {
      expect(
        () => ApplyticsClient.instance,
        throwsA(isA<StateError>()),
      );
    });

    test('should initialize successfully', () {
      final client = ApplyticsClient.initialize(
        config: AnalyticsConfig(
          apiKey: 'test_key',
        ),
      );

      expect(client, isNotNull);
      expect(ApplyticsClient.isInitialized, true);
    });

    test('should track user identity', () {
      ApplyticsClient.initialize(
        config: AnalyticsConfig(
          apiKey: 'test_key',
        ),
      );

      final client = ApplyticsClient.instance;

      expect(client.userId, isNull);

      client.identify('user_123');

      expect(client.userId, 'user_123');
    });

    test('should reset user identity', () {
      ApplyticsClient.initialize(
        config: AnalyticsConfig(
          apiKey: 'test_key',
        ),
      );

      final client = ApplyticsClient.instance;
      client.identify('user_123');

      expect(client.userId, 'user_123');

      client.reset();

      expect(client.userId, isNull);
    });
  });
}
