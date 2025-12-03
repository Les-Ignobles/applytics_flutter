import 'package:flutter/material.dart';
import 'package:applytics_flutter/applytics_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Applytics
  ApplyticsClient.initialize(
    config: AnalyticsConfig(
      apiKey: 'your-api-key',
      debug: true, // Enable debug logs
      batchSize: 10, // Send events in batches of 10
      flushIntervalSeconds: 30, // Or every 30 seconds
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Applytics Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _analytics = ApplyticsClient.instance;
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    // Track screen view
    _analytics.track('screen_view', properties: {
      'screen_name': 'home',
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Track button click event
    _analytics.track('button_clicked', properties: {
      'button_name': 'increment',
      'counter_value': _counter,
    });
  }

  void _identifyUser() {
    // Identify the user
    _analytics.identify('user_123', userProperties: {
      'name': 'John Doe',
      'email': 'john@example.com',
      'plan': 'premium',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User identified!')),
    );
  }

  void _testConnection() async {
    final isConnected = await _analytics.testConnection();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isConnected
            ? 'Connection successful!'
            : 'Connection failed',
        ),
        backgroundColor: isConnected ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applytics Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _identifyUser,
              child: const Text('Identify User'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testConnection,
              child: const Text('Test Connection'),
            ),
            const SizedBox(height: 16),
            Text(
              'Queue size: ${_analytics.queueSize}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Session ID: ${_analytics.sessionId ?? "N/A"}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

