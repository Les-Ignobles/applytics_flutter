import 'dart:async';
import '../models/analytics_event.dart';
import '../models/analytics_config.dart';
import 'api_service.dart';

/// Manages a queue of events and handles batching/flushing
class EventQueue {
  final AnalyticsConfig config;
  final ApiService apiService;
  final List<AnalyticsEvent> _queue = [];
  Timer? _flushTimer;
  bool _isFlushing = false;

  EventQueue({
    required this.config,
    required this.apiService,
  }) {
    _startFlushTimer();
  }

  /// Add an event to the queue
  void enqueue(AnalyticsEvent event) {
    _queue.add(event);

    if (config.debug) {
      print('Applytics: Event queued: ${event.name} (Queue size: ${_queue.length})');
    }

    // Auto-flush if batch size is reached
    if (_queue.length >= config.batchSize) {
      flush();
    }
  }

  /// Start the periodic flush timer
  void _startFlushTimer() {
    _flushTimer?.cancel();
    _flushTimer = Timer.periodic(
      Duration(seconds: config.flushIntervalSeconds),
      (_) => flush(),
    );
  }

  /// Flush all queued events to the API
  Future<void> flush() async {
    if (_isFlushing || _queue.isEmpty) return;

    _isFlushing = true;

    try {
      final eventsToSend = List<AnalyticsEvent>.from(_queue);
      _queue.clear();

      final success = await apiService.sendEvents(eventsToSend);

      if (!success) {
        // Re-queue events if sending failed
        _queue.insertAll(0, eventsToSend);

        if (config.debug) {
          print('Applytics: Failed to send events, re-queued');
        }
      }
    } finally {
      _isFlushing = false;
    }
  }

  /// Get the current queue size
  int get queueSize => _queue.length;

  /// Clear the queue without sending
  void clear() {
    _queue.clear();
  }

  /// Dispose resources
  void dispose() {
    _flushTimer?.cancel();
    _queue.clear();
  }
}

