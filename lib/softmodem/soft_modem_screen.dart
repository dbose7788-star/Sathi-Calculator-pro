import 'package:flutter/material.dart';
import 'voice_engine.dart';

class SoftModemScreen extends StatefulWidget {
  const SoftModemScreen({super.key});

  @override
  State<SoftModemScreen> createState() => _SoftModemScreenState();
}

class _SoftModemScreenState extends State<SoftModemScreen> {
  final VoiceEngine _voice = VoiceEngine();

  double freq = 100.000;
  bool tx = false;
  bool scan = false;
  int channel = 1;
  int audioBytes = 0;

  final List<double> presets = [
    88.1, 90.1, 92.7, 94.9, 97.5,
    99.1, 100.0, 101.5, 103.3, 105.5, 107.5
  ];

  Future<void> _togglePTT() async {
    if (tx) {
      await _voice.stop();
      if (mounted) setState(() => tx = false);
      return;
    }

    audioBytes = 0;

    final ok = await _voice.start(
      onAudio: (pcm) {
        audioBytes += pcm.length;
        if (mounted) setState(() {});
      },
    );

    if (mounted) {
      setState(() => tx = ok);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission required')),
        );
      }
    }
  }

  void _tune(double amount) {
    setState(() {
      freq = (freq + amount).clamp(76.0, 118.0);
    });
  }

  @override
  void dispose() {
    _voice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sathi Soft Modem'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'FREQUENCY',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${freq.toStringAsFixed(3)} MHz',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () => _tune(-0.100),
                            child: const Text('-100 kHz'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => _tune(-0.010),
                            child: const Text('-10 kHz'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => _tune(0.010),
                            child: const Text('+10 kHz'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => _tune(0.100),
                            child: const Text('+100 kHz'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _togglePTT,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tx ? Icons.mic : Icons.mic_none,
                      size: 58,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tx ? 'TRANSMITTING VOICE' : 'PUSH TO TALK',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (tx)
                      Text(
                        'Captured: ${audioBytes ~/ 1024} KB',
                        style: const TextStyle(fontSize: 13),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CHANNEL PRESETS',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        presets.length,
                        (i) => ChoiceChip(
                          label: Text(
                            'CH ${i + 1}  ${presets[i].toStringAsFixed(1)}',
                          ),
                          selected: channel == i + 1,
                          onSelected: (_) {
                            setState(() {
                              channel = i + 1;
                              freq = presets[i];
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => setState(() => scan = !scan),
                    icon: Icon(scan ? Icons.stop : Icons.search),
                    label: Text(scan ? 'STOP SCAN' : 'SCAN'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.save),
                    label: const Text('SAVE'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    scan
                        ? 'RF SCAN ACTIVE\n${freq.toStringAsFixed(3)} MHz'
                        : 'RF SPECTRUM / SIGNAL ACTIVITY',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
