import 'dart:async';
import 'models/analytics_event.dart';
import 'models/analytics_config.dart';
import 'services/api_service.dart';
import 'services/event_queue.dart';
import 'services/session_manager.dart';
import 'services/device_info_service.dart';

/// Main Applytics client for tracking analytics events
class ApplyticsClient {
  static ApplyticsClient? _instance;

  final AnalyticsConfig config;
  late final ApiService _apiService;
  late final EventQueue _eventQueue;
  late final SessionManager? _sessionManager;
  late final DeviceInfoService _deviceInfoService;

  String? _userId;
  bool _isInitialized = false;
  Map<String, dynamic>? _deviceInfo;

  ApplyticsClient._internal({
    required this.config,
  }) {
    _apiService = ApiService(config: config);
    _eventQueue = EventQueue(
      config: config,
      apiService: _apiService,
    );

    if (config.enableSessionTracking) {
      _sessionManager = SessionManager(
        debug: config.debug,
      );
    }

    _deviceInfoService = DeviceInfoService.instance;

    // Collect device info asynchronously
    _collectDeviceInfo();

    _isInitialized = true;

    if (config.debug) {
      print('Applytics: Client initialized with API URL: ${config.apiUrl}');
    }
  }

  /// Collect device information
  Future<void> _collectDeviceInfo() async {
    try {
      _deviceInfo = await _deviceInfoService.getDeviceInfo();
      if (config.debug) {
        print('Applytics: Device info collected: $_deviceInfo');
      }
    } catch (e) {
      if (config.debug) {
        print('Applytics: Failed to collect device info: $e');
      }
    }
  }

  /// Initialize the Applytics client (singleton)
  factory ApplyticsClient.initialize({
    required AnalyticsConfig config,
  }) {
    _instance = ApplyticsClient._internal(config: config);
    return _instance!;
  }

  /// Get the singleton instance
  static ApplyticsClient get instance {
    if (_instance == null) {
      throw StateError(
        'ApplyticsClient has not been initialized. Call ApplyticsClient.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Check if the client is initialized
  static bool get isInitialized => _instance?._isInitialized ?? false;

  /// Track an event
  Future<void> track(
    String eventName, {
    Map<String, dynamic>? properties,
  }) async {
    if (!_isInitialized) {
      throw StateError('ApplyticsClient is not initialized');
    }

    final event = AnalyticsEvent(
      name: eventName,
      properties: properties,
      userId: _userId,
      sessionId: _sessionManager?.sessionId,
      deviceInfo: _deviceInfo,
    );

    _eventQueue.enqueue(event);

    if (config.debug) {
      print('Applytics: Tracked event "$eventName" with properties: $properties');
    }
  }

  /// Identify a user
  void identify(String userId, {Map<String, dynamic>? userProperties}) {
    _userId = userId;

    if (config.debug) {
      print('Applytics: User identified: $userId');
    }

    // Track identify event
    track('identify', properties: {
      'user_id': userId,
      if (userProperties != null) 'user_properties': userProperties,
    });
  }

  /// Reset the user identity (useful for logout)
  void reset() {
    _userId = null;
    _sessionManager?.endSession();

    if (config.debug) {
      print('Applytics: User identity reset');
    }
  }

  /// Get the current user ID
  String? get userId => _userId;

  /// Get the current session ID
  String? get sessionId => _sessionManager?.sessionId;

  /// Manually flush all queued events
  Future<void> flush() async {
    await _eventQueue.flush();
  }

  /// Get the current queue size
  int get queueSize => _eventQueue.queueSize;

  /// Test the API connection
  Future<bool> testConnection() async {
    return await _apiService.testConnection();
  }

  /// Dispose and clean up resources
  Future<void> dispose() async {
    await flush();
    _eventQueue.dispose();
    _sessionManager?.dispose();
    _apiService.dispose();
    _isInitialized = false;

    if (config.debug) {
      print('Applytics: Client disposed');
    }
  }
}
