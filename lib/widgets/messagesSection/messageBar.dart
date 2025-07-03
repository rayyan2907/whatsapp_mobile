import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({super.key});

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final TextEditingController _controller = TextEditingController();
  bool _showSend = false;
  late HubConnection hubConnection;
  bool isConnected = false;

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
            print('JWT Token: $token');
            return token;
          },
        ),
      )
          .build();

      hubConnection.onclose((error) {
        print("SignalR closed: $error");
        isConnected = false;
      });

      hubConnection.on("ReceiveMessage", (message) {
        print("Received: $message");
      });

      await hubConnection.start(); // MUST be inside try
      isConnected = true;
      print("SignalR connected");
    } catch (e, st) {
      print("SignalR Connection Error: $e");
      print("Stacktrace: $st");
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          const Icon(CupertinoIcons.add, color: Colors.white, size: 20),
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
              ? IconButton(
                  onPressed: () {
                    // Send action
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent, // WhatsApp green
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
                  children: const [
                    Icon(CupertinoIcons.camera, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Icon(CupertinoIcons.mic, color: Colors.white, size: 20),
                  ],
                ),
        ],
      ),
    );
  }
}
