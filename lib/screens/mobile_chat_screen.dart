import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/chatList.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/messageBar.dart';

import '../widgets/players/imageViewer.dart';

class MobileChatScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const MobileChatScreen({super.key, required this.user});

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
                if (user['profile_pic_url'] != null &&
                    user['profile_pic_url'].toString().isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageViewer(
                        imageUrl: user['profile_pic_url'].toString(),
                      ),
                    ),
                  );
                }
              },
              child: Hero(
                tag: user['profile_pic_url'] ?? 'default_dp',
                child: CircleAvatar(
                  radius: 17.5,
                  backgroundImage:
                  user['profile_pic_url'] != null &&
                      user['profile_pic_url'].toString().isNotEmpty
                      ? NetworkImage(user['profile_pic_url'].toString())
                      : null,
                  backgroundColor: Colors.grey,
                  child: user['profile_pic_url'] == null ||
                      user['profile_pic_url'].toString().isEmpty
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
                    "${user['first_name'] ?? ''} ${user['last_name'] ?? ''}".trim(),

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                  const Text(
                    "online", // You can replace this with a real status later
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
            icon: const Icon(CupertinoIcons.video_camera,color: Colors.white, size: 31,),
          ),
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.phone,color: Colors.white,size: 20,)),
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: Center(
              child: Chatlist(),
            ),
          ),
          MessageBar(),
        ],
      ),
    );
  }
}
