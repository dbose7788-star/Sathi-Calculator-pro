import 'package:flutter/material.dart';
import 'scientific_calculator.dart';
import 'screens/history_screen.dart';
import 'goods_calculator.dart';

class SathiHome extends StatelessWidget {
  const SathiHome({
    super.key,
    required this.normalScreen,
  });

  final Widget normalScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sathi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item(
            context,
            'Normal Calculator',
            Icons.calculate,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => normalScreen),
            ),
          ),
          _item(
            context,
            'Scientific Calculator',
            Icons.science,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ScientificCalculator(),
              ),
            ),
          ),
          _item(
            context,
            'Goods / Material Calculator',
            Icons.inventory_2,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GoodsCalculator(),
              ),
            ),
          ),
          _item(
            context,
            'History',
            Icons.history,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HistoryScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
