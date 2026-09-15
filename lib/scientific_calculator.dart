import 'dart:math' as math;
import 'package:flutter/material.dart';

class ScientificCalculator extends StatefulWidget {
  const ScientificCalculator({super.key});

  @override
  State<ScientificCalculator> createState() =>
      _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  String display = '0';
  bool degrees = true;

  double? storedValue;
  String? pendingOperator;
  bool startNewNumber = false;

  double get value => double.tryParse(display) ?? 0;

  void setDisplay(double v) {
    setState(() {
      if (v.isNaN || v.isInfinite) {
        display = 'Error';
      } else {
        display = _format(v);
      }
    });
  }

  String _format(double v) {
    if (v == v.roundToDouble()) {
      return v.toInt().toString();
    }
    return v.toStringAsPrecision(15).replaceFirst(
          RegExp(r'\.?0+$'),
          '',
        );
  }

  double _angle(double v) =>
      degrees ? v * math.pi / 180 : v;

  double _fromAngle(double v) =>
      degrees ? v * 180 / math.pi : v;

  void unary(String name) {
    final x = value;

    try {
      double result;

      switch (name) {
        case 'sin':
          result = math.sin(_angle(x));
          break;
        case 'cos':
          result = math.cos(_angle(x));
          break;
        case 'tan':
          result = math.tan(_angle(x));
          break;
        case 'asin':
          result = _fromAngle(math.asin(x));
          break;
        case 'acos':
          result = _fromAngle(math.acos(x));
          break;
        case 'atan':
          result = _fromAngle(math.atan(x));
          break;
        case 'ln':
          if (x <= 0) {
            setDisplay(double.nan);
            return;
          }
          result = math.log(x);
          break;
        case 'log':
          if (x <= 0) {
            setDisplay(double.nan);
            return;
          }
          result = math.log(x) / math.ln10;
          break;
        case 'sqrt':
          if (x < 0) {
            setDisplay(double.nan);
            return;
          }
          result = math.sqrt(x);
          break;
        case 'square':
          result = x * x;
          break;
        case 'inverse':
          if (x == 0) {
            setDisplay(double.nan);
            return;
          }
          result = 1 / x;
          break;
        case 'factorial':
          if (x < 0 ||
              x != x.floorToDouble() ||
              x > 170) {
            setDisplay(double.nan);
            return;
          }

          result = 1;
          for (int i = 2; i <= x.toInt(); i++) {
            result *= i;
          }
          break;
        default:
          return;
      }

      setDisplay(result);
      startNewNumber = true;
    } catch (_) {
      setDisplay(double.nan);
    }
  }

  void binaryOperator(String operator) {
    if (display == 'Error') {
      clear();
      return;
    }

    final current = value;

    if (storedValue != null && pendingOperator != null) {
      final result = _calculate(
        storedValue!,
        current,
        pendingOperator!,
      );

      if (result == null) {
        setDisplay(double.nan);
        storedValue = null;
        pendingOperator = null;
        return;
      }

      storedValue = result;
      setDisplay(result);
    } else {
      storedValue = current;
    }

    pendingOperator = operator;
    startNewNumber = true;
  }

  void equals() {
    if (storedValue == null || pendingOperator == null) {
      return;
    }

    final result = _calculate(
      storedValue!,
      value,
      pendingOperator!,
    );

    if (result == null) {
      setDisplay(double.nan);
    } else {
      setDisplay(result);
    }

    storedValue = null;
    pendingOperator = null;
    startNewNumber = true;
  }

  double? _calculate(
    double a,
    double b,
    String operator,
  ) {
    switch (operator) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        if (b == 0) return null;
        return a / b;
      case 'xʸ':
        final result = math.pow(a, b).toDouble();
        if (result.isNaN || result.isInfinite) {
          return null;
        }
        return result;
      default:
        return null;
    }
  }

  void clear() {
    setState(() {
      display = '0';
      storedValue = null;
      pendingOperator = null;
      startNewNumber = false;
    });
  }

  void backspace() {
    setState(() {
      if (display == 'Error' ||
          display.length <= 1 ||
          (display.startsWith('-') && display.length <= 2)) {
        display = '0';
      } else {
        display = display.substring(0, display.length - 1);
      }
    });
  }

  void toggleSign() {
    if (display == '0' || display == 'Error') return;

    setState(() {
      if (display.startsWith('-')) {
        display = display.substring(1);
      } else {
        display = '-$display';
      }
    });
  }

  void input(String text) {
    setState(() {
      if (display == 'Error' || startNewNumber) {
        display = '0';
        startNewNumber = false;
      }

      if (text == '.') {
        if (!display.contains('.')) {
          display += '.';
        }
        return;
      }

      if (display == '0') {
        display = text;
      } else {
        display += text;
      }
    });
  }

  void constant(double v) {
    setState(() {
      display = _format(v);
      startNewNumber = true;
    });
  }

  Widget button(
    String text, {
    VoidCallback? onTap,
    bool accent = false,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: accent
            ? const Color(0xFFDD7700)
            : const Color(0xFF2B2B2B),
        foregroundColor: const Color(0xFFE0C8FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
        title: const Text('Scientific Calculator'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                degrees = !degrees;
              });
            },
            child: Text(
              degrees ? 'DEG' : 'RAD',
              style: const TextStyle(
                color: Color(0xFFE0C8FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: const Color(0xFF202020),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  display,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.25,
                  children: [
                    button('sin', onTap: () => unary('sin')),
                    button('cos', onTap: () => unary('cos')),
                    button('tan', onTap: () => unary('tan')),
                    button('ln', onTap: () => unary('ln')),

                    button('asin', onTap: () => unary('asin')),
                    button('acos', onTap: () => unary('acos')),
                    button('atan', onTap: () => unary('atan')),
                    button('log', onTap: () => unary('log')),

                    button('√', onTap: () => unary('sqrt')),
                    button('x²', onTap: () => unary('square')),
                    button('1/x', onTap: () => unary('inverse')),
                    button(
                      'xʸ',
                      onTap: () => binaryOperator('xʸ'),
                    ),

                    button('π', onTap: () => constant(math.pi)),
                    button('e', onTap: () => constant(math.e)),
                    button('n!', onTap: () => unary('factorial')),
                    button('⌫', onTap: backspace),

                    button('C', onTap: clear, accent: true),
                    button('±', onTap: toggleSign),
                    button('÷', onTap: () => binaryOperator('÷')),
                    button('×', onTap: () => binaryOperator('×')),

                    button('7', onTap: () => input('7')),
                    button('8', onTap: () => input('8')),
                    button('9', onTap: () => input('9')),
                    button('-', onTap: () => binaryOperator('-')),

                    button('4', onTap: () => input('4')),
                    button('5', onTap: () => input('5')),
                    button('6', onTap: () => input('6')),
                    button('+', onTap: () => binaryOperator('+')),

                    button('1', onTap: () => input('1')),
                    button('2', onTap: () => input('2')),
                    button('3', onTap: () => input('3')),
                    button('=', onTap: equals, accent: true),

                    button('0', onTap: () => input('0')),
                    button('.', onTap: () => input('.')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
