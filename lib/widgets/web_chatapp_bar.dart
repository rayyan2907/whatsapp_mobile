import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/controller/selectedUser.dart';

class WebChatappBar extends StatelessWidget {
  const WebChatappBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = seletedUser[0];

    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: webAppBarColor,
      child: Row(
        children: [
          // Profile Picture
          user['profile_pic'] != null && user['profile_pic'].toString().isNotEmpty
              ? CircleAvatar(
            radius: 22.5,
            backgroundImage: NetworkImage(user['profile_pic'].toString()),
          )
              : const CircleAvatar(
            radius: 22.5,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),

          const SizedBox(width: 12),

          // Name
          Expanded(
            child: Text(
              user['name'] ?? 'User',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Action Icons
          IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
