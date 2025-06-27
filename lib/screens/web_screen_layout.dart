import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/chatList.dart';
import 'package:whatsapp_mobile/widgets/mainPages/chatsPage.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/widgets/webPages/messageBoxWeb.dart';
import 'package:whatsapp_mobile/widgets/webPages/webSearchBar.dart';
import 'package:whatsapp_mobile/widgets/webPages/web_profie_bar.dart';
import 'package:whatsapp_mobile/widgets/webPages/web_chatapp_bar.dart';

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
            child: Column(
              children: [
                WebProfileBar(),
                const WebSearchBar(),
                const Expanded(child: Contactlist()),
              ],
            ),
          ),

          // Right Chat Area
          Expanded(
            child: Container(
              color: backgroundColor,
              child: Center(
                child: Column(
                  children: [
                    const WebChatappBar(),
                   // Expanded(child: Chatlist(user: user,)),
                    const SendMessageBar(),
                  ],
                ),
              ),
            ),
          ),

        ],

      ),
    );
  }
}
