import 'package:flutter/material.dart';

class SoftModemScreen extends StatefulWidget {
  const SoftModemScreen({super.key});
  @override
  State<SoftModemScreen> createState() => _SoftModemScreenState();
}

class _SoftModemScreenState extends State<SoftModemScreen> {
  double freq = 100.000;
  bool tx = false;
  bool scan = false;
  int ch = 1;

  final presets = [88.1, 90.0, 92.7, 94.3, 97.6, 100.0, 102.5, 104.8, 107.5];

  void step(double n) => setState(() {
    freq = (freq + n).clamp(76.0, 118.0);
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff080b10),
    appBar: AppBar(title: const Text('SATHI SOFT MODEM'), centerTitle: true),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: ListTile(
        leading: Icon(Icons.radio, color: tx ? Colors.red : Colors.green),
        title: Text(tx ? 'TX — VOICE ACTIVE' : 'RX / READY'),
        trailing: Text('CH $ch'),
      )),
      const SizedBox(height: 14),
      const Center(child: Text('CURRENT FREQUENCY')),
      Center(child: Text('${freq.toStringAsFixed(3)} MHz',
        style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold))),
      Card(child: Column(children: [
        const Text('PRECISION FINE TUNE'),
        Slider(min: 76, max: 118, value: freq,
          onChanged: (v) => setState(() => freq = v)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(onPressed: () => step(-.100), icon: const Icon(Icons.keyboard_double_arrow_left)),
          IconButton(onPressed: () => step(-.010), icon: const Icon(Icons.chevron_left)),
          IconButton(onPressed: () => step(.010), icon: const Icon(Icons.chevron_right)),
          IconButton(onPressed: () => step(.100), icon: const Icon(Icons.keyboard_double_arrow_right)),
        ]),
      ])),
      const SizedBox(height: 18),
      GestureDetector(
        onTapDown: (_) => setState(() => tx = true),
        onTapUp: (_) => setState(() => tx = false),
        onTapCancel: () => setState(() => tx = false),
        child: Container(height: 150,
          decoration: BoxDecoration(shape: BoxShape.circle,
            color: tx ? Colors.red : Colors.blueGrey),
          child: Center(child: Text(tx ? 'TRANSMITTING' : 'HOLD TO TALK',
            style: const TextStyle(fontWeight: FontWeight.bold)))),
      ),
      const SizedBox(height: 18),
      Row(children: [
        Expanded(child: FilledButton.icon(
          onPressed: () => setState(() => scan = !scan),
          icon: Icon(scan ? Icons.stop : Icons.search),
          label: Text(scan ? 'STOP SCAN' : 'SCAN'))),
        const SizedBox(width: 10),
        Expanded(child: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.save),
          label: const Text('SAVE'))),
      ]),
      const SizedBox(height: 16),
      Card(child: Padding(padding: const EdgeInsets.all(12),
        child: Wrap(spacing: 8, runSpacing: 8,
          children: List.generate(presets.length, (i) => ChoiceChip(
            label: Text('CH ${i + 1}  ${presets[i].toStringAsFixed(1)}'),
            selected: ch == i + 1,
            onSelected: (_) => setState(() {
              ch = i + 1; freq = presets[i];
            }),
          ))))),
      const SizedBox(height: 16),
      const Card(child: SizedBox(height: 130,
        child: Center(child: Text('RF SPECTRUM / SIGNAL ACTIVITY')))),
    ]),
  );
}
