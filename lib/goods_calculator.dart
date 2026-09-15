import 'package:flutter/material.dart';

class GoodsCalculator extends StatefulWidget {
  const GoodsCalculator({super.key});

  @override
  State<GoodsCalculator> createState() => _GoodsCalculatorState();
}

class _GoodsCalculatorState extends State<GoodsCalculator> {
  final quantityController = TextEditingController();
  final rateController = TextEditingController();

  double total = 0;

  void calculate() {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final rate = double.tryParse(rateController.text) ?? 0;

    setState(() {
      total = quantity * rate;
    });
  }

  void clear() {
    quantityController.clear();
    rateController.clear();
    setState(() => total = 0);
  }

  @override
  void dispose() {
    quantityController.dispose();
    rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goods / Material Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: quantityController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: rateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Rate / Unit Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Total: ${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: calculate,
                    child: const Text('Calculate'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: clear,
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
