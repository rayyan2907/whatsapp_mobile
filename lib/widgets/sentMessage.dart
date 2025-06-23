import 'package:flutter/material.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:flutter/cupertino.dart';


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
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imgUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imgUrl!, width: 200),
              ),
            if (caption != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(caption!, style: const TextStyle(fontSize: 14, color: Colors.white)),
              ),
          ],
        );
        break;
      case 'video':
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (videoUrl != null)
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
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 160,
              height: 40,
              color: Colors.black26,
              child: const Row(
                children: [
                  Icon(Icons.play_arrow, color: Colors.white),
                  Text("Voice Message", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            if (duration != null)
              Text("Duration: $duration", style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
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
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 100, top: 7, bottom: 7),
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
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.done_all_rounded,
                      size: 15,
                      color: isSeen ? Color.fromRGBO(65,164,238,1) : Colors.white54,
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
