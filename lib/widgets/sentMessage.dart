import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_mobile/widgets/videoContainer.dart';
import 'package:whatsapp_mobile/widgets/voicePlay.dart';

import 'imageContainer.dart';


class Sentmessage extends StatelessWidget {
  final String type;         // 'text', 'img', 'video', 'voice'
  final String? textMsg;
  final String? imgUrl;
  final String? videoUrl;
  final String? voiceUrl;
  final String? caption;
  final String? duration;
  final String date;
  final bool isSeen;

  const Sentmessage({
    Key? key,
    required this.type,
    this.textMsg,
    this.imgUrl,
    this.videoUrl,
    this.voiceUrl,
    this.caption,
    this.duration,
    required this.date,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (type) {
      case 'img':
        content = ImageMessageBubble(
          imageUrl: imgUrl!,
          caption: caption,
        );
        break;
      case 'video':
        content = VideoMessageBubble(videoUrl: videoUrl!,caption: caption!,);
        break;
      case 'voice':
        content = VoiceMessageBubble(
          voiceUrl: voiceUrl ?? '',
          duration: duration ?? '0:00',
          profileUrl: "https://whatsap.blob.core.windows.net/profilepics/713d99e3-a249-4633-bf61-d2df4e55dd39.jpg",
        );
        break;


      default:
        content = Text(
          textMsg ?? '',
          style: const TextStyle(fontSize: 16,color: Colors.white),
        );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    // Duration
                    Row(
                      children: [
                        if (duration != null) ...[
                          Text(
                            duration!,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(width: 65),
                        ],
                      ],
                    ),


                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),

                    const SizedBox(width: 5),
                    Icon(
                      Icons.done_all_rounded,
                      size: 15,
                      color: isSeen ? Color.fromRGBO(65,164,220,1) : Colors.white54,
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
