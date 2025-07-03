import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:whatsapp_mobile/model/text_msg.dart';

class MessageBar extends StatefulWidget {
  final Map<String, dynamic> user;
  final void Function(Map<String, dynamic>) onMessageSent;

  const MessageBar({
    super.key,
    required this.user,
    required this.onMessageSent,
  });


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

  //sending fubction is here
  Future<void> sendMessage() async {
    if (!isConnected) return;

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
      await hubConnection.invoke("SendMessage", args: [msg.toJson()]);
      _controller.clear();
      widget.onMessageSent({
        "text_msg": msg.textMsg,
        "time": msg.timestamp,
        "type": msg.type,
        "img_url": "",
        "video_url": "",
        "caption": "",
        "duration": "",
        "voice_url": "",
        "is_seen": false,
        "is_sent": true,
      });

    } catch (e) {
      print("Failed to send message: $e");
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
                    sendMessage();
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
