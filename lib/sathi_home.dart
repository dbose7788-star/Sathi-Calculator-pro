import 'package:flutter/material.dart';
import 'scientific_calculator.dart';
import 'goods_calculator.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'skin8_shell.dart';
import 'soft5g_screen.dart';

class SathiHome extends StatefulWidget {
  const SathiHome({
    super.key,
    required this.normalScreen,
  });

  final Widget normalScreen;

  @override
  State<SathiHome> createState() => _SathiHomeState();
}

class _SathiHomeState extends State<SathiHome> {
  int selectedIndex = 0;

  Widget _screenForIndex(int index) {
    switch (index) {
      case 1:
        return const ScientificCalculator();
      case 2:
        return const GoodsCalculator();
      case 3:
        return const Soft5GScreen();
      case 4:
        return const HistoryScreen();
      case 5:
        return const SettingsScreen();

      case 0:
      default:
        return widget.normalScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Skin8Shell(
      selectedIndex: selectedIndex,
      onTabSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      child: _screenForIndex(selectedIndex),
    );
  }
}
