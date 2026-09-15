import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorHistoryService {
  static const String _key = 'sathi_calculator_history';

  static Future<List<Map<String, String>>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? <String>[];

    return raw
        .map((item) {
          try {
            final decoded = jsonDecode(item);
            return Map<String, String>.from(decoded);
          } catch (_) {
            return <String, String>{};
          }
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static Future<void> addEntry(
    String expression,
    String result,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final history = await loadHistory();

    history.insert(0, {
      'expression': expression,
      'result': result,
      'time': DateTime.now().toIso8601String(),
    });

    if (history.length > 100) {
      history.removeRange(100, history.length);
    }

    final encoded =
        history.map((item) => jsonEncode(item)).toList();

    await prefs.setStringList(_key, encoded);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
