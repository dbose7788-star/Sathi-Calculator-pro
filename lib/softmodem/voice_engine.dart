import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';

class VoiceEngine {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _subscription;
  bool running = false;

  Future<bool> start({
    required void Function(Uint8List pcm) onAudio,
  }) async {
    if (running) return true;

    if (!await _recorder.hasPermission()) {
      return false;
    }

    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ),
    );

    _subscription = stream.listen(onAudio);
    running = true;
    return true;
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    await _recorder.stop();
    running = false;
  }

  Future<void> dispose() async {
    await stop();
    await _recorder.dispose();
  }
}
