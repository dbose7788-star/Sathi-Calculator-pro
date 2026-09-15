import 'package:flutter/material.dart';
import '../calculator_history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, String>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _historyFuture = CalculatorHistoryService.loadHistory();
  }

  Future<void> _clearHistory() async {
    await CalculatorHistoryService.clearHistory();
    if (!mounted) return;
    setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07131D),
        title: const Text('HISTORY'),
        actions: [
          IconButton(
            tooltip: 'Clear history',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear history?'),
                  content: const Text(
                    'All saved calculations will be removed.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('CLEAR'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await _clearHistory();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load history',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return const Center(
              child: Text(
                'No calculations yet',
                style: TextStyle(
                  color: Color(0xFF78909C),
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: history.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = history[index];

              return Card(
                color: const Color(0xFF0B1822),
                child: ListTile(
                  title: Text(
                    item['expression'] ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    item['time'] ?? '',
                    style: const TextStyle(
                      color: Color(0xFF607D8B),
                      fontSize: 11,
                    ),
                  ),
                  trailing: Text(
                    item['result'] ?? '',
                    style: const TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
