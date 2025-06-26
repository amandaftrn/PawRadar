import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:isolate';

class ThreadsAsyncScreen extends StatefulWidget {
  const ThreadsAsyncScreen({Key? key}) : super(key: key);

  @override
  _ThreadsAsyncScreenState createState() => _ThreadsAsyncScreenState();
}

class _ThreadsAsyncScreenState extends State<ThreadsAsyncScreen> {
  List<String> _logs = [];
  bool _isRunning = false;
  int _counter = 0;
  Timer? _periodicTimer;
  ScrollController _scrollController = ScrollController();

  // Future demo variables
  String _futureResult = '';
  bool _futureLoading = false;

  // Stream demo variables
  StreamController<int>? _streamController;
  Stream<int>? _numberStream;
  StreamSubscription<int>? _streamSubscription;
  List<int> _streamNumbers = [];

  // Isolate demo variables
  Isolate? _isolate;
  bool _isolateRunning = false;
  String _isolateResult = '';

  @override
  void initState() {
    super.initState();
    _addLog('ThreadsAsync Demo initialized');
    _initializeStream();
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    _streamController?.close();
    _streamSubscription?.cancel();
    _isolate?.kill();
    super.dispose();
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  // Basic async operations
  void _startAsyncOperations() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _counter = 0;
    });

    _addLog('Starting async operations...');

    // Simulate periodic async work
    _periodicTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!_isRunning) {
        timer.cancel();
        return;
      }

      _counter++;
      _addLog('Async operation #$_counter completed');

      // Simulate some async work
      await Future.delayed(Duration(milliseconds: 500));

      if (_counter >= 10) {
        _stopAsyncOperations();
      }
    });
  }

  void _stopAsyncOperations() {
    setState(() {
      _isRunning = false;
    });
    _periodicTimer?.cancel();
    _addLog('Async operations stopped');
  }

  // Future operations demo
  Future<String> _simulateNetworkCall() async {
    _addLog('Starting network simulation...');
    await Future.delayed(Duration(seconds: 2));

    // Simulate success/failure
    if (Random().nextBool()) {
      return 'Network call successful! Data received.';
    } else {
      throw Exception('Network error occurred');
    }
  }

  void _demonstrateFuture() async {
    setState(() {
      _futureLoading = true;
      _futureResult = '';
    });

    try {
      String result = await _simulateNetworkCall();
      setState(() {
        _futureResult = result;
      });
      _addLog('Future completed successfully');
    } catch (e) {
      setState(() {
        _futureResult = 'Error: $e';
      });
      _addLog('Future failed with error: $e');
    } finally {
      setState(() {
        _futureLoading = false;
      });
    }
  }

  // Stream operations demo
  void _initializeStream() {
    _streamController = StreamController<int>();
    _numberStream = _streamController!.stream;
  }

  void _startStreamDemo() {
    if (_streamSubscription != null) return;

    _addLog('Starting stream demo...');
    setState(() {
      _streamNumbers.clear();
    });

    _streamSubscription = _numberStream!.listen(
          (number) {
        setState(() {
          _streamNumbers.add(number);
        });
        _addLog('Stream received: $number');
      },
      onError: (error) {
        _addLog('Stream error: $error');
      },
      onDone: () {
        _addLog('Stream completed');
      },
    );

    // Generate numbers every 500ms
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_streamSubscription == null) {
        timer.cancel();
        return;
      }

      int randomNumber = Random().nextInt(100);
      _streamController!.add(randomNumber);

      // Stop after 10 numbers
      if (_streamNumbers.length >= 10) {
        timer.cancel();
        _stopStreamDemo();
      }
    });
  }

  void _stopStreamDemo() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _addLog('Stream demo stopped');
  }

  // Isolate operations demo
  static void _isolateEntryPoint(SendPort sendPort) {
    // Heavy computation in isolate
    int result = 0;
    for (int i = 0; i < 1000000; i++) {
      result += i;
    }
    sendPort.send('Heavy computation completed. Result: $result');
  }

  void _startIsolateDemo() async {
    if (_isolateRunning) return;

    setState(() {
      _isolateRunning = true;
      _isolateResult = '';
    });

    _addLog('Starting isolate demo...');

    try {
      ReceivePort receivePort = ReceivePort();
      _isolate = await Isolate.spawn(_isolateEntryPoint, receivePort.sendPort);

      receivePort.listen((message) {
        setState(() {
          _isolateResult = message;
          _isolateRunning = false;
        });
        _addLog('Isolate completed: $message');
        _isolate?.kill();
        receivePort.close();
      });
    } catch (e) {
      setState(() {
        _isolateResult = 'Isolate error: $e';
        _isolateRunning = false;
      });
      _addLog('Isolate error: $e');
    }
  }

  void _stopIsolateDemo() {
    _isolate?.kill();
    setState(() {
      _isolateRunning = false;
    });
    _addLog('Isolate stopped');
  }

  // Parallel async operations demo
  void _demonstrateParallelOperations() async {
    _addLog('Starting parallel operations...');

    List<Future<String>> futures = [
      _simulateTask('Task A', 1),
      _simulateTask('Task B', 2),
      _simulateTask('Task C', 3),
    ];

    try {
      List<String> results = await Future.wait(futures);
      for (String result in results) {
        _addLog('Parallel result: $result');
      }
    } catch (e) {
      _addLog('Parallel operations error: $e');
    }
  }

  Future<String> _simulateTask(String taskName, int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
    return '$taskName completed in $seconds seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Async & Threading Demo'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearLogs,
            tooltip: 'Clear Logs',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Async Operations Demo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This demo showcases various asynchronous operations including Future, Stream, Isolate, and parallel processing.',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Basic Async Operations
            _buildSectionCard(
              title: 'Basic Async Operations',
              icon: Icons.timer,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isRunning ? null : _startAsyncOperations,
                          icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
                          label: Text(_isRunning ? 'Running... ($_counter)' : 'Start Async'),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _isRunning ? _stopAsyncOperations : null,
                        icon: Icon(Icons.stop),
                        label: Text('Stop'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Future Demo
            _buildSectionCard(
              title: 'Future Operations',
              icon: Icons.cloud_download,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: _futureLoading ? null : _demonstrateFuture,
                    icon: _futureLoading
                        ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Icon(Icons.cloud_download),
                    label: Text(_futureLoading ? 'Loading...' : 'Simulate Network Call'),
                  ),
                  if (_futureResult.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _futureResult.contains('Error')
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _futureResult.contains('Error')
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                        ),
                      ),
                      child: Text(
                        _futureResult,
                        style: TextStyle(
                          color: _futureResult.contains('Error')
                              ? Colors.red.shade700
                              : Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Stream Demo
            _buildSectionCard(
              title: 'Stream Operations',
              icon: Icons.stream,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _streamSubscription == null ? _startStreamDemo : null,
                          icon: Icon(Icons.stream),
                          label: Text('Start Stream'),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _streamSubscription != null ? _stopStreamDemo : null,
                        icon: Icon(Icons.stop),
                        label: Text('Stop'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      ),
                    ],
                  ),
                  if (_streamNumbers.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Text('Stream Numbers:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _streamNumbers.map((number) => Chip(
                        label: Text(number.toString()),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Isolate Demo
            _buildSectionCard(
              title: 'Isolate Operations',
              icon: Icons.settings_applications,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isolateRunning ? null : _startIsolateDemo,
                          icon: _isolateRunning
                              ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : Icon(Icons.settings_applications),
                          label: Text(_isolateRunning ? 'Computing...' : 'Heavy Computation'),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _isolateRunning ? _stopIsolateDemo : null,
                        icon: Icon(Icons.stop),
                        label: Text('Kill'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                  if (_isolateResult.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        _isolateResult,
                        style: TextStyle(color: Colors.blue.shade700),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Parallel Operations
            _buildSectionCard(
              title: 'Parallel Operations',
              icon: Icons.timeline,
              child: ElevatedButton.icon(
                onPressed: _demonstrateParallelOperations,
                icon: Icon(Icons.timeline),
                label: Text('Run Parallel Tasks'),
              ),
            ),

            // Logs Section
            _buildSectionCard(
              title: 'Operation Logs',
              icon: Icons.list_alt,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _logs.isEmpty
                    ? Center(
                  child: Text(
                    'No logs yet. Start some operations!',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(8),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _logs[index],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}