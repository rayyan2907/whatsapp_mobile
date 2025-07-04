import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:whatsapp_mobile/model/text_msg.dart';

import '../../services/VoiceRecord_service.dart';
import '../../services/img_service.dart';
import '../Selectors/imageSelector.dart';

class MessageBar extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(Map<String, dynamic>) onNewMessage;

  const MessageBar({super.key, required this.user, required this.onNewMessage});

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final TextEditingController _controller = TextEditingController();
  bool _showSend = false;
  late HubConnection hubConnection;
  bool isConnected = false;
  bool _isLoading = false;
  late VoiceRecorderService _voiceRecorder;
  bool _isRecording = false;
  bool _isSendingImage = false;
  bool _isSendingVoice = false;



  void _onTextChanged() {
    setState(() {
      _showSend = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    connectToSignalR();
    _voiceRecorder = VoiceRecorderService();
    _voiceRecorder.init();
  }

  Future<void> connectToSignalR() async {
    print("trying to connect");

    try {
      hubConnection = HubConnectionBuilder()
          .withUrl(
            'http://192.168.0.101:5246/chatHub',
            HttpConnectionOptions(
              transport: HttpTransportType.webSockets,
              accessTokenFactory: () async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('jwt') ?? '';
                return token;
              },
            ),
          )
          .withAutomaticReconnect()
          .build();

      hubConnection.onclose((error) {
        print("SignalR closed: $error");
        isConnected = false;
      });

      hubConnection.on("ReceiveMessage", (arguments) {
        print('main hub func');
        if (arguments != null && arguments.isNotEmpty) {
          final newMsg = Map<String, dynamic>.from(arguments[0]);
          print("Received: $newMsg");

          widget.onNewMessage(newMsg);
        }
      });

      await hubConnection.start(); // MUST be inside try
      isConnected = true;
      showToast(
        "connected",
        duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
        position: ToastPosition.top,
        backgroundColor: Colors.green,
        textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
        radius: 8.0, // optional, for rounded edges
      );
      print("SignalR connected");
    } catch (e, st) {
      print("SignalR Connection Error: $e");
      print("Stacktrace: $st");

      showToast(
        "Error in connection.Please restart the app",
        duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
        position: ToastPosition.top,
        backgroundColor: Colors.red,
        textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
        radius: 8.0, // optional, for rounded edges
      );
    }
  }

  Future<bool> requestMicPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  //sending fubction is here
  Future<void> sendMessage() async {
    if (!isConnected) {
      print('not connected');
      showToast(
        "Error in connection to server",
        duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
        position: ToastPosition.top,
        backgroundColor: Colors.red,
        textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
        radius: 8.0, // optional, for rounded edges
      );

      return;
    }

    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now); // e.g., 04:50 PM

    final msg = ChatMessage(
      recieverId: widget.user['user_id'],
      type: 'msg',
      textMsg: _controller.text.trim(),
      timestamp: formattedTime,
      is_seen: false,
    );

    if (msg.textMsg.isEmpty) return;

    try {
      setState(() {
        _isLoading = true;
      });
      await hubConnection.invoke("SendMessage", args: [msg.toJson()]);
      _controller.clear();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Failed to send message: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> startVoiceRecording() async {
    final granted = await requestMicPermission();
    if (!granted) {
      showToast("Microphone permission denied");
      return;
    }

    await _voiceRecorder.startRecording();
    await Future.delayed(
      const Duration(milliseconds: 300),
    ); // Let file initialize
    setState(() => _isRecording = true);
  }

  Future<void> stopAndSendVoiceRecording() async {
    final file = await _voiceRecorder.stopRecording();
    setState(() {
      _isRecording = false;
      _isSendingVoice = true;
    });

    if (file == null || !await file.exists()) {
      showToast("Recording failed or file not found");
      setState(() => _isSendingVoice = false);
      return;
    }

    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      showToast("Voice file is empty");
      print("Voice file is empty");
      setState(() => _isSendingVoice = false);
      return;
    }

    final base64Audio = base64Encode(bytes);
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now);
    final msg = {
      'reciever_id': widget.user['user_id'],
      'type': 'voice',
      'file_name': 'voice_${DateTime.now().millisecondsSinceEpoch}.aac',
      'time': formattedTime,
      'is_seen': false,
      'voice_byte': base64Audio,
    };

    try {
      await hubConnection.invoke("SendMessage", args: [msg]);
    } catch (e) {
      print("Voice message send error: $e");
      showToast("Error sending voice message");
    }

    setState(() => _isSendingVoice = false);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
    _voiceRecorder.dispose();
    hubConnection.stop();
    print('connection stoped');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => WhatsAppImagePicker(
                  onImagesSelected: (List<File> files) async {
                    setState(() {
                      _isSendingImage=true;
                    });
                    if (files.isEmpty) return;
                    final file = files.first;
                    final msg = await ImageUploadService.uploadImage(file, widget.user['user_id']);
                    print(msg);

                    if (msg != null) {
                      try {
                        await hubConnection.invoke("SendMessage", args: [msg]);
                        _isSendingImage=false;
                      } catch (e) {
                        print("Error sending image msg via SignalR: $e");
                        _isSendingImage=false;
                      }
                    }
                  }

              ),
            ),
            child: _isSendingImage
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.greenAccent,
              ),
            )
                : const Icon(
              CupertinoIcons.add,
              color: Colors.white,
              size: 20,
            ),

          ),

          const SizedBox(width: 8),

          // Input + Emoji
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[850], // Grey background
                borderRadius: BorderRadius.circular(22),
              ),
              height: 38, // ↓ Decreased height
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ), // ↓ Smaller font
                      decoration: const InputDecoration(
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true, // ↓ Makes field tighter
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                        ), // ↓ Vertical padding
                      ),
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.smiley,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Show send or mic + camera
          _showSend
              ? _isLoading
                    ? Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(6),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.greenAccent,
                        ),
                      )
                    : IconButton(
                        onPressed: () async {
                          await sendMessage();
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      )
              : Row(
                  children: [
                    const Icon(
                      CupertinoIcons.camera,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onLongPressStart: (_) async =>
                          await startVoiceRecording(),
                      onLongPressEnd: (_) async =>
                          await stopAndSendVoiceRecording(),

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        width: _isRecording ? 100 : 20,
                        height: _isRecording ? 100 : 20,
                        child: _isSendingVoice
                            ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.greenAccent,
                        )
                            : Icon(
                          _isRecording ? Icons.mic : CupertinoIcons.mic,
                          color: _isRecording ? Colors.green : Colors.white,
                          size: _isRecording ? 100 : 20,
                        ),

                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
