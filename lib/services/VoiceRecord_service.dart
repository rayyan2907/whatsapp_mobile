import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class VoiceRecorderService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _filePath;

  bool get isRecording => _recorder.isRecording;

  Future<void> init() async {
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
  }

  Future<void> startRecording() async {
    final dir = await getTemporaryDirectory();
    _filePath = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(
      toFile: _filePath,
      codec: Codec.aacADTS,
    );
  }

  Future<File?> stopRecording() async {
    await _recorder.stopRecorder();
    if (_filePath == null) return null;
    return File(_filePath!);
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
  }
}
