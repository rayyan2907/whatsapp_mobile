import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_mobile/controller/selectedUser.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/chatList.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/messageBar.dart';
import 'package:whatsapp_mobile/widgets/players/imageViewer.dart';
import 'package:signalr_core/signalr_core.dart';

import '../services/RegAndLogin/userStatusService.dart';
import '../services/getUser.dart';

class MobileChatScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const MobileChatScreen({super.key, required this.user});

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}
class _MobileChatScreenState extends State<MobileChatScreen> {
  final GlobalKey<ChatlistState> chatListKey = GlobalKey<ChatlistState>();
  late HubConnection _connection;
  bool _isOnline = false;
  int id=0;

  List<Map<String, dynamic>> messages = [];

  void addMessage(Map<String, dynamic> msg) {
    setState(() {
      messages.insert(0, msg); // reversed: true
    });
  }

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
    _listenToUserStatus();
  }
  void _checkInitialStatus() async {
    print('called');
    final status = await checkUserOnlineStatus(widget.user['user_id']);
    setState(() {

      _isOnline = status;
    });
  }
  void _listenToUserStatus() async {
    print(' user id is ${widget.user['user_id']}');

    _connection = HubConnectionBuilder()
        .withUrl(
      'https://whatsappclonebackend.azurewebsites.net/statusHub?user_id=$id',
      HttpConnectionOptions(transport: HttpTransportType.webSockets),
    )
        .build();

    _connection.on('UserStatusChanged', (args) {
      print('hub called');
      print('user id is ${widget.user['user_id']}');

      if (args != null && args.length >= 2) {
        final changedUserId = args?[0].toString().replaceAll('[', '').replaceAll(']', '');
        final isOnline = args[1] as bool;

        print('${widget.user['user_id']} is the opened user and $changedUserId is the new id');

        if (changedUserId == widget.user['user_id'].toString()) {
          setState(() {
            _isOnline = isOnline;
            print('state changed');
          });
        }
      } else {
        print(' args is null or too short: $args');
      }
    });


    await _connection.start();

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
                mainAxisAlignment: _isOnline ? MainAxisAlignment.center : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.user['first_name'] ?? ''} ${widget.user['last_name'] ?? ''}".trim(),
                    style: TextStyle(
                      fontSize: _isOnline ? 16 : 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  if (_isOnline)
                    const Text(
                      "online",
                      style: TextStyle(fontSize: 12, color: Colors.white60),
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
              child: Chatlist(
                key: chatListKey,
                user: widget.user,
                messages: messages,
              ),

            ),
          ),
          MessageBar(
            user: widget.user,
            onNewMessage: (msg) {
              setState(() {
                messages.insert(0, msg);
              });

              // To notify Chatlist with animation:
              final chatListState = chatListKey.currentState;
              chatListState?.addNewMessage(msg);
            },
          ),


        ],
      ),
    );
  }
}
