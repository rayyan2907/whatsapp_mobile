import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/services/GetMessages.dart';

class Chatlist extends StatelessWidget {
  const Chatlist({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context,index){
          if(messages[index]["is_sent"]==true){
             
          }
      },
    );
  }
}
