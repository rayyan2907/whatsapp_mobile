import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/services/GetMessages.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/recievedMessage.dart';
import 'package:whatsapp_mobile/widgets/messagesSection/sentMessage.dart';

class Chatlist extends StatelessWidget {
  const Chatlist({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),

      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (messages[index]["is_sent"] == true) {
          return Sentmessage(
            textMsg: messages[index]['txt_msg'].toString(),
            date: messages[index]['time'].toString(),
            type: messages[index]['type'].toString(),
            imgUrl: messages[index]['img_url'].toString(),
            videoUrl: messages[index]['video_url'].toString(),
            caption: messages[index]['caption'].toString(),
            isSeen: messages[index]['is_seen'] as bool ?? false,
            duration: messages[index]['duration'].toString(),
            voiceUrl: messages[index]['voice_url'].toString(),
          );
        }
        else{
            return ReceivedMessage(
              textMsg: messages[index]['txt_msg'].toString(),
              date: messages[index]['time'].toString(),
              type: messages[index]['type'].toString(),
              imgUrl: messages[index]['img_url'].toString(),
              videoUrl: messages[index]['video_url'].toString(),
              caption: messages[index]['caption'].toString(),
              duration: messages[index]['duration'].toString(),
              voiceUrl: messages[index]['voice_url'].toString(),
            );
        }
      },
    );
  }
}
