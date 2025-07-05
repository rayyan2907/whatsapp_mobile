import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/widgets/players/voicePlay.dart';

import '../containers/imageContainer.dart';

class ReceivedMessage extends StatelessWidget {
  final String type;         // 'text', 'img', 'video', 'voice'
  final String? textMsg;
  final String? imgUrl;
  final String? videoUrl;
  final String? voiceUrl;
  final String? caption;
  final Map<String, dynamic> user;

  final String? duration;
  final String date;

  const ReceivedMessage({
    Key? key,
    required this.type,
    required this.user,
    this.textMsg,
    this.imgUrl,
    this.videoUrl,
    this.voiceUrl,
    this.caption,
    this.duration,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (type) {
      case 'img':
        content = ImageMessageBubble(
          imageUrl: imgUrl!,
        );
        break;
      case 'video':
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 120,
              color: Colors.black26,
              child: const Center(child: Icon(Icons.videocam, color: Colors.white70)),
            ),
            if (caption != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(caption!, style: const TextStyle(fontSize: 14, color: Colors.white)),
              ),
            if (duration != null)
              Text("Duration: $duration", style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        );
        break;
      case 'voice':
        content = VoiceMessageBubble(
          voiceUrl: voiceUrl ?? '',
          duration: duration ?? '0:00',
          profileUrl: user['profile_pic_url'],
        );
        break;
      default:
        content = Text(
          textMsg ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(

        constraints: BoxConstraints(
          minWidth: 100,

          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: senderMessageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 20, top: 7, bottom: 20),
                child: content,
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [


                    Text(

                      date,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
