import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/chatList.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/messageBar.dart';
import 'package:whatsapp_mobile/widgets/players/imageViewer.dart';
import 'package:signalr_core/signalr_core.dart';

class MobileChatScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const MobileChatScreen({super.key, required this.user});

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  late HubConnection _connection;
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _connectToStatusHub();
  }

  Future<void> _connectToStatusHub() async {
    _connection = HubConnectionBuilder()
        .withUrl(
      'http://192.168.0.109:5246/statusHub?user_id=$widget.user',
      HttpConnectionOptions(
        transport: HttpTransportType.webSockets,
        logging: (level, message) => print(message),
      ),
    )
        .build();

    // Listen for status changes of other users
    _connection.on("UserStatusChanged", (args) {
      String otherUserId = args?[0];
      bool isOnline = args?[1] ?? false;

      if (otherUserId == widget.user['user_id'].toString()) {
        setState(() {
          _isOnline = isOnline;
        });
      }
    });

    await _connection.start();
    print("🟢 Connected to StatusHub");
  }

  @override
  void dispose() {
    _connection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.4,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (widget.user['profile_pic_url'] != null &&
                    widget.user['profile_pic_url'].toString().isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageViewer(
                        imageUrl: widget.user['profile_pic_url'].toString(),
                      ),
                    ),
                  );
                }
              },
              child: Hero(
                tag: widget.user['profile_pic_url'] ?? 'default_dp',
                child: CircleAvatar(
                  radius: 17.5,
                  backgroundImage:
                  widget.user['profile_pic_url'] != null &&
                      widget.user['profile_pic_url'].toString().isNotEmpty
                      ? NetworkImage(widget.user['profile_pic_url'].toString())
                      : null,
                  backgroundColor: Colors.grey,
                  child: widget.user['profile_pic_url'] == null ||
                      widget.user['profile_pic_url'].toString().isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.user['first_name'] ?? ''} ${widget.user['last_name'] ?? ''}".trim(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _isOnline ? "online" : "offline",
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.video_camera, color: Colors.white, size: 31),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.phone, color: Colors.white, size: 20)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Chatlist(user: widget.user),
            ),
          ),
          const MessageBar(),
        ],
      ),
    );
  }
}
