import 'dart:async';
import 'package:flutter/widgets.dart';

/// Manages user sessions and lifecycle events
class SessionManager with WidgetsBindingObserver {
  String? _sessionId;
  DateTime? _sessionStartTime;
  Timer? _sessionTimer;
  final Duration sessionTimeout;
  final bool debug;

  SessionManager({
    this.sessionTimeout = const Duration(minutes: 30),
    this.debug = false,
  }) {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Get or create the current session ID
  String get sessionId {
    if (_sessionId == null || _isSessionExpired()) {
      _startNewSession();
    }
    return _sessionId!;
  }

  /// Check if the current session has expired
  bool _isSessionExpired() {
    if (_sessionStartTime == null) return true;
    return DateTime.now().difference(_sessionStartTime!) > sessionTimeout;
  }

  /// Start a new session
  void _startNewSession() {
    _sessionId = _generateSessionId();
    _sessionStartTime = DateTime.now();
    _resetSessionTimer();

    if (debug) {
      print('Applytics: New session started: $_sessionId');
    }
  }

  /// Generate a unique session ID
  String _generateSessionId() {
    return '${DateTime.now().millisecondsSinceEpoch}-${DateTime.now().microsecondsSinceEpoch}';
  }

  /// Reset the session timeout timer
  void _resetSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(sessionTimeout, () {
      if (debug) {
        print('Applytics: Session expired: $_sessionId');
      }
      _sessionId = null;
      _sessionStartTime = null;
    });
  }

  /// Called when app lifecycle state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reset timer when app comes to foreground
      if (_sessionId != null && !_isSessionExpired()) {
        _resetSessionTimer();
      }
    } else if (state == AppLifecycleState.paused) {
      // Session continues in background but will expire after timeout
      if (debug) {
        print('Applytics: App paused, session will timeout');
      }
    }
  }

  /// Manually end the current session
  void endSession() {
    if (debug) {
      print('Applytics: Session ended manually: $_sessionId');
    }
    _sessionId = null;
    _sessionStartTime = null;
    _sessionTimer?.cancel();
  }

  void dispose() {
    _sessionTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }
}

