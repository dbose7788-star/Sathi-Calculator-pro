import 'package:flutter/material.dart';
import 'softmodem/soft_modem_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SathiSoftModemApp());
}

class SathiSoftModemApp extends StatelessWidget {
  const SathiSoftModemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sathi Soft Modem',
      theme: ThemeData.dark(useMaterial3: true),
      home: const SoftModemScreen(),
    );
  }
}
