import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class WhatsAppCameraPage extends StatefulWidget {
  const WhatsAppCameraPage({Key? key}) : super(key: key);

  @override
  State<WhatsAppCameraPage> createState() => _WhatsAppCameraPageState();
}

class _WhatsAppCameraPageState extends State<WhatsAppCameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isRearCameraSelected = true;
  bool _isInitialized = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      Navigator.pop(context);
      return;
    }

    _cameras = await availableCameras();
    final selectedCamera = _cameras![_isRearCameraSelected ? 0 : 1];

    _controller = CameraController(selectedCamera, ResolutionPreset.high, enableAudio: false);

    try {
      await _controller!.initialize();
      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      print("Camera init error: $e");
      Navigator.pop(context);
    }
  }

  Future<void> _captureImage() async {
    if (!_controller!.value.isInitialized || _isCapturing) return;

    setState(() => _isCapturing = true);

    try {
      final XFile file = await _controller!.takePicture();
      Navigator.pop(context, File(file.path)); // 🔁 Return image
    } catch (e) {
      print("Capture error: $e");
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitialized
          ? Stack(
        children: [
          Positioned.fill(child: CameraPreview(_controller!)),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _captureImage,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: _isCapturing
                      ? const Padding(
                    padding: EdgeInsets.all(15),
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : null,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator(color: Colors.green)),
    );
  }
}
