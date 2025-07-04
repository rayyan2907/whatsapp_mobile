import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class VoiceRecorderService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _filePath;

  bool get isRecording => _recorder.isRecording;

  Future<void> init() async {
    try {
      await _recorder.openRecorder();
      await _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
      print("Voice recorder initialized");
    } catch (e) {
      print("Error initializing recorder: $e");
    }
  }

  Future<void> startRecording() async {
    try {
      final dir = await getTemporaryDirectory();
      _filePath = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder.startRecorder(
        toFile: _filePath,
        codec: Codec.aacADTS,
      );

      print("Recording started at: $_filePath");
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<File?> stopRecording() async {
    try {
      await _recorder.stopRecorder();
      if (_filePath == null) {
        print("Recording path was null");
        return null;
      }

      final file = File(_filePath!);
      final exists = await file.exists();
      final size = await file.length();

      print("Recording stopped. File exists: $exists, Size: $size bytes");

      return exists && size > 0 ? file : null;
    } catch (e) {
      print("Error stopping recorder: $e");
      return null;
    }
  }

  Future<void> dispose() async {
    try {
      await _recorder.closeRecorder();
      print("Recorder disposed");
    } catch (e) {
      print("Error disposing recorder: $e");
    }
  }
}
