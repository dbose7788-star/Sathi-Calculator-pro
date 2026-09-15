
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Soft5GScreen extends StatefulWidget {
  const Soft5GScreen({super.key});

  @override
  State<Soft5GScreen> createState() => _Soft5GScreenState();
}

class _Soft5GScreenState extends State<Soft5GScreen> {
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  String connection = 'Checking...';
  String cellular = 'Unknown';
  String internet = 'Checking...';

  double downloadMbps = 0;
  double uploadMbps = 0;
  int pingMs = 0;

  bool testing = false;
  DateTime? lastTest;

  static const MethodChannel _native =
      MethodChannel('sathi/soft5g');

  @override
  void initState() {
    super.initState();

    _refresh();

    _subscription = _connectivity.onConnectivityChanged.listen((_) {
      _refresh();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final results = await _connectivity.checkConnectivity();

      String state;

      if (results.contains(ConnectivityResult.wifi)) {
        state = 'Wi-Fi / Hotspot';
      } else if (results.contains(ConnectivityResult.mobile)) {
        state = 'Mobile network';
      } else if (results.contains(ConnectivityResult.ethernet)) {
        state = 'Ethernet';
      } else if (results.contains(ConnectivityResult.vpn)) {
        state = 'VPN';
      } else {
        state = 'Offline';
      }

      String phoneNetwork = 'Unknown';

      try {
        final value =
            await _native.invokeMethod<String>('cellularType');

        if (value != null && value.isNotEmpty) {
          phoneNetwork = value;
        }
      } catch (_) {
        phoneNetwork = 'Unavailable';
      }

      if (!mounted) return;

      setState(() {
        connection = state;
        cellular = phoneNetwork;
        internet = state == 'Offline'
            ? 'No connection'
            : 'Connection available';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        connection = 'Unknown';
        internet = 'Unable to determine';
      });
    }
  }

  Future<int> _ping() async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 5);

    final stopwatch = Stopwatch()..start();

    try {
      final request = await client.getUrl(
        Uri.parse('https://www.google.com/generate_204'),
      );

      request.followRedirects = false;

      final response = await request.close()
          .timeout(const Duration(seconds: 5));

      await response.drain();

      stopwatch.stop();
      return stopwatch.elapsedMilliseconds;
    } catch (_) {
      stopwatch.stop();
      return 0;
    } finally {
      client.close(force: true);
    }
  }

  Future<double> _downloadTest() async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);

    final uri = Uri.parse(
      'https://speed.cloudflare.com/__down?bytes=5000000',
    );

    final stopwatch = Stopwatch()..start();
    int bytes = 0;

    try {
      final request = await client.getUrl(uri);
      final response = await request.close()
          .timeout(const Duration(seconds: 20));

      await for (final chunk in response) {
        bytes += chunk.length;
      }

      stopwatch.stop();

      final seconds =
          stopwatch.elapsedMilliseconds / 1000.0;

      if (seconds <= 0) return 0;

      return (bytes * 8) / seconds / 1000000;
    } catch (_) {
      return 0;
    } finally {
      client.close(force: true);
    }
  }

  Future<double> _uploadTest() async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);

    final uri = Uri.parse(
      'https://speed.cloudflare.com/__up',
    );

    final data = Uint8List(1000000);

    final stopwatch = Stopwatch()..start();

    try {
      final request = await client.postUrl(uri);

      request.headers.contentType =
          ContentType('application', 'octet-stream');

      request.headers.contentLength = data.length;

      request.add(data);

      final response = await request.close()
          .timeout(const Duration(seconds: 20));

      await response.drain();

      stopwatch.stop();

      final seconds =
          stopwatch.elapsedMilliseconds / 1000.0;

      if (seconds <= 0) return 0;

      return (data.length * 8) / seconds / 1000000;
    } catch (_) {
      return 0;
    } finally {
      client.close(force: true);
    }
  }

  Future<void> _runSpeedTest() async {
    if (testing) return;

    setState(() {
      testing = true;
      internet = 'Testing...';
    });

    final p = await _ping();
    final d = await _downloadTest();
    final u = await _uploadTest();

    if (!mounted) return;

    setState(() {
      pingMs = p;
      downloadMbps = d;
      uploadMbps = u;
      testing = false;
      lastTest = DateTime.now();
      internet = 'Internet available';
    });
  }

  String _displayNetwork() {
    if (cellular.toUpperCase().contains('5G')) {
      return cellular;
    }

    if (cellular.toUpperCase().contains('4G')) {
      return cellular;
    }

    if (connection == 'Wi-Fi / Hotspot') {
      return 'Wi-Fi / Hotspot';
    }

    return cellular;
  }

  Widget _metric(
    IconData icon,
    String title,
    String value,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF18263A),
          ),
          color: const Color(0xFF101722),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF4DB8FF),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final network = _displayNetwork();

    return Scaffold(
      backgroundColor: const Color(0xFF080D14),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF102A3C),
                    ),
                    child: const Icon(
                      Icons.signal_cellular_alt,
                      color: Color(0xFF4DB8FF),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Soft5G',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Virtual network monitor',
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF10283B),
                      Color(0xFF0D1621),
                    ],
                  ),
                  border: Border.all(
                    color: Color(0xFF1C6B92),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.router_outlined,
                      color: Color(0xFF5CC8FF),
                      size: 48,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      network,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      connection,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      internet,
                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  _metric(
                    Icons.download_rounded,
                    'DOWNLOAD',
                    '${downloadMbps.toStringAsFixed(1)} Mbps',
                  ),
                  _metric(
                    Icons.upload_rounded,
                    'UPLOAD',
                    '${uploadMbps.toStringAsFixed(1)} Mbps',
                  ),
                ],
              ),

              Row(
                children: [
                  _metric(
                    Icons.speed,
                    'PING',
                    '$pingMs ms',
                  ),
                  _metric(
                    Icons.network_check,
                    'CELLULAR',
                    cellular,
                  ),
                ],
              ),

              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _metric(
                      Icons.router_outlined,
                      "VIRTUAL 5G MODEM",
                      cellular == "5G" ? "ACTIVE" : "READY",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _metric(
                      Icons.graphic_eq,
                      "5G RF DECODER",
                      cellular == "5G" ? "5G ANALYSIS" : "STANDBY",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                      testing ? null : _runSpeedTest,
                  icon: testing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.speed),
                  label: Text(
                    testing
                        ? 'TESTING NETWORK...'
                        : 'RUN SPEED TEST',
                  ),
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'REFRESH NETWORK STATUS',
                ),
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFF111923),
                ),
                child: const Text(
                  'Important: when this phone is connected '
                  'to another phone by Wi-Fi hotspot, Android '
                  'normally exposes the client connection as '
                  'Wi-Fi. The app cannot directly decode the '
                  'other phone’s 4G/5G radio through Wi-Fi. '
                  'Actual internet speed shown here is measured '
                  'through the current connection.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),

              if (lastTest != null) ...[
                const SizedBox(height: 10),
                Text(
                  'Last test: ${lastTest!.hour.toString().padLeft(2, '0')}:'
                  '${lastTest!.minute.toString().padLeft(2, '0')}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
