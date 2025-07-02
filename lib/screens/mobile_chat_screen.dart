import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_mobile/services/signalR/SigalRService.dart';
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
  late HubConnection _connection;
  bool _isOnline = false;
  int id=0;

  @override
  void initState() {
    super.initState();
    SignalRManager().initConnection(widget.user['user_id']);
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
      'http://192.168.0.101:5246/statusHub?user_id=$id',
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
        print('❌ args is null or too short: $args');
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
              child: Chatlist(user: widget.user),
            ),
          ),
          const MessageBar(),
        ],
      ),
    );
  }
}
