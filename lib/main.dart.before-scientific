import 'package:flutter/material.dart';
import 'services/trial_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final trialStatus = await TrialService.checkTrialStatus();

  runApp(MyApp(
    isTrialActive: trialStatus['isTrialActive'] as bool? ?? false,
    daysLeft: trialStatus['daysRemaining'] as int? ?? 0,
    isUnlocked: trialStatus['isUnlocked'] as bool? ?? false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isTrialActive, required this.daysLeft, required this.isUnlocked});
  final bool isTrialActive;
  final int daysLeft;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sathi Calculator',
      theme: ThemeData.dark(useMaterial3: true),
      home: CalculatorScreen(isTrialActive: isTrialActive, daysLeft: daysLeft, isUnlocked: isUnlocked),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key, required this.isTrialActive, required this.daysLeft, required this.isUnlocked});
  final bool isTrialActive;
  final int daysLeft;
  final bool isUnlocked;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';
  String display = '0';
  bool justSolved = false;

  void input(String value) {
    setState(() {
      if (justSolved && !'+-*/'.contains(value)) expression = '';
      justSolved = false;
      expression += value;
      display = expression.replaceAll('*', '×').replaceAll('/', '÷').replaceAll('-', '−');
    });
  }

  void clear() => setState(() { expression = ''; display = '0'; justSolved = false; });

  void backspace() => setState(() { expression = expression.isNotEmpty ? expression.substring(0, expression.length - 1) : ''; display = expression.isEmpty ? '0' : expression; });

  void calculate() {
    if (expression.isEmpty) return;
    try {
      final value = _evaluate(expression);
      setState(() { display = _format(value); expression = _format(value); justSolved = true; });
    } catch (_) {
      setState(() { display = 'Error'; expression = ''; justSolved = true; });
    }
  }

  double _evaluate(String input) {
    final tokens = RegExp(r'\d*\.?\d+|[+\-*/()]').allMatches(input).map((m) => m.group(0)!).toList();
    if (tokens.isEmpty || tokens.join() != input) throw FormatException();
    final values = <double>[];
    final ops = <String>[];
    final precedence = {'+': 1, '-': 1, '*': 2, '/': 2};
    void apply() {
      if (values.length < 2 || ops.isEmpty) throw FormatException();
      final b = values.removeLast(), a = values.removeLast(), op = ops.removeLast();
      if (op == '/' && b == 0) throw FormatException();
      values.add(op == '+' ? a + b : op == '-' ? a - b : op == '*' ? a * b : a / b);
    }
    for (final token in tokens) {
      final number = double.tryParse(token);
      if (number != null) values.add(number);
      else if (token == '(') ops.add(token);
      else if (token == ')') { while (ops.isNotEmpty && ops.last != '(') apply(); if (ops.isEmpty) throw FormatException(); ops.removeLast(); }
      else { while (ops.isNotEmpty && ops.last != '(' && precedence[ops.last]! >= precedence[token]!) apply(); ops.add(token); }
    }
    while (ops.isNotEmpty) { if (ops.last == '(') throw FormatException(); apply(); }
    if (values.length != 1 || !values.single.isFinite) throw FormatException();
    return values.single;
  }

  String _format(double value) => value == value.roundToDouble() ? value.toInt().toString() : value.toStringAsPrecision(15).replaceFirst(RegExp(r'\.?0+$'), '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 430), child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
        const Align(alignment: Alignment.centerLeft, child: Text('Sathi', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
        const Align(alignment: Alignment.centerLeft, child: Text('Your Everyday Calculation Companion', style: TextStyle(color: Colors.grey, fontSize: 12))),
        const SizedBox(height: 12),
        const SizedBox(height: 10),
        Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFF202020), borderRadius: BorderRadius.circular(16)), child: Align(alignment: Alignment.centerRight, child: Text(display, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 38))),),
        const SizedBox(height: 14),
        Expanded(child: GridView.count(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.15, children: [
          _button('C', clear, danger: true), _button('⌫', backspace), _button('%', () { if (expression.isNotEmpty) { final n = double.tryParse(expression); if (n != null) input(''); setState(() { expression = (n! / 100).toString(); display = expression; }); }}), _button('÷', () => input('/'), op: true),
          for (final n in ['7','8','9']) _button(n, () => input(n)), _button('×', () => input('*'), op: true),
          for (final n in ['4','5','6']) _button(n, () => input(n)), _button('−', () => input('-'), op: true),
          for (final n in ['1','2','3']) _button(n, () => input(n)), _button('+', () => input('+'), op: true),
          _button('0', () => input('0'), wide: true), _button('.', () => input('.')), _button('=', calculate, equal: true),
        ])),
      ]))))),
    );
  }

  Widget _button(String text, VoidCallback onTap, {bool op = false, bool equal = false, bool danger = false, bool wide = false}) => SizedBox(width: wide ? 160 : null, child: ElevatedButton(onPressed: onTap, style: ElevatedButton.styleFrom(backgroundColor: danger ? const Color(0xFF991B1B) : equal ? const Color(0xFF16A34A) : op ? const Color(0xFFD97706) : const Color(0xFF2B2B2B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: Text(text, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold))));
}
