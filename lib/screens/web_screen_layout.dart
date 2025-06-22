import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/widgets/contactList.dart';
import 'package:whatsapp_mobile/color.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          // Left Sidebar (Contact List)
          Container(
            width: MediaQuery.of(context).size.width * 0.25, // 25% width
            color: webAppBarColor,
            child: Contactlist(),
          ),

          // Right Chat Area
          Expanded(
            child: Container(
              color: backgroundColor,
              child: const Center(
                child: Text(
                  "Select a chat to start messaging",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
